import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/app_cubit/cubit.dart';
import 'package:social_app/app_cubit/states.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class PostScreen extends StatelessWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var postController = TextEditingController();
    return BlocConsumer<AppCubit, AppStates>(listener: (context, state) {
      if (state is CreatePostSuccessState) {
        Navigator.pop(context);
      }
    }, builder: (context, state) {
      var userModel = AppCubit.get(context).model;
      var postImage = AppCubit.get(context).postImage;
      return Scaffold(
        appBar: defaultAppBar(
          context: context,
          title: 'Create post',
          actions: [
            defaultTextButton(
              function: () {
                var now = DateTime.now();
                if (AppCubit.get(context).postImage == null) {
                  AppCubit.get(context).createPost(
                    dateTime: now.toString(),
                    text: postController.text,
                  );
                } else {
                  AppCubit.get(context).uploadPostImage(
                    dateTime: now.toString(),
                    text: postController.text,
                  );
                }
              },
              text: 'Post',
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(
            20.0,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state is CreatePostLoadingState) LinearProgressIndicator(),
                if (state is CreatePostLoadingState)
                  SizedBox(
                    height: 10.0,
                  ),
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        '${userModel!.image}',
                      ),
                      radius: 25.0,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      '${userModel.name}',
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(),
                    ),
                  ],
                ),
                TextFormField(
                  controller: postController,
                  minLines: 1,
                  maxLines: 20,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    hintText: 'what is on your mind ${userModel.name}?...',
                    border: InputBorder.none,
                    hintStyle: Theme.of(context).textTheme.caption!.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                if (postImage != null)
                  Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 160,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: FileImage(postImage),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          radius: 16,
                          child: IconButton(
                            icon: Icon(
                              IconBroken.Close_Square,
                              size: 16,
                            ),
                            onPressed: () {
                              AppCubit.get(context).removePostImage();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          AppCubit.get(context).getPostImage();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              IconBroken.Image,
                              color: defaultColor,
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text('Add Photo'),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () {},
                        child: Text('#Tags'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
