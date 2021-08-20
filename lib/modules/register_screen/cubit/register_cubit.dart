import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/register_screen/cubit/register_states.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  bool isPassword = true;
  IconData passwordIcon = Icons.visibility_outlined;

  void changePasswordShow() {
    isPassword = !isPassword;
    passwordIcon = isPassword == true ? IconBroken.Show : IconBroken.Hide;
    emit(RegisterShowPasswordState());
  }

  void userRegister({
    required String email,
    required String password,
    required String phone,
    required String name,
    String image =
        'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png',
    String cover =
        'https://cdn.pixabay.com/photo/2018/03/13/22/53/puzzle-3223941_960_720.jpg',
    String bio = 'write your bio...',
  }) {
    emit(RegisterLoadingState());
    print(email);
    print(password);
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      print(value.user!.email);
      print(value.user!.uid);
      createUser(
        uId: value.user!.uid,
        email: email,
        name: name,
        phone: phone,
        bio: bio,
        cover: cover,
        image: image,
        isVerificated: false,
      );
    }).catchError((error) {
      print(error.toString());
      emit(RegisterErrorState(error.toString()));
    });
  }

  void createUser({
    required String email,
    required String phone,
    required String name,
    required String uId,
    required String image,
    required String cover,
    required String bio,
    required bool isVerificated,
  }) {
    UserModel model = UserModel(
      name: name,
      email: email,
      phone: phone,
      uId: uId,
      image: image,
      cover: cover,
      bio: bio,
      isVerificated: false,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(model.toMap())
        .then((value) {
      emit(UserCreateSuccessState(uId));
    }).catchError((error) {
      print(error.toString());
      emit(UserCreateErrorState(error.toString()));
    });
  }
}
