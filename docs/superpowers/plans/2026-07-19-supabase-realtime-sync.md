# Supabase Realtime Sync Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Implement offline-first synchronization of Sembast/SharedPreferences data with Supabase.

**Architecture:** Add UUIDs and timestamps to local models. Implement a SyncService that pushes local changes and pulls remote updates based on `updated_at`. Handle soft deletes for transactions.

**Tech Stack:** Flutter, Supabase Flutter, Sembast, SharedPreferences, UUID.

## Global Constraints

- Dart ^3.0.0
- Offline-first architecture strictly followed.
- Last-Write-Wins (LWW) resolution for conflicts.

---

### Task 1: Update TransactionProfile Model

**Files:**
- Modify: `lib/models/transactionproflie.dart`
- Modify: `pubspec.yaml`

**Interfaces:**
- Produces: Updated `TransactionProfile` with `id`, `updated_at`, `is_deleted`, `user_id`.

- [ ] **Step 1: Add UUID dependency**

```bash
flutter pub add uuid
```

- [ ] **Step 2: Update Model Fields**

Update `lib/models/transactionproflie.dart`:
```dart
import 'package:uuid/uuid.dart';

class TransactionProfile {
  final String id;
  final String title;
  final DateTime time;
  final double amount;
  final DateTime updatedAt;
  final bool isDeleted;
  final String? userId;

  TransactionProfile({
    String? id,
    required this.title,
    required this.time,
    required this.amount,
    DateTime? updatedAt,
    this.isDeleted = false,
    this.userId,
  })  : id = id ?? const Uuid().v4(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'time': time.toIso8601String(),
      'amount': amount,
      'updated_at': updatedAt.toIso8601String(),
      'is_deleted': isDeleted,
      'user_id': userId,
    };
  }

  factory TransactionProfile.fromJson(Map<String, dynamic> json) {
    return TransactionProfile(
      id: json['id'] as String?,
      title: (json['title'] ?? '') as String,
      time: DateTime.parse(json['time'] as String),
      amount: (json['amount'] as num).toDouble(),
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at'] as String) 
          : DateTime.parse(json['time'] as String), // Fallback to creation time
      isDeleted: json['is_deleted'] == true,
      userId: json['user_id'] as String?,
    );
  }
}
```

- [ ] **Step 3: Build & Analyze**

```bash
dart analyze
```

- [ ] **Step 4: Commit**

```bash
git add pubspec.yaml pubspec.lock lib/models/transactionproflie.dart
git commit -m "feat: add UUID and sync fields to TransactionProfile"
```

### Task 2: Update TransactionProvider for Soft Delete

**Files:**
- Modify: `lib/providers/transaction_provider.dart`

**Interfaces:**
- Consumes: `TransactionProfile`
- Produces: Provider handling UUID-based mapping and soft deletion in Sembast.

- [ ] **Step 1: Implement Soft Delete and Filter**

Modify `loadTransactions` to exclude deleted records from memory, and `clearTransactions` / `deleteTransaction` to update `isDeleted = true` instead of `store.delete`.

```dart
// Code inside loadTransactions():
_transactions.clear();
for (var record in records) {
  final t = TransactionProfile.fromJson(record.value);
  if (!t.isDeleted) {
    _transactions.add(t);
  }
}
```

- [ ] **Step 2: Commit**

```bash
git add lib/providers/transaction_provider.dart
git commit -m "feat: implement soft delete for offline sync"
```

### Task 3: Create SyncService

**Files:**
- Create: `lib/services/sync_service.dart`

**Interfaces:**
- Consumes: `Supabase.instance.client`, `TransactionProvider`.

- [ ] **Step 1: Create SyncService**

```dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../providers/transaction_provider.dart';
import '../models/transactionproflie.dart';

class SyncService {
  final _supabase = Supabase.instance.client;

  Future<void> syncTransactions(TransactionProvider provider) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;
    
    // Basic structural skeleton for future sync logic
    // 1. Fetch remote data > last sync
    // 2. Resolve conflicts
    // 3. Upsert local changes to remote
  }
}
```

- [ ] **Step 2: Commit**

```bash
git add lib/services/sync_service.dart
git commit -m "feat: add SyncService mockup"
```

### Task 4: Integrate Sync Trigger

**Files:**
- Modify: `lib/main.dart`

- [ ] **Step 1: Trigger Sync on Start**

Modify `lib/main.dart` to optionally call `SyncService().syncTransactions` dynamically via a FutureBuilder or inside an Auth state listener.

- [ ] **Step 2: Commit**

```bash
git add lib/main.dart
git commit -m "feat: trigger sync on app start"
```
