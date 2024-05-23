import 'package:hive/hive.dart';

import '../data/hive.dart';

abstract class ExpenseRepository {
  Future<void> addExpense(Expense expense,String uid);
  Future<void> deleteExpense(String id, String uid);
  Future<void> updateExpense(Expense expense, String uid);
  Future<List<Expense>> getAllExpenses(String uid);
}
class HiveExpenseRepository implements ExpenseRepository {
  final Box<Expense> expenseBox;

  HiveExpenseRepository(this.expenseBox);

  @override
  Future<void> addExpense(Expense expense,String uid) async {
    final box = await Hive.openBox<Expense>('expenses_$uid');
    await expenseBox.put(expense.id, expense);
  }

  @override
  Future<void> deleteExpense(String id, String uid) async {
    final box = await Hive.openBox<Expense>('expenses_$uid');
    await expenseBox.delete(id);
  }

  @override
  Future<void> updateExpense(Expense expense, String uid) async {
    final box = await Hive.openBox<Expense>('expenses_$uid');
    await expenseBox.put(expense.id, expense);
  }

  Future<List<Expense>> getAllExpenses(String userId) async {
    return expenseBox.values.where((expense) => expense.userId == userId).toList();
  }
}
