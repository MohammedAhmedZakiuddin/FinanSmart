import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:uchiha_saving/models/person.dart';
import 'package:path/path.dart' as Path;

class ImageLogo extends StatefulWidget {
  final Person person;
  const ImageLogo({Key? key, required this.person}) : super(key: key);

  @override
  State<ImageLogo> createState() => _ImageLogoState();
}

class _ImageLogoState extends State<ImageLogo> {
  bool _isUploading = false;

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
                        FirebaseFirestore.instance
                            .collection("Users")
                            .doc(widget.person.id)
                            .update({
                          "photoURL": url,
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
                        FirebaseFirestore.instance
                            .collection("Users")
                            .doc(widget.person.id)
                            .update({
                          "photoURL": url,
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

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Stack(
      children: [
        _isUploading
            ? Container(
                width: MediaQuery.of(context).size.height * 0.16,
                height: MediaQuery.of(context).size.height * 0.16,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: CircularProgressIndicator(),
              )
            : widget.person.photoURL == ""
                ? Container(
                    width: MediaQuery.of(context).size.height * 0.16,
                    height: MediaQuery.of(context).size.height * 0.16,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      widget.person.name.firstName[0] +
                          widget.person.name.lastName[0],
                      style: GoogleFonts.lato(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.height * 0.07,
                        letterSpacing: 1.5,
                      ),
                    ),
                  )
                : ClipOval(
                    child: Material(
                      color: Colors.transparent,
                      child: Ink.image(
                        image: NetworkImage(widget.person.photoURL),
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.height * 0.16,
                        height: MediaQuery.of(context).size.height * 0.16,
                        child: InkWell(),
                      ),
                    ),
                  ),
        Positioned(
          bottom: 0,
          right: 4,
          child: ClipOval(
            child: InkWell(
              borderRadius: BorderRadius.circular(100),
              onTap: chooseFile,
              child: Container(
                padding: EdgeInsets.all(8.0),
                color:
                    ThemeProvider.controllerOf(context).currentThemeId == "dark"
                        ? Colors.white
                        : Colors.black,
                child: Icon(
                  Icons.add_a_photo,
                  color: ThemeProvider.controllerOf(context).currentThemeId ==
                          "dark"
                      ? Colors.black
                      : Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
