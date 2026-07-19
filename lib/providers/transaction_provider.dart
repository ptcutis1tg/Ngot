import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sembast/sembast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import '../models/transactionproflie.dart';
import 'db_factory.dart';

class _SembastEncryptCodec extends Codec<Object?, String> {
  final encrypt.Encrypter _encrypter;
  final encrypt.IV _iv;

  _SembastEncryptCodec(String base64Key)
      : _encrypter = encrypt.Encrypter(encrypt.AES(encrypt.Key.fromBase64(base64Key))),
        _iv = encrypt.IV.fromLength(16);

  @override
  Converter<String, Object?> get decoder => _SembastDecryptEncoder(_encrypter, _iv);

  @override
  Converter<Object?, String> get encoder => _SembastEncryptEncoder(_encrypter, _iv);
}

class _SembastEncryptEncoder extends Converter<Object?, String> {
  final encrypt.Encrypter _encrypter;
  final encrypt.IV _iv;

  _SembastEncryptEncoder(this._encrypter, this._iv);

  @override
  String convert(Object? input) {
    final jsonStr = json.encode(input);
    final encrypted = _encrypter.encrypt(jsonStr, iv: _iv);
    return encrypted.base64;
  }
}

class _SembastDecryptEncoder extends Converter<String, Object?> {
  final encrypt.Encrypter _encrypter;
  final encrypt.IV _iv;

  _SembastDecryptEncoder(this._encrypter, this._iv);

  @override
  Object? convert(String input) {
    final decrypted = _encrypter.decrypt64(input, iv: _iv);
    return json.decode(decrypted);
  }
}

class TransactionProvider extends ChangeNotifier {
  static const String _storeName = 'transactions_store';
  static const String _dbName = 'transactions.db';
  
  final _secureStorage = const FlutterSecureStorage();
  late Database _db;
  
  final List<TransactionProfile> _transactions = [];
  bool _loaded = false;
  double _totalBalance = 0;

  List<TransactionProfile> get transactions => List.unmodifiable(_transactions);
  bool get isLoaded => _loaded;
  double get totalBalance => _totalBalance;

  Future<void> loadTransactions() async {
    if (_loaded) return;

    // 1. Get or Generate Encryption Key from Secure Storage
    String? keyStr = await _secureStorage.read(key: 'db_encryption_key');
    if (keyStr == null) {
      final key = encrypt.Key.fromSecureRandom(32);
      keyStr = key.base64;
      await _secureStorage.write(key: 'db_encryption_key', value: keyStr);
    }
    
    // 2. Initialize Sembast with Codec
    final codec = SembastCodec(
      signature: 'encrypt_v1',
      codec: _SembastEncryptCodec(keyStr),
    );
    
    String dbPath = _dbName;
    if (!kIsWeb) {
      final dir = await getApplicationDocumentsDirectory();
      dbPath = join(dir.path, _dbName);
    }
    
    final factory = getDatabaseFactory();
    _db = await factory.openDatabase(dbPath, codec: codec);
    
    // 3. Load existing records
    final store = intMapStoreFactory.store(_storeName);
    final finder = Finder(
      sortOrders: [SortOrder('time', false)],
      limit: 500,
    );
    final records = await store.find(_db, finder: finder);
    
    _transactions.clear();
    for (var record in records) {
      final t = TransactionProfile.fromJson(record.value);
      if (!t.isDeleted) {
        _transactions.add(t);
      }
    }
    
    _transactions.sort((a, b) => b.time.compareTo(a.time));
    _totalBalance = _transactions.fold<double>(0, (sum, item) => sum + item.amount);
    
    _loaded = true;
    notifyListeners();
  }

  Future<void> addTransaction(TransactionProfile transaction) async {
    _transactions.add(transaction);
    _transactions.sort((a, b) => b.time.compareTo(a.time));
    _totalBalance += transaction.amount;
    
    final store = intMapStoreFactory.store(_storeName);
    await store.add(_db, transaction.toJson());
    
    notifyListeners();
  }

  Future<void> clearTransactions() async {
    if (_transactions.isEmpty && _totalBalance == 0) return;

    _transactions.clear();
    _totalBalance = 0;
    
    final store = intMapStoreFactory.store(_storeName);
    final records = await store.find(_db);
    for (var record in records) {
      final t = TransactionProfile.fromJson(record.value);
      final updated = TransactionProfile(
        id: t.id,
        title: t.title,
        time: t.time,
        amount: t.amount,
        updatedAt: DateTime.now(),
        isDeleted: true,
        userId: t.userId,
      );
      await store.record(record.key).put(_db, updated.toJson());
    }
    
    notifyListeners();
  }

  Future<void> upsertTransactionFromSync(TransactionProfile transaction) async {
    final index = _transactions.indexWhere((t) => t.id == transaction.id);
    if (index != -1) {
      if (!_transactions[index].isDeleted) {
         _totalBalance -= _transactions[index].amount;
      }
      _transactions[index] = transaction;
    } else {
      _transactions.add(transaction);
    }
    
    if (!transaction.isDeleted) {
       _totalBalance += transaction.amount;
    }
    _transactions.sort((a, b) => b.time.compareTo(a.time));
    
    final store = intMapStoreFactory.store(_storeName);
    final finder = Finder(filter: Filter.equals('id', transaction.id));
    final records = await store.find(_db, finder: finder);
    
    if (records.isNotEmpty) {
      await store.record(records.first.key).put(_db, transaction.toJson());
    } else {
      await store.add(_db, transaction.toJson());
    }
    
    notifyListeners();
  }

  Future<List<TransactionProfile>> getAllRawTransactions() async {
    final store = intMapStoreFactory.store(_storeName);
    final records = await store.find(_db);
    return records.map((r) => TransactionProfile.fromJson(r.value)).toList();
  }
}
