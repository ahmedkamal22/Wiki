import 'package:fire/layout/cubit/cubit.dart';
import 'package:fire/layout/cubit/states.dart';
import 'package:fire/layout/home.dart';
import 'package:fire/modules/login/login.dart';
import 'package:fire/shared/components/constants.dart';
import 'package:fire/shared/network/local/cache_helper.dart';
import 'package:fire/shared/network/remote/dio_helper.dart';
import 'package:fire/shared/styles/themes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  await Firebase.initializeApp();
  DioHelper.getInit();
  await CacheHelper.init();
  bool isDark = CacheHelper.getData(key: "isDark") ?? false;
  uId = CacheHelper.getData(key: "uId");
  Widget widget;
  if (uId != null) {
    widget = const HomeScreen();
  } else {
    widget = LoginScreen();
  }
  runApp(MyApp(
    isDark: isDark,
    startWidget: widget,
  ));
}

class MyApp extends StatelessWidget {
  final bool? isDark;
  final Widget? startWidget;

  const MyApp({
    super.key,
    this.isDark,
    this.startWidget,
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()
        ..changeMode(fromShared: isDark)
        ..getUserData()
        ..getPosts(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = AppCubit.get(context);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: cubit.isDark ? ThemeMode.dark : ThemeMode.light,
            home: startWidget,
          );
        },
      ),
    );
  }
}
