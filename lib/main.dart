import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/app_cubit/cubit.dart';
import 'package:social_app/layouts/home_layout.dart';
import 'package:social_app/modules/login_screen/login_screen.dart';
import 'package:social_app/modules/native_code_screen.dart';
import 'package:social_app/shared/BlocObserver.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/network/local/cashed_helper.dart';
import 'package:social_app/shared/styles/themes.dart';

import 'app_cubit/states.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  var token = await FirebaseMessaging.instance.getToken();

  FirebaseMessaging.onMessage.listen((event) {
    print(event.data.toString());
    print(event.notification.toString());
    showToast(msg: 'On Message', state: ToastColor.SUCCESS);
  });

  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    print(event.data.toString());
    print(event.notification.toString());
    showToast(msg: 'On Message Opened App', state: ToastColor.SUCCESS);
  });

  FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async {
    print(message.data.toString());
    print(message.notification.toString());
    showToast(msg: 'On Background Message', state: ToastColor.SUCCESS);
  });
  print(token.toString());
  Bloc.observer = MyBlocObserver();
  await CashedHelper.init();
  bool? isDark = CashedHelper.getData(key: 'isDark');
  String? uId = CashedHelper.getData(key: 'uId');
  Widget? widget;
  if (uId != null)
    widget = HomeLayout();
  else
    widget = LoginScreen();

  print(uId);

  runApp(MyApp(
    isDark: isDark,
    startWidget: widget,
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final bool? isDark;
  final Widget? startWidget;

  const MyApp({Key? key, required this.isDark, required this.startWidget})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()
        ..changeThemeMode(fromCashed: isDark)
        ..getUserData(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            theme: lightMode(),
            darkTheme: darkMode(),
            themeMode: AppCubit.get(context).isDark == true
                ? ThemeMode.dark
                : ThemeMode.light,
            home: NativeCodeScreen(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
