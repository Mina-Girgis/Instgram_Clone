import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Widget defaultTextField(
    {required String hintText ,
     required controller,
     bool obscure = false,
    }) {
  return TextFormField(
    obscureText:obscure,
    controller: controller,
    cursorColor: Colors.white,
    style: TextStyle(color: Colors.white),
    decoration: InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Color.fromRGBO(141, 141, 141, 1.0)),
      filled: true,
      fillColor: Color.fromRGBO(129, 128, 128, 0.5058823529411764),
      focusedBorder: OutlineInputBorder(
        gapPadding: 0.0,
        borderSide: BorderSide(color: Colors.transparent),
        borderRadius: BorderRadius.circular(10),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
// borderSide: BorderSide(),
      ),
    ),
  );
}

Future<dynamic> ShowDialogMessage(
    String text1, String text2, String text3, context) {
  return showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(
            text1,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          content: Text(
            text2,
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Container(
                color: Colors.transparent,
                padding: const EdgeInsets.all(14),
                child: Text(
                  text3,
                  style: TextStyle(
                    color: Colors.green,
                  ),
                ),
              ),
            ),
          ],
        );
      });
}

void snackbarMessage(String text, context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: Colors.green,
    content: Text(text),
    duration: const Duration(milliseconds: 500),
  ));
}

void toastMessage(String s) {
  Fluttertoast.showToast(
      msg: s,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}

/*
XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
cubit.photo=image;
cubit.changeaddPhotoIndex(1);

  */
