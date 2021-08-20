import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:social_app/app_cubit/cubit.dart';
import 'package:social_app/app_cubit/states.dart';
import 'package:social_app/models/message_model.dart';
import 'package:social_app/models/notification_model.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/network/remote/dio_helper.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class ChatDetailsScreen extends StatelessWidget {
  ChatDetailsScreen({Key? key, required this.model}) : super(key: key);
  final UserModel model;
  var messageController = TextEditingController();
  var listController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        AppCubit.get(context).getMessages(
          receiverId: model.uId.toString(),
        );
        return BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {},
          builder: (context, state) {
            WidgetsBinding.instance!.addPostFrameCallback((_) {
              listController.jumpTo(listController.position.maxScrollExtent);
            });
            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(
                    IconBroken.Arrow___Left_2,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                titleSpacing: 0.0,
                title: Row(
                  children: [
                    CircleAvatar(
                      radius: 20.0,
                      backgroundImage: NetworkImage(
                        model.image.toString(),
                      ),
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    Text(model.name.toString()),
                  ],
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Expanded(
                      child: Conditional.single(
                        context: context,
                        conditionBuilder: (context) =>
                            AppCubit.get(context).messages.length > 0,
                        widgetBuilder: (context) => ListView.separated(
                          physics: BouncingScrollPhysics(),
                          controller: listController,
                          itemBuilder: (context, index) {
                            if (index ==
                                AppCubit.get(context).messages.length - 1) {
                              listController.jumpTo(
                                  listController.position.maxScrollExtent);
                              listController.jumpTo(
                                  listController.position.maxScrollExtent);
                            }
                            var message = AppCubit.get(context).messages[index];
                            if (message.senderId == uId)
                              return buildSenderMessage(message);
                            else
                              return buildReceiverMessage(message);
                          },
                          separatorBuilder: (context, index) => SizedBox(
                            height: 10.0,
                          ),
                          itemCount: AppCubit.get(context).messages.length,
                        ),
                        fallbackBuilder: (context) => Center(
                            child: Text(
                          'No messages yet....',
                          style: TextStyle(color: Colors.grey, fontSize: 25.0),
                        )),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1.0,
                                  color: Colors.grey[300] as Color,
                                ),
                                borderRadius: BorderRadius.circular(
                                  50,
                                )),
                            padding: EdgeInsets.all(
                              10,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    onTap: () {
                                      Duration(seconds: 1);
                                      listController.jumpTo(listController
                                          .position.maxScrollExtent);
                                    },
                                    keyboardType: TextInputType.text,
                                    onChanged: (s) {
                                      listController.jumpTo(listController
                                          .position.maxScrollExtent);
                                    },
                                    controller: messageController,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'type your message here...',
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    AppCubit.get(context)
                                        .getMessageImage()
                                        .then((value) {
                                      AppCubit.get(context)
                                          .uploadMessageImage()
                                          .then((value) {
                                        AppCubit.get(context).sendImageMessage(
                                          receiverID: model.uId.toString(),
                                          dateTime: DateTime.now().toString(),
                                        );
                                      });
                                    });
                                  },
                                  icon: Icon(
                                    IconBroken.Camera,
                                    color: defaultColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            IconBroken.Send,
                            color: defaultColor,
                            size: 25.0,
                          ),
                          onPressed: () {
                            if (messageController.text != '') {
                              AppCubit.get(context).sendMessage(
                                text: messageController.text,
                                receiverID: model.uId.toString(),
                                dateTime: DateTime.now().toString(),
                              );
                            }
                            messageController.text = '';
                            listController.jumpTo(
                                listController.position.maxScrollExtent);
                            DioHelper.postData(
                              url: 'https://fcm.googleapis.com/fcm/send',
                              to: model.uId.toString(),
                              data: NotificationModel(
                                  notification: NotificationOfModel(
                                title: 'Message from ${model.name}',
                                body: messageController.text,
                              )).toJson(),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildSenderMessage(MessageModel model) => Align(
        alignment: AlignmentDirectional.centerEnd,
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: model.image == null
              ? Text(model.text.toString())
              : Image(image: NetworkImage(model.image.toString())),
          decoration: BoxDecoration(
            color: defaultColor.withOpacity(0.3),
            borderRadius: BorderRadiusDirectional.only(
              topStart: Radius.circular(10.0),
              topEnd: Radius.circular(10.0),
              bottomStart: Radius.circular(10.0),
            ),
          ),
        ),
      );

  Widget buildReceiverMessage(MessageModel model) => Align(
        alignment: AlignmentDirectional.centerStart,
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: model.image == null
              ? Text(model.text.toString())
              : Image(image: NetworkImage(model.image.toString())),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadiusDirectional.only(
              topStart: Radius.circular(10.0),
              topEnd: Radius.circular(10.0),
              bottomEnd: Radius.circular(10.0),
            ),
          ),
        ),
      );
}
