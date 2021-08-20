import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:social_app/app_cubit/cubit.dart';
import 'package:social_app/app_cubit/states.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/modules/post/post_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class HomeScreen extends StatelessWidget {
  var commentController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateTo(context, PostScreen());
        },
        child: Icon(IconBroken.Paper_Upload),
      ),
      body: Builder(
        builder: (BuildContext context) {
          AppCubit.get(context).getPosts();
          return BlocConsumer<AppCubit, AppStates>(
            listener: (context, state) {},
            builder: (context, state) {
              return Conditional.single(
                context: context,
                conditionBuilder: (context) =>
                    AppCubit.get(context).posts.length > 0 &&
                    AppCubit.get(context).likes.length > 0 &&
                    AppCubit.get(context).model! != null,
                widgetBuilder: (context) {
                  return SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Stack(
                              children: [
                                Image(
                                  image: NetworkImage(
                                    'https://cdn.pixabay.com/photo/2020/05/18/16/17/social-media-5187243_960_720.png',
                                  ),
                                  width: double.infinity,
                                  height: 180,
                                  fit: BoxFit.cover,
                                ),
                                Text(
                                  'communicate with friendes',
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .copyWith(
                                        fontSize: 14.0,
                                      ),
                                ),
                              ],
                              alignment: AlignmentDirectional.bottomEnd,
                            ),
                          ),
                          elevation: 10.0,
                          margin: EdgeInsets.all(8.0),
                          clipBehavior: Clip.hardEdge,
                        ),
                        ListView.separated(
                          reverse: true,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) => buildPostItem(
                              context,
                              AppCubit.get(context).posts[index],
                              index),
                          separatorBuilder: (context, index) => SizedBox(
                            height: 8.0,
                          ),
                          itemCount: AppCubit.get(context).posts.length,
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                      ],
                    ),
                  );
                },
                fallbackBuilder: (context) =>
                    Center(child: CircularProgressIndicator()),
              );
            },
          );
        },
      ),
    );
  }

  Widget buildPostItem(BuildContext context, PostModel model, int index) =>
      Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
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
                            '${model.name}',
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1!
                                .copyWith(),
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
                      Text(
                        '${model.dateTime}',
                        style: Theme.of(context).textTheme.caption!.copyWith(
                              color: Colors.grey,
                              height: 1,
                            ),
                      ),
                    ],
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      IconBroken.More_Circle,
                    ),
                  ),
                ],
              ),
              Divider(
                color: Colors.grey[360],
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                '${model.text}',
                style: Theme.of(context).textTheme.bodyText2!.copyWith(
                      height: 1.4,
                    ),
              ),
              Wrap(
                alignment: WrapAlignment.start,
                children: <Widget>[
                  MaterialButton(
                    onPressed: () {},
                    child: Text(
                      '#Flutter',
                      style: Theme.of(context).textTheme.caption!.copyWith(
                            color: defaultColor,
                          ),
                    ),
                    padding: EdgeInsetsDirectional.only(end: 8.0),
                    height: 10,
                    minWidth: 1,
                  ),
                  MaterialButton(
                    onPressed: () {},
                    child: Text(
                      '#Flutter',
                      style: Theme.of(context).textTheme.caption!.copyWith(
                            color: defaultColor,
                          ),
                    ),
                    padding: EdgeInsetsDirectional.only(end: 8.0),
                    height: 10,
                    minWidth: 1,
                  ),
                ],
              ),
              if (model.postImage != "")
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Image(
                    image: NetworkImage(
                      '${model.postImage}',
                    ),
                  ),
                ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      print('Love');
                    },
                    child: Row(
                      children: [
                        Icon(
                          IconBroken.Heart,
                          size: 16.0,
                          color: Colors.red,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          '${AppCubit.get(context).likes[index]}',
                          style: Theme.of(context).textTheme.caption!.copyWith(
                                color: Colors.grey,
                              ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () {
                      print('Comment');
                    },
                    child: Row(
                      children: [
                        Icon(
                          IconBroken.Chat,
                          size: 16.0,
                          color: Colors.amber,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          '0 comments',
                          style: Theme.of(context).textTheme.caption!.copyWith(
                                color: Colors.grey,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Divider(
                color: Colors.grey,
              ),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {},
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                              '${AppCubit.get(context).model!.image}',
                            ),
                            radius: 17.0,
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            'write a comment...',
                            style: Theme.of(context)
                                .textTheme
                                .caption!
                                .copyWith(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      AppCubit.get(context)
                          .likePost(AppCubit.get(context).postsId[index]);
                    },
                    child: Row(
                      children: [
                        Icon(
                          IconBroken.Heart,
                          size: 16,
                          color: Colors.red,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Like',
                          style: Theme.of(context)
                              .textTheme
                              .caption!
                              .copyWith(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  InkWell(
                    onTap: () {},
                    child: Row(
                      children: [
                        Icon(
                          IconBroken.Arrow___Up,
                          size: 16,
                          color: Colors.green,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Share',
                          style: Theme.of(context)
                              .textTheme
                              .caption!
                              .copyWith(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        elevation: 5.0,
        margin: EdgeInsets.symmetric(horizontal: 8.0),
      );
}
