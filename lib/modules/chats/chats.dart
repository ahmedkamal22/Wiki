import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:fire/layout/cubit/cubit.dart';
import 'package:fire/layout/cubit/states.dart';
import 'package:fire/shared/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return ConditionalBuilder(
          condition: cubit.users.isNotEmpty,
          builder: (context) => ListView.separated(
              itemBuilder: (context, index) =>
                  buildChatItem(context, cubit.users[index]),
              separatorBuilder: (context, index) => lineDivider(),
              itemCount: cubit.users.length),
          fallback: (context) =>
              testScreen(text: "There isn't other users yet!!"),
        );
      },
    );
  }
}
