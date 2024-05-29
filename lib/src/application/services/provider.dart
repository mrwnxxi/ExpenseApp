import 'package:expense/src/domain/repositories/expense_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../infrastructure/database/hive_repository.dart';

class ExpenseProvider with ChangeNotifier {
  final ExpenseRepository repository;
  List<Expense> _expenses = [];

  bool _isLoading = false;
  User? _currentUser;

  // final User? user = FirebaseAuth.instance.currentUser;
  List<Expense> get expenses => _expenses;
  bool get isLoading => _isLoading;

  ExpenseProvider(this.repository) {
    _currentUser = FirebaseAuth.instance.currentUser;
    if (_currentUser != null) {
      print("current user getted");
      loadExpenses();
    } else{print("No cureent user") ;}}
  // Future<void> loadExpenses() async {
  //   if(_currentUser != null) {
  //     _setLoading(true);
  //     _expenses = await repository.getAllExpenses(_currentUser!.uid);
  //     _expenses.sort((a, b) => b.date.compareTo(a.date));
  //     notifyListeners();
  //     _setLoading(false);
  //   }
  // }
  Future<void> loadExpenses() async {
    if(_currentUser != null) {
      _setLoading(true);
      print('Loading expenses for user: ${_currentUser!.uid}');
      _expenses = await repository.getAllExpenses(_currentUser!.uid);
      _expenses.sort((a, b) => b.date.compareTo(a.date));
      print('Loaded ${_expenses.length} expenses:');
      _expenses.forEach((expense) {
        print('Expense: ${expense.id}, Amount: ${expense.amount}, Date: ${expense.date}');
      });
      notifyListeners();
      _setLoading(false);
    }
  }

  Future<void> addExpense(Expense expense) async {
    if (_currentUser != null) {
      await repository.addExpense(expense, _currentUser!.uid);
      await loadExpenses();
      // notifyListeners();
    }
  }

  Future<void> deleteExpense(String id) async {
    if (_currentUser != null) {
      await repository.deleteExpense(id, _currentUser!.uid);
      await loadExpenses();
    }
  }
  double get totalExpense {
    return _expenses.fold(0.0, (sum, expense) => sum + expense.amount);
  }
  Future<void> updateExpense(Expense expense) async {
    if (_currentUser != null) {
      await repository.updateExpense(expense, _currentUser!.uid);
      await loadExpenses();
    }
  }
  void setCurrentUser(User user) {
    _currentUser = user;
    loadExpenses();
  }
  void signOut() {
    _currentUser = null;
    _expenses = [];
    notifyListeners();
  }
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
