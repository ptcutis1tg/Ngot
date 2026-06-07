import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/transactionproflie.dart';
import 'package:flutter_application_1/providers/currency_provider.dart';
import 'package:provider/provider.dart';

class AddTransactionWidget extends StatefulWidget {
  final void Function(TransactionProfile) onAdd;
  final VoidCallback? onClose;

  const AddTransactionWidget({
    super.key,
    required this.onAdd,
    this.onClose,
  });

  @override
  State<AddTransactionWidget> createState() => _AddTransactionWidgetState();
}

class _AddTransactionWidgetState extends State<AddTransactionWidget> {
  bool _isExpense = true;
  DateTime _selectedDate = DateTime.now();
  String _expression = '0';
  String _note = '';
  String _category = 'Food';

  static const List<_CategoryOption> _categories = [
    _CategoryOption(
      label: 'Food',
      icon: Icons.restaurant,
      iconColor: Color(0xFF26EF7C),
    ),
    _CategoryOption(
      label: 'Travel',
      icon: Icons.directions_car,
      iconColor: Color(0xFF26EF7C),
    ),
    _CategoryOption(
      label: 'Shop',
      icon: Icons.shopping_bag,
      iconColor: Color(0xFF26EF7C),
    ),
    _CategoryOption(
      label: 'Bills',
      icon: Icons.receipt_long,
      iconColor: Color(0xFF26EF7C),
    ),
  ];

  void _appendValue(String input) {
    setState(() {
      if (_expression == '0' && input != '.') {
        _expression = input;
      } else {
        _expression += input;
      }
    });
  }

  void _appendOperator(String input) {
    if (_expression.isEmpty) return;
    final last = _expression[_expression.length - 1];
    if (_isOperator(last)) {
      setState(() {
        _expression = '${_expression.substring(0, _expression.length - 1)}$input';
      });
      return;
    }
    setState(() => _expression += input);
  }

  void _backspace() {
    setState(() {
      if (_expression.length <= 1) {
        _expression = '0';
      } else {
        _expression = _expression.substring(0, _expression.length - 1);
      }
    });
  }

  double _evaluate() {
    final normalized = _expression.replaceAll('x', '*').replaceAll('÷', '/');
    final tokens = <String>[];
    var current = '';

    for (var i = 0; i < normalized.length; i++) {
      final ch = normalized[i];
      if (_isOperator(ch)) {
        if (current.isNotEmpty) {
          tokens.add(current);
          current = '';
        }
        tokens.add(ch);
      } else {
        current += ch;
      }
    }
    if (current.isNotEmpty) tokens.add(current);
    if (tokens.isEmpty) return 0;

    final collapsed = <String>[tokens.first];
    for (var i = 1; i < tokens.length - 1; i += 2) {
      final op = tokens[i];
      final next = double.tryParse(tokens[i + 1]) ?? 0;
      final prev = double.tryParse(collapsed.last) ?? 0;
      if (op == '*' || op == '/') {
        collapsed.removeLast();
        final value = op == '*' ? prev * next : (next == 0 ? 0 : prev / next);
        collapsed.add(value.toString());
      } else {
        collapsed.add(op);
        collapsed.add(next.toString());
      }
    }

    var result = double.tryParse(collapsed.first) ?? 0;
    for (var i = 1; i < collapsed.length - 1; i += 2) {
      final op = collapsed[i];
      final next = double.tryParse(collapsed[i + 1]) ?? 0;
      result = op == '+' ? result + next : result - next;
    }
    return result;
  }

  bool _isOperator(String ch) => ch == '+' || ch == '-' || ch == '*' || ch == '/';

