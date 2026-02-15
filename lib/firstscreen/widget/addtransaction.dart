import 'package:flutter/material.dart';
import 'package:flutter_application_1/firstscreen/widget/popupextension.dart';
import '../../models/transactionproflie.dart';

class AddTransactionWidget extends StatefulWidget {
  final void Function(TransactionProfile) onAdd;
  const AddTransactionWidget({Key? key, required this.onAdd}) : super(key: key);

  @override
  State<AddTransactionWidget> createState() => _AddTransactionWidgetState();
}

class _AddTransactionWidgetState extends State<AddTransactionWidget> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  double _amount = 0;
  DateTime _selectedDate = DateTime.now();

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      widget.onAdd(TransactionProfile(
        title: _title,
        time: _selectedDate,
        amount: _amount,
      ));
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black38,
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.8,
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Thêm giao dịch mới',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 16),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Tiêu đề giao dịch'),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Nhập tiêu đề' : null,
                    onSaved: (v) => _title = v ?? '',
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Số tiền'),
                    keyboardType: TextInputType.number,
                    validator: (v) => v == null || double.tryParse(v) == null
                        ? 'Nhập số tiền hợp lệ'
                        : null,
                    onSaved: (v) => _amount = double.tryParse(v ?? '') ?? 0,
                  ),
                  Row(
                    children: [
                      Text(
                          'Ngày: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
                      TextButton(
                        onPressed: () =>
                            _DatePickerWidget(onDateSelected: (date) {
                          setState(() {
                            _selectedDate = date;
                          });
                        }).showFloatingOverlay(context,
                                height: 350, width: 350),
                        child: Text('Chọn ngày'),
                      ),
                    ],
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('Hủy'),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _submit,
                        child: Text('Thêm'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DatePickerWidget extends StatelessWidget {
  final void Function(DateTime) onDateSelected;
  const _DatePickerWidget({Key? key, required this.onDateSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CalendarDatePicker(
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      onDateChanged: (date) {
        onDateSelected(date);
        Navigator.of(context).pop();
      },
    );
  }
}
