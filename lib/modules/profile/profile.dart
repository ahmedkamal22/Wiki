import 'package:fire/layout/cubit/cubit.dart';
import 'package:fire/layout/cubit/states.dart';
import 'package:fire/modules/profile/edit_profile.dart';
import 'package:fire/shared/components/components.dart';
import 'package:fire/shared/styles/icon_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var model = AppCubit.get(context).userModel;
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 220,
                child: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: [
                    Align(
                      alignment: AlignmentDirectional.topCenter,
                      child: Container(
                        width: double.infinity,
                        height: 160,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage("${model!.cover}"),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: const BorderRadiusDirectional.only(
                              topStart: Radius.circular(8),
                              topEnd: Radius.circular(8),
                            )),
                      ),
                    ),
                    CircleAvatar(
                      radius: 75,
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      child: CircleAvatar(
                        radius: 72,
                        backgroundImage: NetworkImage("${model.image}"),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.only(
                  top: 15,
                ),
                child: Text(
                  "${model.name}",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: AppCubit.get(context).isDark
                            ? Colors.white
                            : Colors.black,
                      ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.only(top: 10, bottom: 30),
                child: Text(
                  "${model.bio}",
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: AppCubit.get(context).isDark
                            ? Colors.grey[300]
                            : Colors.black.withOpacity(.8),
                      ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          "2",
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    color: AppCubit.get(context).isDark
                                        ? Colors.grey[300]
                                        : Colors.black,
                                  ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text("Posts",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    color: AppCubit.get(context).isDark
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 16)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          "40",
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    color: AppCubit.get(context).isDark
                                        ? Colors.grey[300]
                                        : Colors.black,
                                  ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text("Fiends",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    color: AppCubit.get(context).isDark
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 16)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          "10",
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    color: AppCubit.get(context).isDark
                                        ? Colors.grey[300]
                                        : Colors.black,
                                  ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text("Likes",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    color: AppCubit.get(context).isDark
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 16)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          "5",
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    color: AppCubit.get(context).isDark
                                        ? Colors.grey[300]
                                        : Colors.black,
                                  ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text("Followers",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    color: AppCubit.get(context).isDark
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 16)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                        onPressed: () {
                          navigateTo(context: context, widget: EditProfile());
                        },
                        child: const Text("Edit Profile")),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  OutlinedButton(
                    onPressed: () {
                      navigateTo(context: context, widget: EditProfile());
                    },
                    child: const Icon(
                      IconBroken.Edit,
                      size: 16,
                      color: Colors.blue,
                    ),
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
