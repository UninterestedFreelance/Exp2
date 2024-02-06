import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_tracker/models/expense_item.dart';

class EditTransaction extends StatefulWidget {
  final ExpanseItems oldTx;
  final Function(String, String, double, DateTime) updateTransaction;

  EditTransaction({
    required this.oldTx,
    required this.updateTransaction,
  });

  @override
  State<EditTransaction> createState() => _EditTransactionState();
}

class _EditTransactionState extends State<EditTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.oldTx.title;
    _amountController.text = widget.oldTx.amount.toString();
    _selectedDate = widget.oldTx.date;
  }

  void _submitData() {
    final updatedTitle = _titleController.text;
    final updatedAmount = double.parse(_amountController.text);
    widget.updateTransaction(
      widget.oldTx.id,
      updatedTitle,
      updatedAmount,
      _selectedDate,
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Transaction updated successfully!'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2015),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {},
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Wrap(
            children: [
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TextField(
                        controller: _titleController,
                        decoration: InputDecoration(labelText: 'Title'),
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                      TextField(
                        controller: _amountController,
                        decoration: InputDecoration(labelText: 'Amount'),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.015,
                      ),
                      Text(
                        'Selected Date',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      GestureDetector(
                        onTap: _selectDate,
                        child: Text(
                          DateFormat('dd-MM-yyyy').format(_selectedDate),
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: _submitData,
                        icon: Icon(Icons.save),
                        label: Text('Save Changes'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        behavior: HitTestBehavior.opaque,
      ),
    );
  }
}
