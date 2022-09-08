import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pro/shared/components/constants.dart';

import '../../services/utils/size_config.dart';

Widget defaultTextField(
    {required String hintText ,
     required controller,
     bool obscure = false,
     required String ?Function (String ?s)validator,
     required Function (String?) onChanged,
      Widget?suffixIcon,
    }) {
  return TextFormField(
    onChanged: onChanged,
    validator: validator,
    obscureText:obscure,
    controller: controller,
    cursorColor: Colors.white,
    style: TextStyle(color: Colors.white),
    decoration: InputDecoration(
      suffixIcon: (suffixIcon==null)?null: suffixIcon,
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

void toastMessage({required String text ,required Color backgroundColor ,required Color textColor , }) {
  Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor:backgroundColor,
      textColor: textColor,
      fontSize: 16.0);
}

Widget defaultButton({
  required Widget child,
  required  function,
  Color color = BUTTON_COLOR,
  bool reedOnly = false,
  double height = 5,
}){
  return  ButtonTheme(
      minWidth: SizeConfig.screenWidth!,
      height: SizeConfig.defaultSize! * height,
      child: RaisedButton(

        onPressed: function,
        color: color,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)),
        child: child,
      ));
}


/*
XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
cubit.photo=image;
cubit.changeaddPhotoIndex(1);

  */
