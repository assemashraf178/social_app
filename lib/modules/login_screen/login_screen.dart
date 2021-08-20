import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:social_app/app_cubit/cubit.dart';
import 'package:social_app/layouts/home_layout.dart';
import 'package:social_app/modules/login_screen/cubit/login_cubit.dart';
import 'package:social_app/modules/login_screen/cubit/login_states.dart';
import 'package:social_app/modules/register_screen/register_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/network/local/cashed_helper.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class LoginScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    return BlocProvider(
      create: (BuildContext context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(listener: (context, state) {
        if (state is LoginErrorState) {
          showToast(
            msg: state.error,
            state: ToastColor.ERROR,
          );
        }
        if (state is LoginSuccessState) {
          CashedHelper.setData(key: 'uId', value: state.uId);
          uId = state.uId;
          navigateToAndFinish(context, HomeLayout());
        }
      }, builder: (context, state) {
        LoginCubit cubit = LoginCubit.get(context);
        return (Scaffold(
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
              child: Form(
                key: formKey,
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'LOGIN',
                        style: Theme.of(context).textTheme.headline4!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        'login now to communicate with your friends',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(color: Colors.grey),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      defaultTextFromField(
                        onSubmitted: () {
                          if (formKey.currentState!.validate()) {
                            print('Email : ${emailController.text.toString()}');
                            print(
                                'Password : ${passwordController.text.toString()}');
                          }
                        },
                        controller: emailController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your email!';
                          }
                        },
                        prefix: IconBroken.Message,
                        label: 'Email Address',
                        type: TextInputType.emailAddress,
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      defaultTextFromField(
                        controller: passwordController,
                        validator: (value) {
                          if (value!.length < 6) {
                            return 'Password is to short';
                          }
                        },
                        prefix: IconBroken.Lock,
                        label: 'Password',
                        type: TextInputType.visiblePassword,
                        isPassword: cubit.isPassword,
                        suffixButton: IconButton(
                          onPressed: () {
                            cubit.changePasswordShow();
                          },
                          icon: Icon(
                            cubit.passwordIcon,
                          ),
                        ),
                        onSubmitted: (value) {
                          if (formKey.currentState!.validate()) {
                            print('Email : ${emailController.text.toString()}');
                            print(
                                'Password : ${passwordController.text.toString()}');
                          }
                          cubit.userLogin(
                            email: emailController.text,
                            password: passwordController.text,
                          );
                        },
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      Conditional.single(
                        context: context,
                        conditionBuilder: (context) {
                          return state is! LoginLoadingState;
                        },
                        widgetBuilder: (context) => defaultButton(
                          function: () {
                            if (formKey.currentState!.validate()) {
                              print(
                                  'Email : ${emailController.text.toString()}');
                              print(
                                  'Password : ${passwordController.text.toString()}');
                            }
                            cubit.userLogin(
                              email: emailController.text,
                              password: passwordController.text,
                            );
                          },
                          text: 'Login',
                          isUpperCase: true,
                        ),
                        fallbackBuilder: (context) =>
                            Center(child: CircularProgressIndicator()),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Don\'t have an account?',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          defaultTextButton(
                            function: () {
                              navigateTo(context, RegisterScreen());
                            },
                            text: 'register',
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
      }),
    );
  }
}
