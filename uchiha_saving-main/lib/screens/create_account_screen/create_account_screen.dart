import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uchiha_saving/models/address.dart';
import 'package:uchiha_saving/models/name.dart';
import 'package:uchiha_saving/models/person.dart';
import 'package:path/path.dart' as Path;
import 'package:uchiha_saving/tools/us_phone_formatter.dart';

class CreateAccountScreen extends StatefulWidget {
  final Person person;
  const CreateAccountScreen({Key? key, required this.person}) : super(key: key);

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  FocusNode _firstNameFocusnode = FocusNode();
  FocusNode _middleNameFocusnode = FocusNode();
  FocusNode _lastNameFocusnode = FocusNode();
  FocusNode _phoneFocusnode = FocusNode();
  FocusNode _streetFocusnode = FocusNode();
  FocusNode _roomNumberFocusnode = FocusNode();
  FocusNode _cityFocusnode = FocusNode();
  FocusNode _stateFocusnode = FocusNode();
  FocusNode _zipCodeFocusnode = FocusNode();
  FocusNode _balanceFocusNode = FocusNode();

  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _middleNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _balanceController = TextEditingController();

  TextEditingController _phoneController = TextEditingController();
  TextEditingController _streetController = TextEditingController();
  TextEditingController _roomNumberController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _stateController = TextEditingController();
  TextEditingController _zipCodeController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _sKey = GlobalKey<ScaffoldState>();

