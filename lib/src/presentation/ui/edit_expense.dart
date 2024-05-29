import 'package:expense/src/application/services/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../infrastructure/database/hive_repository.dart';

class EditExpenseScreen extends StatefulWidget {
  final Expense expense;

  const EditExpenseScreen({super.key, required this.expense});

  @override
  _EditExpenseScreenState createState() => _EditExpenseScreenState();
}

class _EditExpenseScreenState extends State<EditExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _description;
  late double _amount;
  late DateTime _date;
  final _descriptionFocusNode = FocusNode();
  final _amountFocusNode = FocusNode();
  @override
  void dispose() {
    _descriptionFocusNode.dispose();
    _amountFocusNode.dispose();
    super.dispose();
  }
  @override
  void initState() {
    super.initState();
    _description = widget.expense.description;
    _amount = widget.expense.amount;
    _date = widget.expense.date;
  }

  void _saveExpense() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final updatedExpense = Expense(
        id: widget.expense.id,
        amount: _amount,
        date: _date,
        description: _description,
        userId: FirebaseAuth.instance.currentUser!.uid
      );
      Provider.of<ExpenseProvider>(context, listen: false)
          .updateExpense(updatedExpense);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    var mqh = MediaQuery.of(context).size.height;
    var mqw = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leadingWidth: 30,
        leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: const Icon(Icons.arrow_back,size: 22,color: Colors.white,)),
        title: const Text(
          'Edit Expense',
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
                  "assets/svg/edit.svg",
                  fit: BoxFit.contain,
                ),
              ),
              const Text(
                "Please Edit Your \nExpense",
                style: TextStyle(
                    color: Colors.black, fontSize: 28, fontFamily: "Poppins",fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: mqh * .03,
              ),
              TextFormField(
                initialValue: _description,
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
                initialValue: _amount.toString(),
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
              ),

            ],
          ),
        ),
      ),
    );
  }
}
