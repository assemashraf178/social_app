import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:social_app/app_cubit/cubit.dart';
import 'package:social_app/app_cubit/states.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/chat_details/chat_details_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Conditional.single(
          context: context,
          conditionBuilder: (context) =>
              AppCubit.get(context).allUser.length > 0,
          widgetBuilder: (context) => ListView.separated(
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) =>
                buildChatItem(context, AppCubit.get(context).allUser[index]),
            separatorBuilder: (context, index) => Divider(),
            itemCount: AppCubit.get(context).allUser.length,
          ),
          fallbackBuilder: (context) =>
              Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget buildChatItem(BuildContext context, UserModel model) => InkWell(
        onTap: () {
          navigateTo(
              context,
              ChatDetailsScreen(
                model: model,
              ));
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                  '${model.image}',
                ),
                radius: 25.0,
              ),
              SizedBox(
                width: 10.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        // '${model.name}',
                        '${model.name}',
                        style:
                            Theme.of(context).textTheme.subtitle1!.copyWith(),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        IconBroken.Tick_Square,
                        color: defaultColor,
                        size: 15,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}
