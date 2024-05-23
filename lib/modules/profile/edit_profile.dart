import 'package:fire/layout/cubit/cubit.dart';
import 'package:fire/layout/cubit/states.dart';
import 'package:fire/shared/components/components.dart';
import 'package:fire/shared/components/constants.dart';
import 'package:fire/shared/styles/icon_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfile extends StatelessWidget {
  EditProfile({Key? key}) : super(key: key);
  var nameController = TextEditingController();
  var bioController = TextEditingController();
  var phoneController = TextEditingController();
  var emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        var model = AppCubit.get(context).userModel;
        nameController.text = model!.name!;
        bioController.text = model.bio!;
        emailController.text = model.email!;
        phoneController.text = model.phone!;
        return Scaffold(
          appBar: defaultAppBar(
            context: context,
            title: "Edit Profile",
            actions: [
              defaultTextButton(
                onPressed: () {
                  cubit.updateData(
                    name: nameController.text,
                    bio: bioController.text,
                    phone: phoneController.text,
                    email: emailController.text,
                  );
                  AppCubit.get(context).sendFCMNotification(
                    token: deviceToken,
                    senderName: AppCubit.get(context).userModel!.name,
                    messageText: 'Your profile updated successfully',
                  );
                },
                text: "update data",
                isUpper: true,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                width: 15,
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (state is AppUpdateDataLoadingState)
                    Column(
                      children: [
                        LinearProgressIndicator(
                          color: Colors.black.withOpacity(.6),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  SizedBox(
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
                                height: 160,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: cubit.coverImage == null
                                          ? NetworkImage("${model.cover}")
                                          : FileImage(cubit.coverImage!)
                                              as ImageProvider,
                                      fit: BoxFit.cover),
                                  borderRadius:
                                      const BorderRadiusDirectional.only(
                                          topStart: Radius.circular(8.0),
                                          topEnd: Radius.circular(8.0)),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.only(
                                    top: 10, end: 5),
                                child: CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.blue,
                                  child: IconButton(
                                      onPressed: () {
                                        cubit.getCoverImage();
                                      },
                                      icon: const Icon(
                                        IconBroken.Camera,
                                        size: 20,
                                      )),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            CircleAvatar(
                              radius: 75,
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              child: CircleAvatar(
                                radius: 72,
                                backgroundImage: cubit.profileImage == null
                                    ? NetworkImage("${model.image}")
                                    : FileImage(cubit.profileImage!)
                                        as ImageProvider,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.only(
                                  bottom: 10, end: 10),
                              child: CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.blue,
                                child: IconButton(
                                    onPressed: () {
                                      cubit.getProfileImage();
                                    },
                                    icon: const Icon(
                                      IconBroken.Camera,
                                      size: 20,
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (cubit.profileImage != null || cubit.profileImage != null)
                    Row(
                      children: [
                        if (cubit.profileImage != null)
                          Expanded(
                            child: Column(
                              children: [
                                Stack(
                                  alignment: AlignmentDirectional.center,
                                  children: [
                                    defaultButton(
                                      onPressed: () {
                                        cubit.uploadProfileImage(
                                            name: nameController.text,
                                            bio: bioController.text,
                                            email: emailController.text,
                                            phone: phoneController.text);
                                      },
                                      text: "upload profile",
                                      radius: 20.0,
                                      isUpper: true,
                                    ),
                                    if (state is AppUpdateImageLoadingState)
                                      CircularProgressIndicator(
                                        color: Colors.grey[300],
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(
                          width: 5,
                        ),
                        if (cubit.coverImage != null)
                          Expanded(
                            child: Column(
                              children: [
                                Stack(
                                  alignment: AlignmentDirectional.center,
                                  children: [
                                    defaultButton(
                                      onPressed: () {
                                        cubit.uploadCoverImage(
                                            name: nameController.text,
                                            bio: bioController.text,
                                            email: emailController.text,
                                            phone: phoneController.text);
                                      },
                                      text: "upload cover",
                                      radius: 20.0,
                                      isUpper: true,
                                    ),
                                    if (state is AppUpdateCoverLoadingState)
                                      CircularProgressIndicator(
                                        color: Colors.grey[300],
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  const SizedBox(
                    height: 30,
                  ),
                  defaultFormField(
                      controller: nameController,
                      keyboardType: TextInputType.text,
                      label: "Name",
                      prefix: IconBroken.User,
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
                      radius: 20.0),
                  const SizedBox(
                    height: 20,
                  ),
                  defaultFormField(
                      controller: bioController,
                      keyboardType: TextInputType.text,
                      label: "Bio",
                      prefix: IconBroken.Info_Circle,
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
                      radius: 20.0),
                  const SizedBox(
                    height: 20,
                  ),
                  defaultFormField(
                      controller: emailController,
                      keyboardType: TextInputType.text,
                      label: "Email Address",
                      prefix: IconBroken.Profile,
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
                      radius: 20.0),
                  const SizedBox(
                    height: 20,
                  ),
                  defaultFormField(
                      controller: phoneController,
                      keyboardType: TextInputType.text,
                      label: "Phone",
                      prefix: IconBroken.Call,
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
                      radius: 20.0),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
