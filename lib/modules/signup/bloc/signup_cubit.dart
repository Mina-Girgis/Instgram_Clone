import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_auth/email_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:pro/modules/signup/signup_screen/signup_info_screen.dart';

import '../../../models/user_model.dart';
import '../../../services/utils/app_navigation.dart';
import '../../../shared/components/components.dart';
import '../../../shared/components/constants.dart';
import '../../home/screens/home_screen.dart';
import '../signup_screen/verification_screen.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit() : super(SigninInitial());

  static SignupCubit get(context) => BlocProvider.of(context);
  List<UserModel>users=[];
  var phoneController = TextEditingController();
  var emailController = TextEditingController();
  var OTPCodeController = TextEditingController();
  var userNameController = TextEditingController();
  var passwordController = TextEditingController();
  var verId;
  String phoneNumber = "";
  bool? checkBoxBoolean = false;

  int signinMethodIndex = 1;

  void changeCheckBoxBoolean(bool? x) {
    checkBoxBoolean = x;
    emit(ChangeCheckBoxBoolean());
  }

  var emailAuth = new EmailAuth(sessionName: "Instagram");

  void changeSigninMethodIndex(int index) {
    signinMethodIndex = index;
    emit(ChangeSigninMethodIndex());
  }

  void sendOtpEmail(String s, context) async {
    emit(SendOTPLoading());
    await emailAuth.sendOtp(recipientMail: s, otpLength: 5).then((value) {
      print("OTP sent");
      toastMessage(
        text: "Verification code is sent",
        textColor: WHITE,
        backgroundColor: GREY,
      );
      AppNavigator.customNavigator(
          context: context, screen: VerificationScreen(), finish: true);
      emit(OTPSendSuccess());
    }).catchError((error) {
      print("OTP error in sending");
      toastMessage(
        text: "OTP error in sending",
        textColor: WHITE,
        backgroundColor: GREY,
      );
      emit(OTPSendFail());
    });
  }

  void verifyEmail(String email, String code ,context) {
    emit(VerifyEmailAndPhoneLoading());

    bool res = emailAuth.validateOtp(
      recipientMail: email,
      userOtp: code,
    );
    if (res) {
      print("Email Code is Correct");
      toastMessage(
        text: "Verification code is correct",
        textColor: WHITE,
        backgroundColor: GREY,
      );
      AppNavigator.customNavigator(context: context, screen: SignUpInfoScreen(), finish: true);
      emit(OTPCodeSuccess());
    } else {
      print("Email code is wrong");
      toastMessage(
        text: "Verification code is wrong\nPlease try again",
        textColor: WHITE,
        backgroundColor: GREY,
      );
      emit(OTPCodeFail());
    }
  }

  Future<void> sendOTPPhoneNumber(String phoneNumber, context) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        print(e.toString());
        toastMessage(
          text: "OTP error in sending",
          textColor: WHITE,
          backgroundColor: GREY,
        );
        emit(SendOTPPhoneNumberFail());
      },
      codeSent: (String verificationId, int? resendToken) {
        verId = verificationId;
        // go to next screen
        print("Code sent");
        toastMessage(
          text: "Verification code is sent",
          textColor: WHITE,
          backgroundColor: GREY,
        );
        AppNavigator.customNavigator(
            context: context, screen: VerificationScreen(), finish: true);
        emit(SendOTPPhoneNumberSuccess());
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future<void> verifyOTPPhoneNumber(String verId, String phoneNumber,context) async {
    // Create a PhoneAuthCredential with the code
    emit(VerifyEmailAndPhoneLoading());

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verId,
      smsCode: phoneNumber,
    );
    // Sign the user in (or link) with the credential
    await FirebaseAuth.instance.signInWithCredential(credential).then((value) {
      print("Phone Code is correct");
      toastMessage(
        text: "Verification code is correct",
        textColor: WHITE,
        backgroundColor: GREY,
      );
      AppNavigator.customNavigator(context: context, screen: SignUpInfoScreen(), finish: true);
      emit(VerifyOTPPhoneNumberSuccess());
    }).catchError((error) {
      print("Phone Code is wrong");
      print(error.toString());
      print("Email code is wrong");
      toastMessage(
        text: "Verification code is wrong\nPlease try again",
        textColor: WHITE,
        backgroundColor: GREY,
      );
      emit(VerifyOTPPhoneNumberFail());
    });
  }

  void addNewUser(context) {
    emit(AddNewUserLoading());
    print(userNameController.text);
    print(passwordController.text);
    print(emailController.text);
    print(phoneController.text);
    FirebaseFirestore.instance
        .collection('users')
        .doc(userNameController.text)
        .set({
      'username': userNameController.text.toLowerCase(),
      'password': passwordController.text,
      'email': (emailController.text==null)? "":emailController.text,
      'phone': (phoneController.text==null)? "":phoneNumber,
    }).then((value) {
      toastMessage(
        text: "Sign up successfully",
        backgroundColor: GREY,
        textColor: WHITE,
      );
      AppNavigator.customNavigator(context: context, screen: HomeScreen(), finish: true);
      emit(AddNewUserSuccess());
    }).catchError((error) {
      print(error.toString());
      toastMessage(
        text: "Error happened\nPlease try again later",
        backgroundColor: GREY,
        textColor: WHITE,
      );
      emit(AddNewUserFail());
    });
  }

  void getAllUsers(){
    users.clear();
    FirebaseFirestore.instance.collection('users').get()
    .then((value){
      value.docs.forEach((element) {
        UserModel user = UserModel.fromJson(element.data());
        users.add(user);
      });
      print(users.length);
      emit(GetUsersSuccess());
    })
    .catchError((error){
      print(error.toString());
      emit(GetUsersFail());
    });


  }





}
