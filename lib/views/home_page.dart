import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:money_tracker/models/expense_item.dart';
import 'package:money_tracker/utils/widgets/dialog_box.dart';
import 'package:money_tracker/utils/widgets/toast_message.dart';
import 'package:money_tracker/views/edit_screen.dart';
import 'package:money_tracker/views/individual_transaction_list.dart';
import 'package:money_tracker/views/new_transactions.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

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

  List<ExpanseItems> _userTransactions = [
    // Transaction(
    //   id: 't1',
    //   title: 'New Shoes',
    //   amount: 69.99,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: 't2',
    //   title: 'Weekly Groceries',
    //   amount: 16.53,
    //   date: DateTime.now(),
    // ),
  ];

  List<ExpanseItems> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime chosenDate) {
    final newTx = ExpanseItems(
      title: txTitle,
      amount: txAmount,
      date: chosenDate,
      id: DateTime.now().toString(),
    );

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    // showDialogBox(context, NewTransaction(_addNewTransaction));
    showModalBottomSheet(
      isScrollControlled: true,
      context: ctx,
      transitionAnimationController: AnimationController(
          vsync: this,
          duration: Duration(milliseconds: 700),
          reverseDuration: Duration(milliseconds: 200)),
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: NewTransaction(_addNewTransaction),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  void _updateTransaction(
      String id, String title, double amount, DateTime date) {
    final updatedTx = _userTransactions.firstWhere((tx) => tx.id == id);
    setState(() {
      updatedTx.title = title;
      updatedTx.amount = amount;
      updatedTx.date = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        shadowColor: Colors.black,
        title: Text(
          "Expense Tracker",
          style: TextStyle(color: Colors.green),
        ),
      ),
      body: _userTransactions.isEmpty
          ? Column(
              children: <Widget>[
                Text(
                  'No transactions added yet!',
                  style: TextStyle(color: Colors.black54),
                ),

                Expanded(
                  child: Lottie.asset('assets/money_adding.json'),
                )
                // SizedBox(
                //   height: constraints.maxHeight * 0.6,
                //   child: Image.asset(
                //     'assets/185019.png',
                //     fit: BoxFit.cover,
                //   ),
                // ),
              ],
            )
          : ListView.builder(
              itemBuilder: (ctx, index) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 28.0, right: 28),
                      child: Divider(),
                    ),
                    ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        child: Text(
                          _userTransactions[index].title[0],
                          style: TextStyle(fontSize: 35),
                        ),
                      ),
                      title: Text(
                        _userTransactions[index].title,
                      ),
                      subtitle: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                                _userTransactions[index].amount.toString()),
                          ),
                          Text(
                            DateFormat.yMMMd()
                                .format(_userTransactions[index].date),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          IconButton(
                              icon: Icon(Icons.edit),
                              color: Theme.of(context).colorScheme.primary,
                              onPressed: () {
                                _titleController.text =
                                    _userTransactions[index].title;
                                _amountController.text =
                                    _userTransactions[index].amount.toString();
                                showDialogBox(
                                  context,
                                  AlertDialog(
                                    content: Container(
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.3,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          TextFormField(
                                            controller: _titleController,
                                            decoration: InputDecoration(
                                                labelText: 'Title'),
                                            textInputAction:
                                                TextInputAction.next,
                                            onChanged: (value) {
                                              setState(() {});
                                            },
                                          ),
                                          TextFormField(
                                            controller: _amountController,
                                            decoration: InputDecoration(
                                                labelText: 'Amount'),
                                            keyboardType: TextInputType.number,
                                            onChanged: (value) {
                                              setState(() {});
                                            },
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.015,
                                          ),
                                          Text(
                                            'Selected Date',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                          ),
                                          GestureDetector(
                                            onTap: _selectDate,
                                            child: Text(
                                              DateFormat('dd-MM-yyyy')
                                                  .format(_selectedDate),
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          ElevatedButton.icon(
                                            onPressed: () {
                                              setState(() {
                                                _userTransactions[index].title =
                                                    _titleController.text;
                                                _userTransactions[index]
                                                        .amount =
                                                    double.parse(
                                                        _amountController.text);
                                              });

                                              showToast(
                                                  message:
                                                      'Transaction updated successfully!');
                                              Navigator.pop(context);
                                            },
                                            icon: Icon(Icons.save),
                                            label: Text('Save Changes'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                          if (MediaQuery.of(context).size.width > 460)
                            ElevatedButton.icon(
                              icon: Icon(Icons.delete),
                              label: Text('Delete'),
                              style: ElevatedButton.styleFrom(),
                              onPressed: () {
                                showDialogBox(
                                    context,
                                    AlertDialog(
                                      content: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.3,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                                'Are you sure you want to delete this transaction!'),
                                            ElevatedButton.icon(
                                              onPressed: () {
                                                _userTransactions[index].title =
                                                    _titleController.text;
                                                _userTransactions[index]
                                                        .amount =
                                                    double.parse(
                                                        _amountController.text);
                                                showToast(
                                                    message:
                                                        'Transaction updated successfully!');
                                                Navigator.pop(context);
                                              },
                                              icon: Icon(Icons.save),
                                              label: Text('Save Changes'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ));
                              },
                              // onPressed: () => _deleteTransaction(
                              //     _userTransactions[index].id),
                            )
                          else
                            IconButton(
                              icon: Icon(Icons.delete),
                              color: Theme.of(context).colorScheme.error,
                              onPressed: () {
                                showDialogBox(
                                    context,
                                    AlertDialog(
                                      title: Text(
                                          'Are you sure you want to delete this transaction!'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            setState(() {
                                              _userTransactions.removeAt(index);
                                              Navigator.pop(context);
                                            });
                                          },
                                          child: Text(
                                            'Yes',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            'No',
                                            style:
                                                TextStyle(color: Colors.green),
                                          ),
                                        )
                                      ],
                                    ));
                              },
                            ),
                        ],
                      ),
                    ),
                  ],
                );
              },
              itemCount: _userTransactions.length,
            ),
      floatingActionButton: FloatingActionButton(
        focusColor: Colors.green,
        backgroundColor: Color(0xff85BB65),
        onPressed: () {
          _startAddNewTransaction(context);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Lottie.asset('assets/add_lottie.json'),
        ),
        // child: Icon(
        //   Icons.add,
        //   color: Colors.green,
        // ),
      ),
    );
  }
}
