import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:social_app/app_cubit/states.dart';
import 'package:social_app/models/message_model.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/chat/chat_screen.dart';
import 'package:social_app/modules/home/home_screen.dart';
import 'package:social_app/modules/settings/settings_screen.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/network/local/cashed_helper.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(BuildContext context) => BlocProvider.of(context);

  bool? isDark = true;
  int currentIndex = 0;
  List<String> titles = [
    'Home',
    'Chats',
    'Settings',
  ];
  List<Widget> screens = [
    HomeScreen(),
    ChatScreen(),
    SettingsScreen(),
  ];
  List<SalomonBottomBarItem> items = [
    SalomonBottomBarItem(icon: Icon(IconBroken.Home), title: Text('Home')),
    SalomonBottomBarItem(icon: Icon(IconBroken.Chat), title: Text('Chats')),
    SalomonBottomBarItem(
        icon: Icon(IconBroken.Setting), title: Text('Setting')),
  ];

  void changeNavBarItems(int index) {
    if (index == 1) getAllUsers();
    currentIndex = index;
    emit(AppChangeNavBarState());
  }

  void changeThemeMode({
    bool? fromCashed,
  }) {
    if (fromCashed != null)
      isDark = fromCashed;
    else {
      isDark = !isDark!;
      CashedHelper.setData(key: 'isDark', value: isDark).then((value) {
        emit(AppChangeThemeModeSuccessState());
      }).catchError((error) {
        print('Change App Theme Mode Error : $error');
        emit(AppChangeThemeModeErrorState());
      });
    }
  }

  UserModel? model;
  void getUserData() {
    emit(GetUserDataLoadingState());
    uId = CashedHelper.getData(key: 'uId');
    print(uId);
    if (uId != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(uId!)
          .get()
          .then((value) {
        model = UserModel.fromJson(value.data());
        print(model!.email);
        print(model!.uId);
        print(model!.name);
        emit(GetUserDataSuccessState());
      }).catchError((error) {
        print(error.toString());
        emit(GetUserDataErrorState(error.toString()));
      });
    }
  }

  File? profileImage;
  var profilePicker = ImagePicker();

  Future<void> getProfileImage() async {
    final pickedFile =
        await profilePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(UpdateProfileImageSuccessState());
    } else {
      print('Not found any image');
      emit(UpdateProfileImageErrorState());
    }
  }

  File? coverImage;
  var coverPicker = ImagePicker();

  Future<void> getCoverImage() async {
    final pickedFile = await coverPicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      emit(UpdateProfileImageSuccessState());
    } else {
      print('Not found any image');
      emit(UpdateProfileImageErrorState());
    }
  }

  File? messageImage;
  var messagePicker = ImagePicker();

  Future<void> getMessageImage() async {
    final pickedFile =
        await messagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      messageImage = File(pickedFile.path);
      emit(UpdateProfileImageSuccessState());
    } else {
      print('Not found any image');
      emit(UpdateProfileImageErrorState());
    }
  }

  String? messageImageUploaded;
  Future<void> uploadMessageImage() async {
    emit(UploadMessageImageLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child(
            'messages/$uId/coverImage/${Uri.file(messageImage!.path).pathSegments.last}')
        .putFile(messageImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        messageImageUploaded = value;
        print(value);
        emit(UploadMessageImageSuccessState());
      }).catchError((error) {
        emit(UploadMessageImageErrorState());
      });
    }).catchError((error) {
      emit(UploadMessageImageErrorState());
    });
  }

  String? profileImageUploaded;
  void uploadProfileImage() {
    emit(UploadProfileImageLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child(
            'users/$uId/profileImage/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        profileImageUploaded = value;
        print(profileImageUploaded);
        updateData(
          name: model!.name.toString(),
          phone: model!.phone.toString(),
          bio: model!.bio.toString(),
          image: profileImageUploaded,
        );
        emit(UploadProfileImageSuccessState());
      }).catchError((error) {
        emit(UploadProfileImageErrorState());
      });
    }).catchError((error) {
      emit(UploadProfileImageErrorState());
    });
  }

  String? coverImageUploaded;
  void uploadCoverImage() {
    emit(UploadCoverImageLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child(
            'users/$uId/coverImage/${Uri.file(coverImage!.path).pathSegments.last}')
        .putFile(coverImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        coverImageUploaded = value;
        print(value);
        updateData(
          name: model!.name.toString(),
          phone: model!.phone.toString(),
          bio: model!.bio.toString(),
          cover: coverImageUploaded,
        );
        emit(UploadCoverImageSuccessState());
      }).catchError((error) {
        emit(UploadCoverImageErrorState());
      });
    }).catchError((error) {
      emit(UploadCoverImageErrorState());
    });
  }

  void updateData({
    required String name,
    required String phone,
    required String bio,
    String? image,
    String? cover,
  }) {
    emit(UpdateDataLoadingState());
    var userModel = UserModel(
      name: name,
      bio: bio,
      phone: phone,
      email: model!.email,
      isVerificated: FirebaseAuth.instance.currentUser!.emailVerified,
      uId: uId,
      cover: cover ?? model!.cover,
      image: image ?? model!.image,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId!)
        .update(userModel.toMap())
        .then((value) {
      emit(UpdateDataSuccessState());
      getUserData();
      print('Profile : $image ,  Cover : $cover');
      emit(UpdateDataSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(UpdateDataErrorState());
    });
  }

  File? postImage;
  var postPicker = ImagePicker();

  Future<void> getPostImage() async {
    final pickedFile = await postPicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(CreatePostImageSuccessState());
    } else {
      print('Not found any image');
      emit(CreatePostImageErrorState());
    }
  }

  void removePostImage() {
    postImage = null;
    emit(PostImageRemoveState());
  }

  void uploadPostImage({
    required String dateTime,
    required String text,
  }) {
    emit(CreatePostLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        createPost(
          dateTime: dateTime,
          text: text,
          postImage: value,
        );
        emit(CreatePostImageSuccessState());
      }).catchError((error) {
        emit(CreatePostImageErrorState());
      });
    }).catchError((error) {
      emit(CreatePostImageErrorState());
    });
  }

  void createPost({
    required String dateTime,
    required String text,
    String? postImage,
  }) {
    emit(CreatePostLoadingState());
    var postModel = PostModel(
      name: model!.name,
      postImage: postImage ?? '',
      uId: model!.uId,
      image: model!.image,
      dateTime: dateTime,
      text: text,
    );
    FirebaseFirestore.instance
        .collection('posts')
        .add(postModel.toMap())
        .then((value) {
      emit(CreatePostSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(CreatePostErrorState());
    });
  }

  List<PostModel> posts = [];
  List<String> postsId = [];
  List<int> likes = [];
  List<int> comments = [];
  void getPosts() {
    emit(GetPostsLoadingState());
    FirebaseFirestore.instance
        .collection('posts')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      posts = [];
      likes = [];
      event.docs.forEach((element) {
        element.reference.collection('Likes').get().then((value) {
          likes.add(value.docs.length);
          emit(GetPostsLikesSuccessState());
        }).catchError((error) {});
        // element.reference.collection('Comments').get().then((value) {
        //   comments.add(value.docs.length);
        // }).catchError((error) {});
        postsId.add(element.id);
        posts.add(PostModel.fromJson(element.data()));
        emit(GetPostsSuccessState());
      });
    });
  }

  void likePost(postId) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('Likes')
        .doc(model!.uId)
        .set({'Like': true}).then((value) {
      emit(LikePostSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(LikePostErrorState());
    });
  }

  void commentPost(String postId, String text) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('Cooments')
        .doc(model!.uId)
        .set({
      'Comment': true,
      'text': text,
    }).then((value) {
      emit(CommentPostSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(CommentPostErrorState());
    });
  }

  List<UserModel> allUser = [];
  void getAllUsers() {
    allUser = [];
    emit(GetAllUsersLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .orderBy('name')
        .snapshots()
        .listen((event) {
      event.docs.forEach((element) {
        if (element.data()['uId'] != uId)
          allUser.add(UserModel.fromJson(element.data()));
      });
      emit(GetAllUsersSuccessState());
    });
  }

  void sendMessage({
    required String text,
    required String receiverID,
    required String dateTime,
  }) {
    MessageModel model = MessageModel(
      dateTime: dateTime,
      receiverId: receiverID,
      senderId: uId,
      text: text,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(this.model!.uId)
        .collection('chats')
        .doc(receiverID)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      emit(SendMessageSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SendMessageErrorState());
    });

    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverID)
        .collection('chats')
        .doc(this.model!.uId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      emit(GetMessageSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(GetMessageErrorState());
    });
  }

  void sendImageMessage({
    required String receiverID,
    required String dateTime,
  }) {
    MessageModel model = MessageModel(
      dateTime: dateTime,
      receiverId: receiverID,
      senderId: uId,
      image: messageImageUploaded ?? '',
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(this.model!.uId)
        .collection('chats')
        .doc(receiverID)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      emit(SendMessageSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SendMessageErrorState());
    });

    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverID)
        .collection('chats')
        .doc(this.model!.uId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      emit(GetMessageSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(GetMessageErrorState());
    });
  }

  List<MessageModel> messages = [];
  void getMessages({
    required String receiverId,
  }) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      messages = [];
      event.docs.forEach((element) {
        messages.add(MessageModel.fromJson(element.data()));
      });
      print('Messages : $messages');
      emit(GetMessageSuccessState());
    });
  }
}
