import 'package:expense/provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../data/hive.dart';

class AddExpenseScreen extends StatefulWidget {
  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionFocusNode = FocusNode();
  final _amountFocusNode = FocusNode();
  String _description = '';
  double _amount = 0.0;
  DateTime _date = DateTime.now();

  void _saveExpense() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final expense = Expense(
        id: DateTime.now().toString(),
        amount: _amount,
        date: _date,
        description: _description,
        userId:FirebaseAuth.instance.currentUser!.uid
      );
      Provider.of<ExpenseProvider>(context, listen: false).addExpense(expense);
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Expense saved successfully!'),
            duration: Duration(seconds: 2),
          ));
    }
  }
  @override
  void dispose() {
    _descriptionFocusNode.dispose();
    _amountFocusNode.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    var mqh = MediaQuery.of(context).size.height;
    var mqw = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        leadingWidth: 30,
        leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: const Icon(Icons.arrow_back,size: 22,color: Colors.white,)),
        title: const Text(
          'Add Expense',
          style: TextStyle(fontSize: 17,color: Colors.white,),
        ),
        actions: [
          TextButton(
            onPressed: _saveExpense,
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: mqh * .02,
              ),
              Container(
                height: mqh * .45,
                width: mqw * .9,
                child: SvgPicture.asset(
                  "assets/svg/add.svg",
                  fit: BoxFit.contain,
                ),
              ),

              const Text(
                "Please Add Your \nExpense",
                style: TextStyle(
                    color: Colors.black, fontSize: 28, fontFamily: "Poppins",fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: mqh * .03,
              ),
              TextFormField(
                focusNode: _descriptionFocusNode,
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  labelText: 'Description',
                  labelStyle:
                      TextStyle(color: Colors.grey.shade600, fontSize: 15),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF283593), width: 2),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF283593)),
                  ),
                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  focusedErrorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_amountFocusNode);
                },
                onSaved: (value) => _description = value!,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: mqh * .03,
              ),
              TextFormField(
                focusNode: _amountFocusNode,
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  labelText: 'Amount',
                  labelStyle:
                      TextStyle(color: Colors.grey.shade600, fontSize: 15),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF283593), width: 2),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF283593)),
                  ),
                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  focusedErrorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
                keyboardType: TextInputType.number,
                onSaved: (value) => _amount = double.parse(value!),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter an amount';
                  }
                  return null;
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
