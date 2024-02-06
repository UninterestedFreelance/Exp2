import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:money_tracker/models/expense_item.dart';
import 'package:money_tracker/utils/widgets/dialog_box.dart';
import 'package:money_tracker/views/individual_transaction_list.dart';
import 'package:money_tracker/views/new_transactions.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<ExpanseItems> _userTransactions = [
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
//unused elements

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
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.opaque,
          child: NewTransaction(_addNewTransaction),
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
        title: const Text(
          "Expense Tracker",
          style: TextStyle(color: Colors.green),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: IndividualTransactionList(
                _userTransactions, _deleteTransaction, _updateTransaction),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        focusColor: Colors.green,
        backgroundColor: Color(0xff85BB65),
        onPressed: () {
          _startAddNewTransaction(context);
        },
        child: const Icon(
          Icons.add,
          color: Colors.green,
        ),
        // child: Icon(
        //   Icons.add,
        //   color: Colors.green,
        // ),
      ),
    );
  }
}
