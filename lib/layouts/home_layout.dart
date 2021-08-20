import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:social_app/app_cubit/cubit.dart';
import 'package:social_app/app_cubit/states.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class HomeLayout extends StatelessWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(cubit.titles[cubit.currentIndex]),
            actions: [
              IconButton(
                onPressed: () {},
                icon: Icon(
                  IconBroken.Notification,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  IconBroken.Search,
                ),
              ),
            ],
          ),
          bottomNavigationBar: SalomonBottomBar(
            items: cubit.items,
            currentIndex: cubit.currentIndex,
            onTap: (index) {
              cubit.changeNavBarItems(index);
            },
            curve: Curves.decelerate,
          ),
          body: cubit.screens[cubit.currentIndex],
        );
      },
      listener: (context, state) {},
    );
  }
}
