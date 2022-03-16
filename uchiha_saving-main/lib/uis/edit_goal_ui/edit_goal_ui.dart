import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:uchiha_saving/models/category.dart';
import 'package:uchiha_saving/models/person.dart';
import 'package:uchiha_saving/models/save.dart';
import 'package:uchiha_saving/tools/categories_list.dart';
import 'package:uchiha_saving/tools/custom_size.dart';

class EditGoalUI extends StatefulWidget {
  final Person person;
  final Save save;
  const EditGoalUI({Key? key, required this.person, required this.save})
      : super(key: key);

  @override
  _EditGoalUIState createState() => _EditGoalUIState();
}

class _EditGoalUIState extends State<EditGoalUI> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _amountController = TextEditingController();

  String get _title => _titleController.text.trim();
  String get _description => _descriptionController.text.trim();
  double get _amount => double.parse(_amountController.text.trim());

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Category? _category;

  Timestamp? _date;

  initialize() {
    _titleController.text = widget.save.title;
    _descriptionController.text = widget.save.description;
    _amountController.text = widget.save.amount.toString();
    _date = widget.save.expiredAt;
    _category = widget.save.category;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialize();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: Text(
                "🎯 Create Goal",
                style: GoogleFonts.lato(),
              ),
              backgroundColor: Colors.transparent,
              pinned: true,
              foregroundColor:
                  ThemeProvider.controllerOf(context).currentThemeId == "dark"
                      ? Colors.white
                      : Colors.black,
            ),
            SliverToBoxAdapter(
              child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _titleController,
                              decoration: InputDecoration(
                                labelText: "Title",
                                hintText: "Eg. Car",
                              ),
                              onChanged: (val) {
                                setState(() {});
                              },
                            ),
                            SizedBox(height: customSize(context).height * 0.02),
                            TextFormField(
                              controller: _descriptionController,
                              decoration: InputDecoration(
                                labelText: "Description",
                                hintText: "Eg.Buy car from ABC",
                              ),
                              maxLines: 3,
                              onChanged: (val) {
                                setState(() {});
                              },
                            ),
                            SizedBox(height: customSize(context).height * 0.02),
                            TextFormField(
                              controller: _amountController,
                              decoration: InputDecoration(
                                labelText: "Amount",
                                hintText: "Eg.2000",
                                prefix: Text("\$ "),
                              ),
                              keyboardType: TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              onChanged: (val) {
                                setState(() {});
                              },
                            ),
                            SizedBox(height: customSize(context).height * 0.02),
                            DropdownButton<Category>(
                              isExpanded: true,
                              underline: Center(),
                              value: _category,
                              hint: Text(" Category"),
                              items: categoryList.map((Category value) {
                                return DropdownMenuItem<Category>(
                                  value: value,
                                  child: Row(
                                    children: [
                                      Icon(value.iconData),
                                      Text(" " + value.title),
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                _category = value!;
                                setState(() {});
                              },
                            ),
                            SizedBox(height: customSize(context).height * 0.02),
                            DateTimePicker(
                              type: DateTimePickerType.date,
                              initialValue: DateTime.now().toString(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2099),
                              dateMask: 'd MMM, yyyy',
                              decoration: InputDecoration(
                                label: Text("Target Date"),
                              ),
                              icon: Icon(Icons.event),
                              onChanged: (val) {
                                _date = Timestamp.fromDate(DateTime.parse(val));
                                setState(() {});
                              },
                              onSaved: (val) {
                                _date =
                                    Timestamp.fromDate(DateTime.parse(val!));
                                setState(() {});
                              },
                              validator: (val) {
                                return null;
                              },
                            ),
                            SizedBox(height: customSize(context).height * 0.02),
                            TextButton(
                                onPressed: () {
                                  FirebaseFirestore.instance
                                      .collection("Save")
                                      .doc(widget.person.id)
                                      .update(Save(
                                              amount: _amount,
                                              category: _category!,
                                              createdAt: Timestamp.now(),
                                              description: _description,
                                              expiredAt: _date!,
                                              title: _title)
                                          .toMap)
                                      .then((value) {
                                    Navigator.pop(context);
                                  });
                                },
                                child: Text("Create")),
                          ],
                        ),
                      ),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
