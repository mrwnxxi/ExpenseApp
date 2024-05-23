import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:expense/provider/provider.dart';

import 'add_expense.dart';

class ExpenseSummaryScreen extends StatelessWidget {
  const ExpenseSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<ExpenseProvider>(context);

    Map<String, double> weeklyTotals = {};
    provider.expenses.forEach((expense) {
      DateTime expenseDate = expense.date;
      DateTime startOfWeek =
          expenseDate.subtract(Duration(days: expenseDate.weekday - 1));
      String weekKey = DateFormat('yyyy-MM-dd').format(startOfWeek);
      weeklyTotals[weekKey] = (weeklyTotals[weekKey] ?? 0) +
          expense.amount; // Use null-aware operator
    });

    Map<String, double> monthlyTotals = {};
    provider.expenses.forEach((expense) {
      DateTime expenseDate = expense.date;
      String monthKey = DateFormat('yyyy-MM-dd').format(expenseDate);
      monthlyTotals[monthKey] = (monthlyTotals[monthKey] ?? 0) +
          expense.amount; // Use null-aware operator
    });
    var mqh = MediaQuery.of(context).size.height;
    var mqw = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(   elevation: 0,
        leadingWidth: 30,
        leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back,size: 22,color: Colors.white,)),
        title: const Text(
          'Expense Summary',
          style: TextStyle(fontSize: 17,color: Colors.white,),
        ),),
      body: ListView(
        children: [
          SizedBox(
            height: mqh * .02,
          ),
          Container(
            height: mqh * .45,
            width: mqw * .9,
            child: SvgPicture.asset(
              "assets/svg/summary.svg",
              fit: BoxFit.contain,
            ),
          ),
          if (provider.expenses.isEmpty)
          GestureDetector(
            onTap: (){
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => AddExpenseScreen()),
              ).then((_) {
                provider.loadExpenses();
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 25.0,right: 25),
              child: Container(
                height: mqh*.2,
                  width: mqw*.3,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(.4),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black,width: 2)
                  ),
                  child: const Center(
                child: Text("Add Expense for summary",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w500),),
              )),
            ),
          ),
          if (provider.expenses.isNotEmpty)

          Card(
            child: Container(
              decoration: BoxDecoration(
                  color: const Color(0xFFFFFDE7),
                  border: Border.all(width: 2, color: Color(0xFFF0F8FF))),
              child: ListTile(
                title: const Text(
                  'Weekly Expenses',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: weeklyTotals.entries.map((entry) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            entry.key,style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.w400)),
                        Text(
                            ' Rs.${entry.value.toStringAsFixed(2)}',style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.w400)),
                      ],
                    ) ;
                  }).toList(),
                ),
              ),
            ),
          ),
          if (provider.expenses.isNotEmpty)

          Card(
            child: Container(
              decoration: BoxDecoration(
                  color: const Color(0xFFFFFDE7),
                  border: Border.all(width: 2, color: const Color(0xFFF0F8FF))),
              child: ListTile(
                title: const Text('Monthly Expenses',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: monthlyTotals.entries.map((entry) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            entry.key,style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.w400)),
                        Text(
                            ' Rs.${entry.value.toStringAsFixed(2)}',style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.w400)),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
