import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/app_cubit/cubit.dart';
import 'package:social_app/app_cubit/states.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class EditProfileScreen extends StatelessWidget {
  var nameController = TextEditingController();
  var bioController = TextEditingController();
  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar(
        context: context,
        title: 'Edit Profile',
        actions: [
          defaultTextButton(
            function: () {
              AppCubit.get(context).updateData(
                name: nameController.text,
                phone: phoneController.text,
                bio: bioController.text,
              );
            },
            text: 'Update',
          ),
          SizedBox(
            width: 15.0,
          ),
        ],
      ),
      body: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var model = AppCubit.get(context).model;
          var profileImage = AppCubit.get(context).profileImage;
          var coverImage = AppCubit.get(context).coverImage;
          nameController.text = model!.name!;
          bioController.text = model.bio!;
          phoneController.text = model.phone!;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  /*if (state is UpdateDataLoadingState ||
                      state is UploadProfileImageLoadingState ||
                      state is UploadCoverImageLoadingState)
                    LinearProgressIndicator(),
                  if (state is UpdateDataLoadingState ||
                      state is UploadProfileImageLoadingState ||
                      state is UploadCoverImageLoadingState)
                    SizedBox(
                      height: 15.0,
                    ),*/
                  if (state is UploadProfileImageLoadingState)
                    Column(
                      children: [
                        Text('Uploading Profile Image....'),
                        LinearProgressIndicator(),
                        SizedBox(
                          height: 15.0,
                        ),
                      ],
                    ),
                  if (state is UploadCoverImageLoadingState)
                    Column(
                      children: [
                        Text('Uploading Cover Image....'),
                        LinearProgressIndicator(),
                        SizedBox(
                          height: 15.0,
                        ),
                      ],
                    ),
                  if (state is UpdateDataLoadingState)
                    Column(
                      children: [
                        Text('Updating Data....'),
                        LinearProgressIndicator(),
                        SizedBox(
                          height: 15.0,
                        ),
                      ],
                    ),
                  Container(
                    height: 220,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Align(
                          alignment: AlignmentDirectional.topCenter,
                          child: Stack(
                            alignment: AlignmentDirectional.topEnd,
                            children: [
                              Container(
                                width: double.infinity,
                                height: 160,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8.0),
                                    topRight: Radius.circular(8.0),
                                  ),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: coverImage == null
                                        ? NetworkImage(model.cover.toString())
                                        : FileImage(coverImage)
                                            as ImageProvider,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                  radius: 16,
                                  child: IconButton(
                                    icon: Icon(
                                      IconBroken.Camera,
                                      size: 16,
                                    ),
                                    onPressed: () {
                                      AppCubit.get(context)
                                          .getCoverImage()
                                          .then((value) {
                                        AppCubit.get(context)
                                            .uploadCoverImage();
                                      }).catchError((error) {
                                        print(error.toString());
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            CircleAvatar(
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              radius: 64.0,
                              child: CircleAvatar(
                                radius: 60.0,
                                backgroundImage: profileImage == null
                                    ? NetworkImage(model.image.toString())
                                    : FileImage(profileImage) as ImageProvider,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                radius: 16,
                                child: IconButton(
                                  icon: Icon(
                                    IconBroken.Camera,
                                    size: 16,
                                  ),
                                  onPressed: () {
                                    AppCubit.get(context)
                                        .getProfileImage()
                                        .then((value) {
                                      AppCubit.get(context)
                                          .uploadProfileImage();
                                    }).catchError((error) {
                                      print(error.toString());
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  defaultTextFromField(
                      controller: nameController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Name must not be empty';
                        }
                        return null;
                      },
                      prefix: IconBroken.User,
                      label: 'Name',
                      type: TextInputType.name),
                  SizedBox(
                    height: 15.0,
                  ),
                  defaultTextFromField(
                      controller: bioController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Bio must not be empty';
                        }
                        return null;
                      },
                      prefix: IconBroken.Info_Circle,
                      label: 'Bio',
                      type: TextInputType.text),
                  SizedBox(
                    height: 15.0,
                  ),
                  defaultTextFromField(
                    controller: phoneController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Phone number must not be empty';
                      }
                      return null;
                    },
                    prefix: IconBroken.Call,
                    label: 'Phone',
                    type: TextInputType.phone,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
