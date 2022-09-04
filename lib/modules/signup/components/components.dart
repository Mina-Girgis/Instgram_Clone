import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

Widget phoneField(){
  return IntlPhoneField(
    initialValue: "+20",
    cursorColor: Colors.white,
    showCountryFlag: false,
    showDropdownIcon:false,
    dropdownTextStyle: TextStyle(
      color: Colors.grey,
    ),
    style: TextStyle(
      color: Colors.white,
    ),
    decoration: InputDecoration(

      filled: true,
      fillColor: Color.fromRGBO(129, 128, 128, 0.5058823529411764),
      focusedBorder: OutlineInputBorder(
        gapPadding: 0.0,
        borderSide: BorderSide(color: Colors.transparent),
        borderRadius: BorderRadius.circular(10),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),),
      suffixIcon: IconButton(
        onPressed: () { },
        icon: Icon(
          FontAwesomeIcons.x,
          size: 16.0,
          color: Colors.grey,
        ),

      ),
    ),
  );
}

