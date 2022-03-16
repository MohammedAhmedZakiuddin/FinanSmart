import 'package:cloud_firestore/cloud_firestore.dart' as fs;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:uchiha_saving/models/person.dart';
import 'package:uchiha_saving/tools/us_phone_formatter.dart';

class EditProfilePage extends StatefulWidget {
  final Person person;
  const EditProfilePage({Key? key, required this.person}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController _firstnameController = TextEditingController();
  TextEditingController _middlenameController = TextEditingController();
  TextEditingController _lastnameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _streetnameController = TextEditingController();
  TextEditingController _roomnoController = TextEditingController();
  TextEditingController _citynameController = TextEditingController();
  TextEditingController _statenameController = TextEditingController();
  TextEditingController _zipCodeController = TextEditingController();

  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  void submit() {
    _formkey.currentState!.save();
    if (_formkey.currentState!.validate()) {
      fs.FirebaseFirestore.instance
          .collection("Users")
          .doc(widget.person.id)
          .update({
        "name": {
          "firstName": _firstnameController.text.trim(),
          "middleName": _middlenameController.text.trim(),
          "lastName": _lastnameController.text.trim(),
        },
        "phone": _phoneController.text.trim(),
        "address": {
          "street": _streetnameController.text.trim(),
          "roomNumber": _roomnoController.text.trim(),
          "city": _citynameController.text.trim(),
          "state": _statenameController.text.trim(),
          "zipCode": int.parse(_zipCodeController.text.trim()),
        }
      }).then((value) => Navigator.pop(context));
    }
  }

  String _validatePhoneNumber(String value) {
    final phoneExp = RegExp(r'^\(\d\d\d\) \d\d\d\-\d\d\d\d$');
    if (!phoneExp.hasMatch(value)) {
      return "";
    }
    return "";
  }

  final USPhoneFormatter _phoneNumberFormatter = USPhoneFormatter();

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
              pinned: true,
              title: Text("Edit profile"),
              foregroundColor:
                  ThemeProvider.controllerOf(context).currentThemeId == "dark"
                      ? Colors.white
                      : Colors.black,
              backgroundColor: Colors.transparent,
            ),
            SliverToBoxAdapter(
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                        key: _formkey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _firstnameController,
                              decoration: InputDecoration(
                                  labelText: "First Name",
                                  hintText: "Eg: kathy Jones"),
                              validator: (value) {
                                if (value == null || value.trim().length == 0) {
                                  return "Field is required";
                                }
                                return null;
                              },
                              onChanged: (val) {
                                setState(() {});
                              },
                            ),
                            TextFormField(
                              controller: _middlenameController,
                              decoration: InputDecoration(
                                  labelText: "Middle Name", hintText: "M"),
                              onChanged: (val) {
                                setState(() {});
                              },
                            ),
                            TextFormField(
                              controller: _lastnameController,
                              decoration: InputDecoration(
                                  labelText: "Last Name",
                                  hintText: "Eg: kathy Jones"),
                              validator: (value) {
                                if (value == null || value.trim().length == 0) {
                                  return "Field is required";
                                }
                                return null;
                              },
                              onChanged: (val) {
                                setState(() {});
                              },
                            ),
                            TextFormField(
                              restorationId: 'phone_number_field',
                              textInputAction: TextInputAction.next,
                              // focusNode: _phoneNumber,
                              controller: _phoneController,
                              decoration: InputDecoration(
                                // filled: true,
                                hintText: "(###) ###-####",
                                labelText: "Phone",
                                prefixText: '+1 ',
                              ),
                              keyboardType: TextInputType.phone,
                              onChanged: (val) {
                                setState(() {});
                              },
                              maxLength: 14,
                              maxLengthEnforcement: MaxLengthEnforcement.none,
                              validator: (val) {},
                              // TextInputFormatters are applied in sequence.
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                                _phoneNumberFormatter,
                              ],
                            ),
                            TextFormField(
                              controller: _streetnameController,
                              decoration: InputDecoration(
                                  labelText: "Street",
                                  hintText: "Eg: 902 Greek Row Drive"),
                              validator: (value) {
                                if (value == null || value.trim().length == 0) {
                                  return "Field is required";
                                }
                                return null;
                              },
                              onChanged: (val) {
                                setState(() {});
                              },
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  flex: 3,
                                  child: TextFormField(
                                    controller: _roomnoController,
                                    decoration: InputDecoration(
                                        labelText: "Room/Apt no:",
                                        hintText: "Eg: 215"),
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().length == 0) {
                                        return "Field is required";
                                      }
                                      return null;
                                    },
                                    onChanged: (val) {
                                      setState(() {});
                                    },
                                  ),
                                ),
                                SizedBox(width: 25),
                                Flexible(
                                  flex: 5,
                                  child: TextFormField(
                                    controller: _citynameController,
                                    decoration: InputDecoration(
                                        labelText: "City",
                                        hintText: "Eg: Arlington"),
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().length == 0) {
                                        return "Field is required";
                                      }
                                      return null;
                                    },
                                    onChanged: (val) {
                                      setState(() {});
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  flex: 4,
                                  child: TextFormField(
                                    controller: _statenameController,
                                    decoration: InputDecoration(
                                        labelText: "State",
                                        hintText: "Eg: Texas"),
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().length == 0) {
                                        return "Field is required";
                                      }
                                      return null;
                                    },
                                    onChanged: (val) {
                                      setState(() {});
                                    },
                                  ),
                                ),
                                SizedBox(width: 25),
                                Flexible(
                                  flex: 3,
                                  child: TextFormField(
                                    controller: _zipCodeController,
                                    decoration: InputDecoration(
                                        labelText: "Zip Code",
                                        hintText: "Eg: 76013"),
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().length == 0) {
                                        return "Field is required";
                                      }
                                      return null;
                                    },
                                    onChanged: (val) {
                                      setState(() {});
                                    },
                                  ),
                                ),
                              ],
                            ),
                            TextButton(
                              onPressed: () {
                                submit();
                              },
                              child: Text("Update"),
                            ),
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
