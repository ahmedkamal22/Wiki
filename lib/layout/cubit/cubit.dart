import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire/layout/cubit/states.dart';
import 'package:fire/models/comment/comment.dart';
import 'package:fire/models/message/message_model.dart';
import 'package:fire/models/post/post.dart';
import 'package:fire/models/user/user_model.dart';
import 'package:fire/modules/chats/chats.dart';
import 'package:fire/modules/feeds/feeds.dart';
import 'package:fire/modules/posts/posts.dart';
import 'package:fire/modules/profile/profile.dart';
import 'package:fire/shared/components/components.dart';
import 'package:fire/shared/components/constants.dart';
import 'package:fire/shared/network/local/cache_helper.dart';
import 'package:fire/shared/network/remote/dio_helper.dart';
import 'package:fire/shared/styles/icon_broken.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  bool isDark = true;

  changeMode({bool? fromShared}) {
    if (fromShared != null) {
      isDark = fromShared;
      emit(AppChangeModeState());
    } else {
      isDark = !isDark;
      CacheHelper.saveData(key: "isDark", value: isDark).then((value) {
        emit(AppChangeModeState());
      });
    }
  }

  UserModel? userModel;

  getUserData() {
    emit(AppGetDataLoadingState());
    FirebaseFirestore.instance.collection("users").doc(uId).get().then((value) {
      userModel = UserModel.fromJson(value.data()!);
      emit(AppGetDataSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(AppGetDataFailureState(error.toString()));
    });
  }

  int currentIndex = 0;

  changeBottomNav(int index) {
    if (index == 1) getAllUsers();
    if (index == 2) {
      emit(AppNewPostState());
    } else {
      currentIndex = index;
      emit(AppChangeBottomNavState());
    }
  }

  List<Widget> screens = [
    FeedsScreen(),
    const ChatsScreen(),
    PostsScreen(),
    const ProfileScreen(),
  ];
  List<String> titels = [
    "Home",
    "Chats",
    "Posts",
    "Profile",
  ];

  List<BottomNavigationBarItem> items = [
    const BottomNavigationBarItem(
      icon: Icon(IconBroken.Home),
      label: "Home",
    ),
    const BottomNavigationBarItem(
      icon: Icon(IconBroken.Chat),
      label: "Chats",
    ),
    const BottomNavigationBarItem(
      icon: Icon(IconBroken.Paper_Upload),
      label: "Post",
    ),
    const BottomNavigationBarItem(
      icon: Icon(IconBroken.Profile),
      label: "Profile",
    ),
  ];

  File? profileImage;
  var picker = ImagePicker();

  Future<void> getProfileImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      print(pickedFile.path);
      emit(AppGetProfileImagePickedSuccessState());
    } else {
      print('No image selected.');
      emit(AppGetProfileImagePickedFailureState());
    }
  }

  File? coverImage;

  Future<void> getCoverImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      emit(AppGetCoverImagePickedSuccessState());
    } else {
      print('No image selected.');
      emit(AppGetCoverImagePickedFailureState());
    }
  }

  uploadProfileImage({
    required String name,
    required String bio,
    required String email,
    required String phone,
  }) {
    emit(AppUpdateImageLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child("users/${Uri.file(profileImage!.path).pathSegments.last}")
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        print(value);
        updateData(
          name: name,
          bio: bio,
          email: email,
          phone: phone,
          image: value,
        );
      }).catchError((error) {
        print(error.toString());
        emit(AppUploadProfileImageFailureState());
      });
    }).catchError((error) {
      emit(AppUploadProfileImageFailureState());
    });
  }

  uploadCoverImage({
    required String name,
    required String bio,
    required String email,
    required String phone,
  }) {
    emit(AppUpdateCoverLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child("users/${Uri.file(coverImage!.path).pathSegments.last}")
        .putFile(coverImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        print(value);
        updateData(
            name: name, bio: bio, email: email, phone: phone, cover: value);
      }).catchError((error) {
        emit(AppUploadCoverImageFailureState());
      });
    }).catchError((error) {
      emit(AppUploadCoverImageFailureState());
    });
  }

  updateData({
    required String name,
    required String bio,
    required String email,
    required String phone,
    String? image,
    String? cover,
  }) {
    emit(AppUpdateDataLoadingState());
    UserModel model = UserModel(
      image: image ?? userModel!.image,
      bio: bio,
      cover: cover ?? userModel!.cover,
      email: email,
      name: name,
      phone: phone,
      uId: userModel!.uId,
      isEmailVerified: false,
    );
    FirebaseFirestore.instance
        .collection("users")
        .doc(userModel!.uId)
        .update(model.toMap())
        .then((value) {
      getUserData();
    }).catchError((error) {
      emit(AppUpdateDataErrorState());
    });
  }

  File? postImage;

  Future<void> getPostImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(AppGetPostImagePickedSuccessState());
    } else {
      print('No image selected.');
      emit(AppGetPostImagePickedFailureState());
    }
  }

  uploadPost({
    required postData,
    required postText,
  }) {
    emit(AppCreatePostLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child("posts/${Uri.file(postImage!.path).pathSegments.last}")
        .putFile(postImage!)
        .then((value) {
      value.ref.getDownloadURL().then((imageLink) {
        createPost(
            postData: postData, postText: postText, postImage: imageLink);
        print(imageLink);
      }).catchError((error) {
        emit(AppCreatePostFailureState());
      });
    }).catchError((error) {
      emit(AppCreatePostFailureState());
    });
  }

  createPost({required postData, required postText, String? postImage}) {
    PostsModel model = PostsModel(
      name: userModel!.name,
      image: userModel!.image,
      postDate: postData,
      postImage: postImage ?? "Without post image..",
      postText: postText,
      uId: userModel!.uId,
    );
    FirebaseFirestore.instance
        .collection("posts")
        .add(model.toMap()!)
        .then((value) {
      emit(AppCreatePostSuccessState());
    }).catchError((error) {
      emit(AppCreatePostFailureState());
    });
  }

  removePostImage() {
    postImage = null;
    emit(AppRemovePostImageState());
  }

  List<PostsModel> posts = [];
  List<String> postId = [];
  List<String> commentId = [];

  // List<int> postLikes = [];
  Map<String, int> postLikes = {};
  Map<String, int> commentNum = {};

  getPosts() {
    emit(AppGetPostsLoadingState());
    FirebaseFirestore.instance
        .collection("posts")
        .orderBy("postDate")
        .snapshots()
        .listen((value) {
      posts = [];
      for (var comment in value.docs) {
        comment.reference.collection("comments").snapshots().listen((value) {
          comments = [];
          commentId.add(comment.id);
          commentNum.addAll({comment.id: value.docs.length});
          emit(AppGetPostsSuccessState());
        });
      }
      for (var like in value.docs) {
        like.reference.collection("likes").snapshots().listen((value) {
          postLikes.addAll({like.id: value.docs.length});
          postId.add(like.id);
          posts.add(PostsModel.fromJson(like.data()));
          emit(AppGetPostsSuccessState());
        });
      }
    });
  }

  likePost(postId) {
    FirebaseFirestore.instance
        .collection("posts")
        .doc(postId)
        .collection("likes")
        // .doc(userModel!.uId)
        .add({"liked": true}).then((value) {
      emit(AppLikePostSuccessState());
    }).catchError((error) {
      emit(AppLikePostFailureState());
    });
  }

  File? commentImage;

  Future<void> getCommentImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      commentImage = File(pickedFile.path);
      emit(AppGetCommentImagePickedSuccessState());
    } else {
      print('No image selected.');
      emit(AppGetCommentImagePickedFailureState());
    }
  }

  Future<void>? uploadCommentImage({
    required String commentId,
    required String commentText,
    required String commentDate,
  }) {
    emit(AppCommentPostLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child("comments/${Uri.file(commentImage!.path).pathSegments.last}")
        .putFile(commentImage!)
        .then((value) {
      value.ref.getDownloadURL().then((imageUrl) {
        commentPost(
            commentId: commentId,
            commentText: commentText,
            commentDate: commentDate,
            commentImage: imageUrl);
        print(imageUrl);
      }).catchError((error) {
        emit(AppCommentPostFailureState());
      });
    }).catchError((error) {
      emit(AppCommentPostFailureState());
    });
  }

  commentPost({
    required String commentId,
    required String commentText,
    required String commentDate,
    String? commentImage,
  }) {
    CommentModel model = CommentModel(
        uId: userModel!.uId,
        image: userModel!.image,
        name: userModel!.name,
        commentText: commentText,
        commentDate: commentDate,
        commentImage: commentImage ?? "Without comment image...");
    FirebaseFirestore.instance
        .collection("posts")
        .doc(commentId)
        .collection("comments")
        .add(model.toMap()!)
        .then((value) {
      emit(AppCommentPostSuccessState());
    }).catchError((error) {
      emit(AppCommentPostFailureState());
    });
  }

  deletePost({
    required String postId,
  }) {
    FirebaseFirestore.instance
        .collection("posts")
        .doc(postId)
        .delete()
        .then((value) {
      posts.clear();
      getPosts();
      showToast(msg: "post deleted", state: ToastStates.Success);
      emit(AppPostDeleteSuccessState());
    }).catchError((error) {
      emit(AppPostDeleteFailureState());
    });
  }

  deleteComment({
    required String postId,
  }) {
    FirebaseFirestore.instance
        .collection("posts")
        .doc(postId)
        .collection("comments")
        .get()
        .then((value) {
      for (var element in value.docs) {
        element.reference.delete();
        getCommentPosts(postId: postId);
        showToast(
            msg: "Comment deleted successfully", state: ToastStates.Success);
        emit(AppCommentDeleteSuccessState());
      }
    }).catchError((error) {
      emit(AppCommentDeleteFailureState());
    });
  }

  removeCommentImage() {
    commentImage = null;
    emit(AppRemoveCommentImageState());
  }

  List<CommentModel> comments = [];

  getCommentPosts({required String postId}) {
    FirebaseFirestore.instance
        .collection("posts")
        .doc(postId)
        .collection("comments")
        .orderBy("commentDate")
        .snapshots()
        .listen((event) {
      comments = [];
      for (var element in event.docs) {
        comments.add(CommentModel.fromJson(element.data()));
      }
      emit(AppGetCommentPostsSuccessState());
    });
  }

  List<UserModel> users = [];

  getAllUsers() {
    if (users.isEmpty) {
      FirebaseFirestore.instance.collection("users").get().then((value) {
        for (var element in value.docs) {
          if (element.data()["uId"] != userModel!.uId) {
            users.add(UserModel.fromJson(element.data()));
          }
        }
        emit(AppGetUsersSuccessState());
      }).catchError((error) {
        emit(AppGetUsersFailureState());
      });
    }
  }

  sendMessage({
    required String? receiverId,
    required String? messageText,
    required String? messageDate,
    String? messageImage,
  }) {
    MessageModel model = MessageModel(
      receiverId: receiverId,
      messageText: messageText,
      messageDate: messageDate,
      senderId: userModel!.uId,
      messageImage: messageImage ?? "Without message image....",
    );
    //my message
    FirebaseFirestore.instance
        .collection("users")
        .doc(userModel!.uId)
        .collection("chats")
        .doc(receiverId)
        .collection("messages")
        .add(model.toMap())
        .then((value) {
      emit(AppSendMessageSuccessState());
    }).catchError((error) {
      emit(AppSendMessageFailureState());
    });

    //receiver message
    FirebaseFirestore.instance
        .collection("users")
        .doc(receiverId)
        .collection("chats")
        .doc(userModel!.uId)
        .collection("messages")
        .add(model.toMap())
        .then((value) {
      emit(AppSendMessageSuccessState());
    }).catchError((error) {
      emit(AppSendMessageFailureState());
    });
  }

  deleteMessage({
    required String? receiverId,
  }) {
    //my message
    FirebaseFirestore.instance
        .collection("users")
        .doc(userModel!.uId)
        .collection("chats")
        .doc(receiverId)
        .collection("messages")
        .get()
        .then((value) {
      for (var element in value.docs) {
        element.reference.delete();
        getMessages(receiverId: receiverId);
        showToast(
            msg: "messages deleted successfully", state: ToastStates.Success);
      }
      emit(AppDeleteMessageSuccessState());
    }).catchError((error) {
      emit(AppDeleteMessageFailureState());
    });

    //receiver message
    // FirebaseFirestore.instance
    //     .collection("users")
    //     .doc(receiverId)
    //     .collection("chats")
    //     .doc(userModel!.uId)
    //     .collection("messages")
    //     .get()
    //     .then((value) {
    //   value.docs.forEach((element) {
    //     element.reference.delete();
    //     getMessages(receiverId: receiverId);
    //     showToast(
    //         msg: "comment deleted successfully", state: ToastStates.Success);
    //   });
    //   emit(AppSendMessageSuccessState());
    // }).catchError((error) {
    //   emit(AppSendMessageFailureState());
    // });
  }

  List<MessageModel> messages = [];
  List<String> messageId = [];

  getMessages({
    required String? receiverId,
  }) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(userModel!.uId)
        .collection("chats")
        .doc(receiverId)
        .collection("messages")
        .orderBy("messageDate", descending: false)
        .snapshots()
        .listen((event) {
      messages = [];
      for (var element in event.docs) {
        messages.add(MessageModel.fromJson(element.data()));
      }
      emit(AppGetMessagesSuccessState());
    });
  }

  File? messageImage;

  Future<void> getMessageImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      messageImage = File(pickedFile.path);
      emit(AppGetMessageImagePickedSuccessState());
    } else {
      print('No image selected.');
      emit(AppGetMessageImagePickedFailureState());
    }
  }

  uploadMessageImage({
    required String? receiverId,
    required String? messageText,
    required String? messageDate,
  }) {
    emit(AppSendMessageLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child("messages/${Uri.file(messageImage!.path).pathSegments.last}")
        .putFile(messageImage!)
        .then((value) {
      value.ref.getDownloadURL().then((imageUrl) {
        sendMessage(
          receiverId: receiverId,
          messageText: messageText,
          messageDate: messageDate,
          messageImage: imageUrl,
        );
        print(imageUrl);
      }).catchError((error) {
        emit(AppSendMessageFailureState());
      });
    }).catchError((error) {
      emit(AppSendMessageFailureState());
    });
  }

  removeMessageImage() {
    messageImage = null;
    emit(AppRemoveMessageImageState());
  }

  search() {
    emit(AppSearchLoadingState());
    FirebaseFirestore.instance.collection("users").get().then((value) {
      users = [];
      for (var element in value.docs) {
        if (element.data()["uId"] != userModel!.uId) {
          users.add(UserModel.fromJson(element.data()));
        }
      }
      emit(AppSearchSuccessState());
    }).catchError((error) {
      emit(AppSearchFailureState());
    });
  }

  sendFCMNotification({
    required String? token,
    required String? senderName,
    String? messageText,
    String? messageImage,
  }) {
    DioHelper.postData(key: SEND, data: {
      "to": "$token",
      "notification": {
        "title": "You have a new notification from: $senderName",
        "body": messageText ?? (messageImage != null ? 'Photo' : 'ERROR 404'),
        "sound": "default"
      },
      "android": {
        "Priority": "HIGH",
      },
      "data": {
        "type": "order",
        "id": "87",
        "click_action": "FLUTTER_NOTIFICATION_CLICK"
      }
    });
    emit(AppSendMessageSuccessState());
  }

// void sendInAppNotification({
//   String? contentKey,
//   String? contentId,
//   String? content,
//   String? receiverName,
//   String? receiverId,
// }){
//   emit(SendInAppNotificationLoadingState());
//   NotificationModel notificationModel = NotificationModel(
//     contentKey:contentKey,
//     contentId:contentId,
//     content:content,
//     senderName: model!.name,
//     receiverName:receiverName,
//     senderId:model!.uID,
//     receiverId:receiverId,
//     senderProfilePicture:model!.profilePic,
//     read: false,
//     dateTime: Timestamp.now(),
//     serverTimeStamp:FieldValue.serverTimestamp(),
//   );
//
//   FirebaseFirestore.instance
//       .collection('users')
//       .doc(receiverId)
//       .collection('notifications')
//       .add(notificationModel.toMap()).then((value) async{
//     await setNotificationId();
//     emit(SendInAppNotificationLoadingState());
//   }).catchError((error) {
//     emit(SendInAppNotificationLoadingState());
//   });
// }
}
