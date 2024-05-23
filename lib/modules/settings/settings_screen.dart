import 'package:fire/layout/cubit/cubit.dart';
import 'package:fire/layout/cubit/states.dart';
import 'package:fire/layout/home.dart';
import 'package:fire/shared/components/components.dart';
import 'package:fire/shared/styles/icon_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext context, AppStates state) {},
      builder: (BuildContext context, AppStates state) {
        var cubit = AppCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Settings Screen",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: AppCubit.get(context).isDark
                      ? Colors.white
                      : Colors.black,
                  fontSize: 16.0),
            ),
            leading: IconButton(
                onPressed: () {
                  navigateAndFinish(
                      context: context, widget: const HomeScreen());
                },
                icon: const Icon(Icons.arrow_back_ios)),
          ),
          body: WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: Column(
              children: [
                defaultSwitchListTile(
                  context: context,
                  value: cubit.isDark,
                  onChanged: (value) {
                    cubit.changeMode();
                  },
                  text: "Change Mode",
                  subtitle: "Swap between b&w themes .",
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.only(
                    start: 37,
                    end: 20,
                    top: 20,
                  ),
                  child: Row(
                    children: [
                      Text("log out",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  color: AppCubit.get(context).isDark
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20)),
                      const Spacer(),
                      IconButton(
                          onPressed: () {
                            signOut(context: context);
                          },
                          icon: Icon(IconBroken.Logout,
                              size: 30,
                              color: AppCubit.get(context).isDark
                                  ? Colors.white
                                  : Colors.black)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
