import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:pro/global_bloc/global_cubit.dart';
import 'package:pro/modules/home/screens/home_screen.dart';
import 'package:pro/modules/signup/bloc/signup_cubit.dart';
import 'package:pro/services/utils/app_navigation.dart';
import 'package:pro/shared/components/components.dart';
import 'package:pro/shared/network/local/cache_helper/cache_helper.dart';

import '../../../models/user_model.dart';
import '../../../shared/components/constants.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  static LoginCubit get(context) => BlocProvider.of(context);

  var usernameController = TextEditingController();
  var passwordController = TextEditingController();

  void validEmailAndPassword(
      {required String email, required String password, required context}) async{
    emit(ValidEmailAndPasswordLoading());
    List<UserModel> users = GlobalCubit.get(context).globalUsers;
    bool valid=false;

    await Future.delayed(const Duration(seconds: 3), (){
      users.forEach((element) {
        if ((element.email == email ||
            element.username == email ||
            element.phoneNumber == email) &&
            element.password == password)
        {
          valid=true;
          GlobalCubit.get(context).changeCurrentUser(element);
          toastMessage(
            text: "Login Successfully",
            backgroundColor: GREY,
            textColor: WHITE,
          );
          emit(validEmailAndPasswordSuccess());
          CacheHelper.putData(key: 'username', value: element.username);
          print(CacheHelper.getData(key: 'username'));
          AppNavigator.customNavigator(context: context, screen: HomeScreen(), finish: true);
        }
      }
      );
      if(!valid){
        toastMessage(
          text: "User not found",
          backgroundColor: GREY,
          textColor: WHITE,
        );
        emit(validEmailAndPasswordFail());
      }

    });


  }
}