  void _save() {
    final value = _evaluate().abs();
    if (value <= 0) return;
    final title = _note.trim().isEmpty ? _category : _note.trim();

    widget.onAdd(
      TransactionProfile(
        title: title,
        time: _selectedDate,
        amount: _isExpense ? -value : value,
      ),
    );
    widget.onClose?.call();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF1CF07B),
              onPrimary: Color(0xFF001A0F),
              surface: Color(0xFF0B311F),
              onSurface: Color(0xFFE9F5EE),
            ),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currency = context.watch<CurrencyProvider>().selected.symbol;
    final value = _evaluate().abs().toStringAsFixed(2);

    return Material(
      color: const Color(0xFF041F14),
      child: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF032515), Color(0xFF042715)],
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 8, 18, 0),
                child: Row(
                  children: [
                    _CircleButton(
                      icon: Icons.close,
                      onTap: widget.onClose,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        height: 58,
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0B3A24),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: _TypeTab(
                                label: 'Expense',
                                selected: _isExpense,
                                onTap: () => setState(() => _isExpense = true),
                              ),
                            ),
                            Expanded(
                              child: _TypeTab(
                                label: 'Income',
                                selected: !_isExpense,
                                onTap: () => setState(() => _isExpense = false),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    _CircleButton(
                      icon: Icons.calendar_today_outlined,
                      onTap: _pickDate,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Text(
                '$currency$value',
                style: const TextStyle(
                  color: Color(0xFFDCE9E2),
                  fontSize: 74,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1,
                  height: 1,
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () async {
                  final controller = TextEditingController(text: _note);
                  final result = await showDialog<String>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      backgroundColor: const Color(0xFF0C3A24),
                      title: const Text(
                        'Add note',
                        style: TextStyle(color: Color(0xFFE9F5EE)),
                      ),
                      content: TextField(
                        controller: controller,
                        style: const TextStyle(color: Color(0xFFE9F5EE)),
                        decoration: const InputDecoration(
                          hintText: 'Type your note',
                          hintStyle: TextStyle(color: Color(0xFF6E8D7E)),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, controller.text),
                          child: const Text('Save'),
                        ),
                      ],
                    ),
                  );
                  if (result != null) {
                    setState(() => _note = result);
                  }
                },
                child: Text(
                  _note.trim().isEmpty ? 'Add note...' : _note,
                  style: const TextStyle(
                    color: Color(0xFF17CB72),
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.fromLTRB(14, 16, 14, 16),
                decoration: const BoxDecoration(
                  color: Color(0xFF123722),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(34)),
                ),
                child: Column(
                  children: [
                    _Numpad(
                      onNumber: _appendValue,
                      onDot: () => _appendValue('.'),
                      onOp: _appendOperator,
                      onBackspace: _backspace,
                    ),
                    const SizedBox(height: 16),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'SELECT CATEGORY TO SAVE',
                        style: TextStyle(
                          color: Color(0xFF97A8A0),
                          fontSize: 16,
                          letterSpacing: 1.3,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      height: 136,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final item = _categories[index];
                          final selected = _category == item.label;
                          return GestureDetector(
                            onTap: () => setState(() => _category = item.label),
                            child: Container(
                              width: 120,
                              decoration: BoxDecoration(
                                color: selected
                                    ? const Color(0xFF0A4A2A)
                                    : const Color(0xFF0A3B24),
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: selected
                                      ? const Color(0xFF1CF07B)
                                      : const Color(0xFF0F633D),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(item.icon, size: 38, color: item.iconColor),
                                  const SizedBox(height: 8),
                                  Text(
                                    item.label,
                                    style: const TextStyle(
                                      color: Color(0xFFD6E6DE),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemCount: _categories.length,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _save,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1CF07B),
                          foregroundColor: const Color(0xFF002A17),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Save Transaction',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TypeTab extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TypeTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF1CF07B) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? const Color(0xFF032716) : const Color(0xFF8FA39B),
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _CircleButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(28),
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: const Color(0xFF0A3B24),
          borderRadius: BorderRadius.circular(28),
        ),
        child: Icon(icon, color: const Color(0xFF1CF07B), size: 30),
      ),
    );
  }
}

class _Numpad extends StatelessWidget {
  final ValueChanged<String> onNumber;
  final VoidCallback onDot;
  final ValueChanged<String> onOp;
  final VoidCallback onBackspace;

  const _Numpad({
    required this.onNumber,
    required this.onDot,
    required this.onOp,
    required this.onBackspace,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _NumpadRow(
          children: [
            _NumberKey(label: '7', onTap: () => onNumber('7')),
            _NumberKey(label: '8', onTap: () => onNumber('8')),
            _NumberKey(label: '9', onTap: () => onNumber('9')),
            _NumberKey(label: '÷', isOp: true, onTap: () => onOp('/')),
          ],
        ),
        const SizedBox(height: 10),
        _NumpadRow(
          children: [
            _NumberKey(label: '4', onTap: () => onNumber('4')),
            _NumberKey(label: '5', onTap: () => onNumber('5')),
            _NumberKey(label: '6', onTap: () => onNumber('6')),
            _NumberKey(label: 'x', isOp: true, onTap: () => onOp('*')),
          ],
        ),
        const SizedBox(height: 10),
        _NumpadRow(
          children: [
            _NumberKey(label: '1', onTap: () => onNumber('1')),
            _NumberKey(label: '2', onTap: () => onNumber('2')),
            _NumberKey(label: '3', onTap: () => onNumber('3')),
            _NumberKey(label: '-', isOp: true, onTap: () => onOp('-')),
          ],
        ),
        const SizedBox(height: 10),
        _NumpadRow(
          children: [
            _NumberKey(label: '.', onTap: onDot),
            _NumberKey(label: '0', onTap: () => onNumber('0')),
            _NumberKey(
              label: '⌫',
              onTap: onBackspace,
              child: const Icon(Icons.backspace_outlined, color: Color(0xFFD6E6DE)),
            ),
            _NumberKey(label: '+', isOp: true, onTap: () => onOp('+')),
          ],
        ),
      ],
    );
  }
}

class _NumpadRow extends StatelessWidget {
  final List<Widget> children;

  const _NumpadRow({required this.children});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: children
          .map((e) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4), child: e)))
          .toList(),
    );
  }
}

class _NumberKey extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isOp;
  final Widget? child;

  const _NumberKey({
    required this.label,
    required this.onTap,
    this.isOp = false,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        height: 86,
        decoration: BoxDecoration(
          color: isOp ? const Color(0xFF176A38) : const Color(0xFF0A3220),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Center(
          child: child ??
              Text(
                label,
                style: TextStyle(
                  color: isOp ? const Color(0xFF1CF07B) : const Color(0xFFD6E6DE),
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                ),
              ),
        ),
      ),
    );
  }
}

class _CategoryOption {
  final String label;
  final IconData icon;
  final Color iconColor;

  const _CategoryOption({
    required this.label,
    required this.icon,
    required this.iconColor,
  });
}
