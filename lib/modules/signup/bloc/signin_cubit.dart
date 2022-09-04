import 'package:bloc/bloc.dart';
import 'package:email_auth/email_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'signin_state.dart';

class SigninCubit extends Cubit<SigninState> {
  SigninCubit() : super(SigninInitial());

  static SigninCubit get(context) => BlocProvider.of(context);

  int signinMethodIndex = 1;
  var emailAuth = new EmailAuth(sessionName: "Instagram");

  void changeSigninMethodIndex(int index) {
    signinMethodIndex = index;
    emit(ChangeSigninMethodIndex());
  }

  void sendOtp(String s) async {
    emit(SendOTPLoading());

    await emailAuth.sendOtp(recipientMail: s, otpLength: 5).then((value) {
      print("OTP sent");
      emit(OTPSendSuccess());
    }).catchError((error) {
      print("OTP error in sending");
      emit(OTPSendFail());
    });
  }

  void verify(String email, String code) {
    bool res = emailAuth.validateOtp(
      recipientMail: email,
      userOtp: code,
    );
    if (res) {
      print("Code is Correct");
      emit(OTPCodeSuccess());
    } else {
      print("code is wrong");
      emit(OTPCodeFail());
    }
  }
}
