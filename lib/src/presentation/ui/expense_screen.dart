import 'package:expense/src/presentation/ui/summary_screen.dart';
import 'package:expense/src/utils/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../application/services/provider.dart';
import 'add_expense.dart';
import 'edit_expense.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ExpenseListScreen extends StatefulWidget {
  const ExpenseListScreen({super.key});

  @override
  State<ExpenseListScreen> createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends State<ExpenseListScreen> {
  DateTimeRange? _selectedDateRange;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final expenseProvider = Provider.of<ExpenseProvider>(context, listen: false);
      expenseProvider.loadExpenses();
    });
  }

  void _pickDateRange() async {
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      initialDateRange: _selectedDateRange,
    );

    if (picked != null && picked != _selectedDateRange) {
      setState(() {
        _selectedDateRange = picked;
      });
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final bool? shouldSignOut = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Sign Out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Sign Out'),
            ),
          ],
        );
      },
    );

    if (shouldSignOut == true) {
        await FirebaseAuth.instance.signOut();
      final expenseProvider = Provider.of<ExpenseProvider>(context,listen: false);

      expenseProvider.signOut();
      showToast(message: "Successfully signed out");
    }
  }

  Future<void> _confirmDelete(BuildContext context, String expenseId) async {
    final bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this expense?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      Provider.of<ExpenseProvider>(context, listen: false).deleteExpense(expenseId);
    }
  }
  @override
  Widget build(BuildContext context) {
    var mqh = MediaQuery.of(context).size.height;
    var mqw = MediaQuery.of(context).size.width;
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    print('Total expenses: ${expenseProvider.expenses.length}');
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   final expenseProvider = Provider.of<ExpenseProvider>(context, listen: false);
    //   expenseProvider.loadExpenses();
    // });
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        leadingWidth: 30,
        title: const Text('Expenses', style: TextStyle(fontSize: 18,color: Colors.white)),
        actions: [
          IconButton(
            onPressed: () async{
              await _confirmSignOut(context);
              Navigator.pushReplacementNamed(context, "/");

            },
            icon: const Icon(Icons.logout,color: Colors.white,),
          ),
          IconButton(
            onPressed: () {setState(() {
              expenseProvider.loadExpenses();
            });
              },
            icon: const Icon(Icons.refresh,color: Colors.white,),
          ),
          IconButton(
            icon: const Icon(Icons.view_agenda_outlined,color: Colors.white,),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ExpenseSummaryScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (expenseProvider.expenses.isEmpty)
            Column(
              children: [
                SvgPicture.asset(
                  'assets/svg/welcome.svg', // Path to your image asset
                  width: mqw * 0.5,
                  height: mqh * 0.5,fit: BoxFit.contain,
                ),
                 Text(
                  'Welcome!',
                  style: TextStyle(fontSize: 50, color:Color(0xFF283593),fontWeight: FontWeight.bold),
                ),
                 Text(
                  'Begin Your Journey With Us,',
                  style: TextStyle(height: 0.5,fontSize: 20, color:Color(0xFF283593),fontWeight: FontWeight.w500),
                ),
                SizedBox(height: mqh*.05,),
                Text(
                  'Let\'s Start By Cilcking The AddButton +',
                  style: TextStyle(fontSize: 20, color:const Color(0xFF283593).withOpacity(.5),fontWeight: FontWeight.w500),
                ),

              ],
            ),
          if (expenseProvider.expenses.isNotEmpty)

          Container(
            height: mqh * .4,
            width: mqw * .9,
            child: SvgPicture.asset(
              "assets/svg/financial.svg",
              fit: BoxFit.contain,
            ),
          ),
          if (expenseProvider.expenses.isNotEmpty)

          Consumer<ExpenseProvider>(
            builder: (context, provider, child) {
              double totalExpense = provider.expenses
                  .where((expense) {
                if (_selectedDateRange == null) return true;
                return expense.date.isAfter(_selectedDateRange!.start) &&
                    expense.date.isBefore(_selectedDateRange!.end);
              })
                  .fold(0.0, (sum, expense) => sum + expense.amount);
              return Card(
                elevation: 4,
                margin:  EdgeInsets.all(10),
                child: Container(
                  decoration:  BoxDecoration(color: Colors.white),
                  child: Padding(
                    padding:  EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                         Text(
                          'Total Expense:',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Rs.${totalExpense.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          SizedBox(height: mqh * .02),
          if (expenseProvider.expenses.isNotEmpty)
            ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: GestureDetector(
              onTap: _pickDateRange,
              child: Container(
                height: mqh * .05,
                width: mqw * .45,
                color: const Color(0xFF283593).withOpacity(.9),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     Text(
                      "Filter By Date:-",
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                    IconButton(
                      icon:  Icon(Icons.calendar_today, size: 20, color: Colors.white),
                      onPressed: _pickDateRange,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: mqh * .01),
          if (expenseProvider.expenses.isNotEmpty)

          Padding(
            padding: const EdgeInsets.only(left: 15.0,right: 15),
            child: Container(
              height: 0.8,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.grey,             // Start color
                    Colors.grey,             // Middle color
                    Colors.grey,             // End color
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          Expanded(
            child: Consumer<ExpenseProvider>(
              builder: (context, provider, child) {
                final filteredExpenses = provider.expenses.where((expense) {
                  if (_selectedDateRange == null) return true;
                  return expense.date.isAfter(_selectedDateRange!.start) &&
                      expense.date.isBefore(_selectedDateRange!.end);
                }).toList();
                print('Filtered expenses: ${filteredExpenses.length}');
                if (expenseProvider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                  itemCount: filteredExpenses.length,
                  itemBuilder: (context, index) {
                    final expense = filteredExpenses[index];
                    return Dismissible(
                      key: Key(expense.id),
                      direction: DismissDirection.endToStart,
                      confirmDismiss: (direction) async {
                          await _confirmDelete(context, expense.id);
                      },
                      onDismissed: (direction) {
                        Provider.of<ExpenseProvider>(context, listen: false)
                            .deleteExpense(expense.id);
                      },
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => EditExpenseScreen(expense: expense),
                            ),
                          );
                        },
                        child: Center(
                          child: Column(
                            children: [
                              Container(
                                height: mqh * .095,
                                width: mqw,
                                decoration: const BoxDecoration(color: Colors.white),
                                child: ListTile(
                                  title: Text(
                                    expense.description,
                                    style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 22),
                                  ),
                                  subtitle: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        DateFormat.yMMMd().format(expense.date),
                                        style: const TextStyle(color: Colors.grey,fontSize: 20),
                                      ),
                                      Text(
                                        'Rs.${expense.amount.toStringAsFixed(2)}',
                                        style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                height: .5,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.grey.withOpacity(.1), // Start color
                                      const Color(0xFF283593),           // Middle color
                                      Colors.grey.withOpacity(.1), // End color
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF283593),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AddExpenseScreen()),
          ).then((_) {
            expenseProvider.loadExpenses();
          });
        },
        child: const Icon(Icons.add,color: Colors.white,),
      ),
    );
  }
}
