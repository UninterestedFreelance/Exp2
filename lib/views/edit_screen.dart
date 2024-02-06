import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_tracker/models/expense_item.dart';

class EditTransaction extends StatefulWidget {
  final ExpanseItems oldTx;
  final Function(String, String, double, DateTime) updateTransaction;

  const EditTransaction({
    required this.oldTx,
    required this.updateTransaction,
  });

  @override
  State<EditTransaction> createState() => _EditTransactionState();
}

class _EditTransactionState extends State<EditTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _selectdate = TextEditingController();
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Transaction updated successfully!')),
    );

    Navigator.of(context).pop();
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
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        height: 320,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
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
                height: 20,
              ),
              GestureDetector(
                child: Row(
                  children: [
                    Icon(Icons.calendar_today),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Selected Date',
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 16,
                                color: Colors.red),
                          ),
                          Text(
                            DateFormat('dd-MM-yyyy').format(_selectedDate),
                            style: TextStyle(fontSize: 14, color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                onTap: _selectDate,
              ),

              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Center(
                  child: OutlinedButton(
                    child: Text(
                      'SUBMIT',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: Colors.green),
                    ),
                    onPressed: _submitData,
                  ),
                ),
              )
              // Padding(
              //   padding: EdgeInsets.all(20),
              //   child: ElevatedButton.icon(
              //     onPressed: _submitData,
              //     icon: Icon(Icons.save),
              //     label: Text('Save Changes'),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
