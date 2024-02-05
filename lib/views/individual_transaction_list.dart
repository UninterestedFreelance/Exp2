import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:money_tracker/models/expense_item.dart';
import 'package:money_tracker/views/edit_screen.dart';

class IndividualTransactionList extends StatelessWidget {
  final List<ExpanseItems> transactions;
  final Function deleteTx;
  final Function(String, String, double, DateTime) updateTransaction;

  const IndividualTransactionList(
      this.transactions, this.deleteTx, this.updateTransaction, {super.key});

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(builder: (ctx, constraints) {
            return Column(
              children: <Widget>[
                const Text(
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
            );
          })
        : ListView.builder(
            itemBuilder: (ctx, index) {
              return Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 28.0, right: 28),
                    child: Divider(),
                  ),
                  GestureDetector(
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: FittedBox(
                            child: Text('\Rs ${transactions[index].amount}'),
                          ),
                        ),
                      ),
                      title: Text(
                        transactions[index].title,
                      ),
                      subtitle: Text(
                        DateFormat.yMMMd().format(transactions[index].date),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          IconButton(
                              icon: const Icon(Icons.edit),
                              color: Theme.of(context).colorScheme.primary,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditTransaction(
                                      oldTx: transactions[index],
                                      updateTransaction: updateTransaction,
                                    ),
                                  ),
                                );
                              }),
                          if (MediaQuery.of(context).size.width > 460)
                            ElevatedButton.icon(
                              icon: const Icon(Icons.delete),
                              label: const Text('Delete'),
                              style: ElevatedButton.styleFrom(),
                              onPressed: () => deleteTx(transactions[index].id),
                            )
                          else
                            IconButton(
                              icon: const Icon(Icons.delete),
                              color: Theme.of(context).colorScheme.error,
                              onPressed: () => deleteTx(transactions[index].id),
                            ),
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditTransaction(
                            oldTx: transactions[index],
                            updateTransaction: updateTransaction,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
            itemCount: transactions.length,
          );
  }
}
