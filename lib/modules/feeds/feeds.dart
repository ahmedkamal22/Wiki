import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:fire/layout/cubit/cubit.dart';
import 'package:fire/layout/cubit/states.dart';
import 'package:fire/models/post/post.dart';
import 'package:fire/modules/comment/comment.dart';
import 'package:fire/shared/components/components.dart';
import 'package:fire/shared/styles/colors.dart';
import 'package:fire/shared/styles/icon_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedsScreen extends StatelessWidget {
  FeedsScreen({Key? key}) : super(key: key);
  var commentTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return ConditionalBuilder(
          condition: cubit.posts.isNotEmpty,
          builder: (context) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Card(
                    elevation: 5.0,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    margin: const EdgeInsetsDirectional.all(8),
                    child: Stack(
                      alignment: AlignmentDirectional.bottomEnd,
                      children: [
                        const Image(
                          image: NetworkImage(
                              "https://img.freepik.com/free-photo/excited-happy-young-pretty-woman_171337-2005.jpg?w=740&t=st=1662053221~exp=1662053821~hmac=eae04ec0ca79550c2980c3ae952c870ceeb9b976040865bceb19c68638af4a29"),
                          width: double.infinity,
                          height: 220,
                          fit: BoxFit.cover,
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.only(
                              bottom: 10, end: 10),
                          child: Text(
                            "Communicate with friends",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(color: Colors.white, fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) =>
                          buildPostsItem(context, cubit.posts[index], index),
                      separatorBuilder: (context, index) => const SizedBox(
                            height: 10,
                          ),
                      itemCount: cubit.posts.length),
                ],
              ),
            );
          },
          fallback: (context) => testScreen(
              text: "There isn't any posts yet...",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: AppCubit.get(context).isDark
                        ? Colors.white
                        : Colors.black,
                  )),
        );
      },
    );
  }

  Widget buildPostsItem(context, PostsModel model, index) => Card(
        elevation: 5.0,
        color: Theme.of(context).scaffoldBackgroundColor,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  InkWell(
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(
                          "${AppCubit.get(context).userModel!.image}"),
                    ),
                    onTap: () {
                      AppCubit.get(context).changeBottomNav(3);
                    },
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "${model.name}",
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color: AppCubit.get(context).isDark
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.check_circle,
                            color: defaultColor,
                            size: 22,
                          ),
                        ],
                      ),
                      Text(
                        "${model.postDate}",
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              height: 2.2,
                              color: AppCubit.get(context).isDark
                                  ? Colors.grey[300]
                                  : Colors.black,
                            ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      AppCubit.get(context).deletePost(
                          postId: AppCubit.get(context).postId[index]);
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Colors.grey[300],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                width: double.infinity,
                height: 1,
                color: Colors.grey[300],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "${model.postText}",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontSize: 17,
                      height: 1.1,
                      color: AppCubit.get(context).isDark
                          ? Colors.white
                          : Colors.black,
                    ),
              ),
            ),
            if (model.postImage != "Without post image..")
              Padding(
                padding:
                    const EdgeInsetsDirectional.only(top: 10, start: 2, end: 2),
                child: Container(
                  width: double.infinity,
                  height: 170,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                      image: NetworkImage("${model.postImage}"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        const Icon(
                          IconBroken.Heart,
                          color: Colors.red,
                          size: 20,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          "${AppCubit.get(context).postLikes[AppCubit.get(context).postId[index]]}",
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontSize: 17,
                                    height: 1.1,
                                    color: AppCubit.get(context).isDark
                                        ? Colors.grey[300]
                                        : Colors.black,
                                  ),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Icon(
                          IconBroken.Chat,
                          color: Colors.amber,
                          size: 20,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          "${AppCubit.get(context).commentNum[AppCubit.get(context).postId[index]]} comments",
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontSize: 17,
                                    height: 1.1,
                                    color: AppCubit.get(context).isDark
                                        ? Colors.grey[300]
                                        : Colors.black,
                                  ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsetsDirectional.only(top: 10),
              child: Container(
                width: double.infinity,
                height: 1,
                color: Colors.grey[300],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      navigateTo(
                          context: context,
                          widget: CommentScreen(
                              AppCubit.get(context).postId[index]));
                    },
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(
                              "${AppCubit.get(context).userModel!.image}"),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Text(
                          "Write a comment....",
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    fontSize: 14,
                                    color: AppCubit.get(context).isDark
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      AppCubit.get(context)
                          .likePost(AppCubit.get(context).postId[index]);
                    },
                    child: Row(
                      children: [
                        const Icon(
                          IconBroken.Heart,
                          size: 18,
                          color: Colors.red,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Like",
                            style:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      fontSize: 14,
                                      color: AppCubit.get(context).isDark
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
