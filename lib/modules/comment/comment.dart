import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:fire/layout/cubit/cubit.dart';
import 'package:fire/layout/cubit/states.dart';
import 'package:fire/models/comment/comment.dart';
import 'package:fire/shared/components/components.dart';
import 'package:fire/shared/components/constants.dart';
import 'package:fire/shared/styles/icon_broken.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommentScreen extends StatelessWidget {
  String? commentId;

  CommentScreen(this.commentId);

  var commentController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      AppCubit.get(context).getCommentPosts(postId: commentId!);
      return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = AppCubit.get(context);
          return Scaffold(
            appBar: defaultAppBar(context: context, title: "Comments"),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    if (state is AppCommentPostLoadingState)
                      Column(
                        children: [
                          LinearProgressIndicator(
                            backgroundColor:
                                Theme.of(context).scaffoldBackgroundColor,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    Expanded(
                      child: ConditionalBuilder(
                        condition: cubit.comments.isNotEmpty,
                        builder: (context) => ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) => buildCommentItem(
                                context, cubit.comments[index], index),
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                                  height: 15,
                                ),
                            itemCount: cubit.comments.length),
                        fallback: (context) => testScreen(
                            text: "There isn't any comment yet...",
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color: AppCubit.get(context).isDark
                                          ? Colors.white
                                          : Colors.black,
                                    )),
                      ),
                    ),
                    writeComment(context),
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }

  Widget buildCommentItem(context, CommentModel model, index) => Dismissible(
        key: UniqueKey(),
        onDismissed: (d) {
          AppCubit.get(context).deleteComment(
            postId: AppCubit.get(context).postId[index],
          );
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage("${model.image}"),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: AppCubit.get(context).isDark
                        ? Colors.grey[200]
                        : Colors.grey[300],
                    borderRadius: BorderRadius.circular(15)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${model.name}",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "${model.commentText}",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontSize: 18,
                            height: 1.0,
                          ),
                    ),
                    if (model.commentImage != "Without comment image...")
                      Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              image: DecorationImage(
                                image: NetworkImage(model.commentImage!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  Widget writeComment(context) => Column(
        children: [
          if (AppCubit.get(context).commentImage != null)
            Stack(
              alignment: AlignmentDirectional.topEnd,
              children: [
                Container(
                  height: 80,
                  width: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    image: DecorationImage(
                        image: FileImage(AppCubit.get(context).commentImage!),
                        fit: BoxFit.cover),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.only(top: 5, end: 5),
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.grey[300],
                    child: IconButton(
                      iconSize: 17,
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        AppCubit.get(context).removeCommentImage();
                      },
                    ),
                  ),
                ),
              ],
            ),
          if (AppCubit.get(context).commentImage != null)
            const SizedBox(
              height: 10,
            ),
          Row(
            children: [
              Expanded(
                child: defaultFormField(
                  controller: commentController,
                  keyboardType: TextInputType.text,
                  hint: "Write a comment...",
                  prefix: IconBroken.Document,
                  validate: (value) {
                    if (value!.isEmpty) {
                      return "This field can't be null";
                    }
                    return null;
                  },
                  generalWidgetsColor: AppCubit.get(context).isDark
                      ? Colors.white
                      : Colors.black,
                  style: TextStyle(
                    color: AppCubit.get(context).isDark
                        ? Colors.white
                        : Colors.black,
                  ),
                  radius: 20,
                ),
              ),
              IconButton(
                  highlightColor: Theme.of(context).scaffoldBackgroundColor,
                  onPressed: () {
                    AppCubit.get(context).getCommentImage();
                  },
                  icon: const Icon(
                    IconBroken.Camera,
                    color: Colors.blue,
                  )),
              IconButton(
                  highlightColor: Theme.of(context).scaffoldBackgroundColor,
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      if (AppCubit.get(context).commentImage == null) {
                        AppCubit.get(context).commentPost(
                            commentId: commentId!,
                            commentText: commentController.text,
                            commentDate: DateTime.now().toString());
                      } else {
                        AppCubit.get(context)
                            .uploadCommentImage(
                                commentId: commentId!,
                                commentText: commentController.text,
                                commentDate: DateTime.now().toString())!
                            .then((value) {
                          AppCubit.get(context).removeCommentImage();
                        });
                      }
                      commentController.clear();
                      AppCubit.get(context).sendFCMNotification(
                        token: deviceToken,
                        senderName: AppCubit.get(context).userModel!.name,
                        messageText:
                            '${AppCubit.get(context).userModel!.name}' +
                                'commented on a post you have been shared',
                      );
                      Navigator.pop(context);
                    }
                  },
                  icon: const Icon(
                    IconBroken.Send,
                    color: Colors.blue,
                  )),
            ],
          ),
        ],
      );
}
