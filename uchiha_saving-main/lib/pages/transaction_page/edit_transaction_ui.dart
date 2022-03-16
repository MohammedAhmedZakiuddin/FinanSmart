import 'package:cloud_firestore/cloud_firestore.dart' as fr;
import 'package:flutter/material.dart';
import 'package:uchiha_saving/models/category.dart';
import 'package:uchiha_saving/models/person.dart';
import 'package:uchiha_saving/models/transaction.dart';
import 'package:uchiha_saving/tools/categories_list.dart';

class EditTransactionsUI extends StatefulWidget {
  final Person person;
  final Transaction transaction;
  final String id;
  const EditTransactionsUI({
    Key? key,
    required this.person,
    required this.transaction,
    required this.id,
  }) : super(key: key);

  @override
  State<EditTransactionsUI> createState() => _EditTransactionsUIState();
}

class _EditTransactionsUIState extends State<EditTransactionsUI> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _amountController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    _titleController.dispose();
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  List<DropdownMenuItem<int>> _items = [
    DropdownMenuItem(
      child: Text("Low"),
      value: 1,
    ),
    DropdownMenuItem(
      child: Text("Medium"),
      value: 2,
    ),
    DropdownMenuItem(
      child: Text("High"),
      value: 3,
    ),
  ];

  List<DropdownMenuItem<TransactionType>> _spendTypeItems = [
    DropdownMenuItem(
      child: Text("Expense"),
      value: TransactionType.expense,
    ),
    DropdownMenuItem(
      child: Text("Income"),
      value: TransactionType.income,
    ),
  ];

  List<DropdownMenuItem<Category>> get _categoryItems => categoryList
      .map(
        (e) => DropdownMenuItem<Category>(
          child: Row(
            children: [
              Icon(e.iconData),
              SizedBox(width: 10),
              Text(e.title),
            ],
          ),
          value: e,
        ),
      )
      .toList();

  int? _priority;
  TransactionType? _transactionType;
  Category? _category;

  initialize() {
    setState(() {
      _titleController.text = widget.transaction.title;
      _descriptionController.text = widget.transaction.description;
      _amountController.text = widget.transaction.amount.toString();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            title: Text("Edit Transaction"),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          label: Text("Title"),
                        ),
                        onChanged: (val) {
                          setState(() {});
                        },
                      ),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          label: Text("Description"),
                        ),
                        maxLines: 3,
                        onChanged: (val) {
                          setState(() {});
                        },
                      ),
                      TextFormField(
                        controller: _amountController,
                        decoration: InputDecoration(
                          label: Text("Amount"),
                        ),
                        onChanged: (val) {
                          setState(() {});
                        },
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: DropdownButton<Category>(
                          items: _categoryItems,
                          underline: Center(),
                          hint: Text("Categories"),
                          value: _category,
                          key: ValueKey(_category),
                          onChanged: (val) {
                            setState(() {
                              _category = val!;
                            });
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Flexible(
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              elevation: 10,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Text("Priority"),
                                    DropdownButton<int>(
                                      items: _items,
                                      underline: Center(),
                                      hint: Text("Priority"),
                                      value: _priority,
                                      key: ValueKey(_priority),
                                      onChanged: (val) {
                                        setState(() {
                                          _priority = val!;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            child: Card(
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Text("Transaction Type"),
                                    DropdownButton<TransactionType>(
                                      items: _spendTypeItems,
                                      underline: Center(),
                                      hint: Text("Transaction Type"),
                                      value: _transactionType,
                                      key: ValueKey(_transactionType),
                                      onChanged: (val) {
                                        setState(() {
                                          _transactionType = val!;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      // ignore: deprecated_member_use
                      RaisedButton(
                        onPressed: () {
                          fr.FirebaseFirestore.instance
                              .collection("Transactions")
                              .doc(widget.person.id)
                              .collection("Transactions")
                              .doc(widget.id)
                              .update(Transaction(
                                      title: _titleController.text.trim(),
                                      description:
                                          _descriptionController.text.trim(),
                                      createdAt: widget.transaction.createdAt,
                                      amount: double.parse(
                                          _amountController.text.trim()),
                                      transactionType: _transactionType!,
                                      category: _category!,
                                      priority: _priority!)
                                  .toMap)
                              .then((value) {
                            Navigator.of(context).pop();
                          });
                        },
                        child: Text("Update"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
