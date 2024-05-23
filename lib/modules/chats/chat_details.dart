import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:fire/layout/cubit/cubit.dart';
import 'package:fire/layout/cubit/states.dart';
import 'package:fire/models/message/message_model.dart';
import 'package:fire/models/user/user_model.dart';
import 'package:fire/shared/components/constants.dart';
import 'package:fire/shared/styles/icon_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatDetailsScreen extends StatelessWidget {
  UserModel? userModel;

  ChatDetailsScreen(this.userModel);

  var messageController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        AppCubit.get(context).getMessages(receiverId: userModel!.uId);
        return BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {},
          builder: (context, state) {
            var cubit = AppCubit.get(context);
            return Scaffold(
              appBar: AppBar(
                titleSpacing: 5,
                leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(IconBroken.Arrow___Left_2)),
                title: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage("${userModel!.image}"),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Text(
                      "${userModel!.name}",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: AppCubit.get(context).isDark
                                ? Colors.white
                                : Colors.black,
                          ),
                    ),
                  ],
                ),
              ),
              body: Container(
                margin: const EdgeInsetsDirectional.all(6),
                child: Form(
                  key: formKey,
                  child: Container(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          "https://pps.whatsapp.net/v/t61.24694-24/299172160_1465107993995907_829795782750603549_n.jpg?ccb=11-4&oh=01_AVzL1GgdKZFlGYASjD3YDtOfnVcSVoCA8W7DTHSvISTqFw&oe=635676F2",
                        ),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadiusDirectional.only(
                          topStart: Radius.circular(10),
                          bottomStart: Radius.circular(10),
                          bottomEnd: Radius.circular(10)),
                    ),
                    child: Column(
                      children: [
                        if (state is AppSendMessageLoadingState)
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
                            condition: cubit.messages.isNotEmpty,
                            builder: (context) => ListView.separated(
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  var message = cubit.messages[index];
                                  if (cubit.userModel!.uId == message.senderId)
                                    return messageSent(context, message);
                                  return messageReceived(context, message);
                                },
                                separatorBuilder: (context, index) =>
                                    const SizedBox(
                                      height: 15,
                                    ),
                                itemCount: cubit.messages.length),
                            fallback: (context) => Container(),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsetsDirectional.only(
                              bottom: 20, start: 10, end: 10),
                          decoration: BoxDecoration(
                              color: Colors.grey[100],
                              border: Border.all(
                                  width: 1, color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(20)),
                          padding: const EdgeInsetsDirectional.only(
                            start: 20,
                          ),
                          child: Column(
                            children: [
                              if (cubit.messageImage != null)
                                Stack(
                                  alignment: AlignmentDirectional.topEnd,
                                  children: [
                                    Container(
                                      height: 80,
                                      width: 250,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        image: DecorationImage(
                                            image:
                                                FileImage(cubit.messageImage!),
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsetsDirectional.only(
                                          top: 5, end: 5),
                                      child: CircleAvatar(
                                        radius: 16,
                                        backgroundColor: Colors.grey[300],
                                        child: IconButton(
                                          iconSize: 17,
                                          icon: const Icon(Icons.close),
                                          onPressed: () {
                                            AppCubit.get(context)
                                                .removeMessageImage();
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              Row(
                                children: [
                                  Expanded(
                                      child: TextFormField(
                                    controller: messageController,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Write your message here...",
                                    ),
                                    autocorrect: true,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "This field can't be null";
                                      }
                                      return null;
                                    },
                                  )),
                                  IconButton(
                                      highlightColor: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      onPressed: () {
                                        AppCubit.get(context).getMessageImage();
                                      },
                                      icon: const Icon(
                                        IconBroken.Camera,
                                        color: Colors.blue,
                                      )),
                                  IconButton(
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        if (cubit.messageImage == null) {
                                          cubit.sendMessage(
                                              receiverId: userModel!.uId,
                                              messageText:
                                                  messageController.text,
                                              messageDate:
                                                  DateTime.now().toString());
                                        } else {
                                          cubit.uploadMessageImage(
                                              receiverId: userModel!.uId,
                                              messageText:
                                                  messageController.text,
                                              messageDate:
                                                  DateTime.now().toString());
                                          AppCubit.get(context)
                                              .removeMessageImage();
                                        }
                                        messageController.clear();
                                        AppCubit.get(context)
                                            .sendFCMNotification(
                                          token: deviceToken,
                                          senderName: AppCubit.get(context)
                                              .userModel!
                                              .name,
                                          messageText:
                                              '${AppCubit.get(context).userModel!.name}' +
                                                  'Send a new message',
                                        );
                                      }
                                    },
                                    icon: const Icon(
                                      IconBroken.Send,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget messageReceived(context, MessageModel message) => Align(
        alignment: AlignmentDirectional.centerStart,
        child: Dismissible(
            key: UniqueKey(),
            onDismissed: (direction) {
              AppCubit.get(context).deleteMessage(receiverId: userModel!.uId);
            },
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadiusDirectional.only(
                      bottomEnd: Radius.circular(10),
                      topStart: Radius.circular(10),
                      topEnd: Radius.circular(10)),
                  color: Colors.grey[600],
                ),
                margin: const EdgeInsetsDirectional.only(start: 5, top: 3),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (message.messageImage != "Without message image....")
                      Column(
                        children: [
                          Container(
                            height: 150,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              image: DecorationImage(
                                image: NetworkImage(message.messageImage!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    Text(
                      "${message.messageText}",
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ))),
      );

  Widget messageSent(context, MessageModel message) => Align(
        alignment: AlignmentDirectional.centerEnd,
        child: Dismissible(
          key: UniqueKey(),
          onDismissed: (direction) {
            AppCubit.get(context).deleteMessage(receiverId: userModel!.uId);
          },
          child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadiusDirectional.only(
                    bottomStart: Radius.circular(10),
                    topEnd: Radius.circular(10),
                    topStart: Radius.circular(10)),
                color: Colors.green[500],
              ),
              margin: const EdgeInsetsDirectional.only(end: 5, top: 3),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (message.messageImage != "Without message image....")
                    Column(
                      children: [
                        Container(
                          height: 150,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            image: DecorationImage(
                              image: NetworkImage(message.messageImage!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  Text(
                    "${message.messageText}",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontSize: 16, color: Colors.white),
                  ),
                ],
              )),
        ),
      );
}
