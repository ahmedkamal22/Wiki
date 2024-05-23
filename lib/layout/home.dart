import 'package:fire/layout/cubit/cubit.dart';
import 'package:fire/layout/cubit/states.dart';
import 'package:fire/modules/posts/posts.dart';
import 'package:fire/modules/settings/settings_screen.dart';
import 'package:fire/shared/components/components.dart';
import 'package:fire/shared/styles/icon_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(listener: (context, state) {
      if (state is AppNewPostState) {
        navigateTo(context: context, widget: PostsScreen());
      }
    }, builder: (context, state) {
      var cubit = AppCubit.get(context);
      return Scaffold(
        appBar: AppBar(
          title: Text(
            cubit.titels[cubit.currentIndex],
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: AppCubit.get(context).isDark
                      ? Colors.white
                      : Colors.black,
                ),
          ),
        ),
        body: cubit.screens[cubit.currentIndex],
        drawer: customDrawer(
            context: context,
            settingsNavigation: () {
              navigateTo(context: context, widget: SettingsScreen());
            }),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: cubit.currentIndex,
          onTap: (index) {
            cubit.changeBottomNav(index);
          },
          items: cubit.items,
        ),
      );
    });
  }
}
