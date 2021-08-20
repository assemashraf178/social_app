import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:social_app/app_cubit/cubit.dart';
import 'package:social_app/app_cubit/states.dart';
import 'package:social_app/layouts/home_layout.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/network/local/cashed_helper.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

import 'cubit/register_cubit.dart';
import 'cubit/register_states.dart';

class RegisterScreen extends StatelessWidget {
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                  onPressed: () {
                    AppCubit.get(context).changeThemeMode();
                  },
                  icon: Icon(Icons.brightness_4),
                ),
              ],
            ),
            body: Center(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Conditional.single(
                  context: context,
                  conditionBuilder: (context) =>
                      state is! AppRegisterLoadingState,
                  widgetBuilder: (context) => Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'REGISTER',
                            style:
                                Theme.of(context).textTheme.headline4!.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                          Text(
                            'register now to communicate with your friends',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(color: Colors.grey),
                          ),
                          SizedBox(
                            height: 30.0,
                          ),
                          defaultTextFromField(
                            controller: nameController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Name must not be empty';
                              }
                              return null;
                            },
                            prefix: IconBroken.User,
                            label: 'Name',
                            type: TextInputType.name,
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          defaultTextFromField(
                            controller: emailController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Email must not be empty';
                              }
                              return null;
                            },
                            prefix: IconBroken.Message,
                            label: 'Email Address',
                            type: TextInputType.emailAddress,
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          defaultTextFromField(
                            controller: phoneController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Phone must not be empty';
                              }
                              return null;
                            },
                            prefix: IconBroken.Call,
                            label: 'Phone',
                            type: TextInputType.phone,
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          defaultTextFromField(
                            controller: passwordController,
                            validator: (value) {
                              if (value.length < 6) {
                                return 'Password is too short';
                              }
                              return null;
                            },
                            prefix: IconBroken.Lock,
                            label: 'Password',
                            type: TextInputType.visiblePassword,
                            isPassword: RegisterCubit.get(context).isPassword,
                            suffixButton: IconButton(
                              onPressed: () {
                                RegisterCubit.get(context).changePasswordShow();
                              },
                              icon: Icon(
                                RegisterCubit.get(context).passwordIcon,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Conditional.single(
                            context: context,
                            conditionBuilder: (context) {
                              return state is! RegisterLoadingState;
                            },
                            widgetBuilder: (context) => defaultButton(
                              function: () {
                                if (formKey.currentState!.validate()) {
                                  print(
                                      'Email : ${emailController.text.toString()}');
                                  print(
                                      'Password : ${passwordController.text.toString()}');
                                }
                                RegisterCubit.get(context).userRegister(
                                  email: emailController.text,
                                  name: nameController.text,
                                  phone: phoneController.text,
                                  password: passwordController.text,
                                );
                              },
                              text: 'Register',
                              isUpperCase: true,
                            ),
                            fallbackBuilder: (context) =>
                                Center(child: CircularProgressIndicator()),
                          ),
                        ],
                      ),
                    ),
                  ),
                  fallbackBuilder: (context) => Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            ),
          );
        },
        listener: (context, state) {
          if (state is RegisterErrorState) {
            showToast(
              msg: state.error,
              state: ToastColor.ERROR,
            );
          }

          if (state is UserCreateSuccessState) {
            CashedHelper.setData(key: 'uId', value: state.uId);
            uId = state.uId;
            navigateToAndFinish(
              context,
              HomeLayout(),
            );
          }
        },
      ),
    );
  }
}