  String _photoUrl = "";
  bool _isUploading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    textControllerDispose();
    focusNodeDispose();
    super.dispose();
  }

  Future<void> chooseFile() async {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () async {
                    await ImagePicker.platform
                        .pickImage(source: ImageSource.camera)
                        .then((file) {
                      uploadFile(file!).then((url) {
                        setState(() {
                          _photoUrl = url;
                        });
                      });
                    }).then((value) => Navigator.of(ctx).pop(true));
                  },
                  icon: Icon(Icons.camera_alt),
                ),
                IconButton(
                  onPressed: () async {
                    await ImagePicker.platform
                        .pickImage(source: ImageSource.gallery)
                        .then((file) {
                      uploadFile(file!).then((url) {
                        setState(() {
                          _photoUrl = url;
                        });
                      });
                    }).then((value) => Navigator.of(ctx).pop(true));
                  },
                  icon: Icon(Icons.photo),
                ),
              ],
            ),
          );
        });
  }

  Future<String> uploadFile(PickedFile file) async {
    String _url = "";
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('${widget.person.id}/${Path.basename(file.path)}}');

    setState(() {
      _isUploading = true;
    });

    try {
      UploadTask uploadTask = storageReference.putFile(File(file.path));
      await uploadTask;
      _url = await storageReference.getDownloadURL();
    } catch (e) {
    } finally {
      setState(() {
        _isUploading = false;
      });
      Fluttertoast.showToast(
        msg: "Image has been uploaded successfully",
      );
    }
    return _url;
  }

  Future<void> submit() async {
    FirebaseFirestore.instance
        .collection("Users")
        .doc(widget.person.id)
        .set(Person(
          id: widget.person.id,
          phone: _phoneController.text.trim(),
          email: widget.person.email,
          address: Address(
              street: _streetController.text.trim(),
              roomNumber: _roomNumberController.text.trim(),
              city: _cityController.text.trim(),
              state: _stateController.text.trim(),
              zipCode: int.parse(_zipCodeController.text.trim())),
          name: Name(
            firstName: _firstNameController.text.trim(),
            middleName: _middleNameController.text.trim(),
            lastName: _lastNameController.text.trim(),
          ),
          photoURL: _photoUrl,
          balance: double.parse(
            _balanceController.text.trim(),
          ),
        ).toMap());
  }

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        key: _sKey,
        appBar: AppBar(
          title: Text("Create Account"),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(12.0),
            children: [
              Container(
                alignment: Alignment.center,
                child: _isUploading
                    ? Container(
                        height: _size.height * 0.22,
                        width: _size.height * 0.22,
                        child: FlareActor("assets/animations/Dragon.flr",
                            animation: "Untitled", color: Colors.red),
                      )
                    : Stack(
                        children: [
                          CircleAvatar(
                            radius: _size.height * 0.1,
                            backgroundImage: NetworkImage(_photoUrl),
                          ),
                          Positioned(
                            right: 10,
                            top: 10,
                            child: Card(
                              shape: CircleBorder(),
                              child: IconButton(
                                splashRadius: 100,
                                onPressed: chooseFile,
                                icon: Icon(Icons.camera_alt),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: _firstNameController,
                focusNode: _firstNameFocusnode,
                decoration: InputDecoration(
                  label: Text("First Name"),
                ),
                onChanged: (val) {
                  setState(() {});
                },
                onEditingComplete: () {
                  FocusScope.of(context).nextFocus();
                },
              ),
              TextFormField(
                controller: _middleNameController,
                focusNode: _middleNameFocusnode,
                decoration: InputDecoration(
                  label: Text("Middle Name"),
                ),
                onChanged: (val) {
                  setState(() {});
                },
                onEditingComplete: () {
                  FocusScope.of(context).nextFocus();
                },
              ),
              TextFormField(
                controller: _lastNameController,
                focusNode: _lastNameFocusnode,
                decoration: InputDecoration(
                  label: Text("Last Name"),
                ),
                onChanged: (val) {
                  setState(() {});
                },
                onEditingComplete: () {
                  FocusScope.of(context).nextFocus();
                },
              ),

              TextFormField(
                controller: _balanceController,
                focusNode: _balanceFocusNode,
                keyboardType: TextInputType.streetAddress,
                decoration: InputDecoration(
                  hintText: "1800",
                  label: Text("Initial Balance"),
                ),
                onChanged: (val) {
                  setState(() {});
                },
                onEditingComplete: () {
                  FocusScope.of(context).nextFocus();
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
                  USPhoneFormatter(),
                ],
              ),
              TextFormField(
                controller: _streetController,
                focusNode: _streetFocusnode,
                keyboardType: TextInputType.streetAddress,
                decoration: InputDecoration(
                  hintText: "Eg: 1800 Garden Rd",
                  label: Text("Street Address"),
                ),
                onChanged: (val) {
                  setState(() {});
                },
                onEditingComplete: () {
                  FocusScope.of(context).nextFocus();
                },
              ),

              Row(
                children: [
                  Flexible(
                    flex: 2,
                    child: TextFormField(
                      controller: _roomNumberController,
                      focusNode: _roomNumberFocusnode,
                      decoration: InputDecoration(
                        label: Text("Apt/Suite"),
                      ),
                      onChanged: (val) {
                        setState(() {});
                      },
                      onEditingComplete: () {
                        FocusScope.of(context).nextFocus();
                      },
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Flexible(
                    flex: 5,
                    child: TextFormField(
                      controller: _cityController,
                      focusNode: _cityFocusnode,
                      decoration: InputDecoration(
                        label: Text("City"),
                      ),
                      onChanged: (val) {
                        setState(() {});
                      },
                      onEditingComplete: () {
                        FocusScope.of(context).nextFocus();
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Flexible(
                    flex: 4,
                    child: TextFormField(
                      controller: _stateController,
                      focusNode: _stateFocusnode,
                      decoration: InputDecoration(
                        label: Text("State"),
                      ),
                      onChanged: (val) {
                        setState(() {});
                      },
                      onEditingComplete: () {
                        FocusScope.of(context).nextFocus();
                      },
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Flexible(
                    flex: 3,
                    child: TextFormField(
                      controller: _zipCodeController,
                      focusNode: _zipCodeFocusnode,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        label: Text("Zip Code"),
                      ),
                      onChanged: (val) {
                        setState(() {});
                      },
                      onEditingComplete: () {
                        FocusScope.of(context).nextFocus();
                      },
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),
              // ignore: deprecated_member_use
              RaisedButton(
                onPressed: submit,
                child: Text("Create"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  textControllerDispose() {
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _streetController.dispose();
    _roomNumberController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipCodeController.dispose();
  }

  focusNodeDispose() {
    _firstNameFocusnode.dispose();
    _middleNameFocusnode.dispose();
    _lastNameFocusnode.dispose();
    _phoneFocusnode.dispose();
    _streetFocusnode.dispose();
    _roomNumberFocusnode.dispose();
    _cityFocusnode.dispose();
    _stateFocusnode.dispose();
    _zipCodeFocusnode.dispose();
  }
}
