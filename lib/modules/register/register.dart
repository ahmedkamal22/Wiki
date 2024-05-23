import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:fire/layout/cubit/cubit.dart';
import 'package:fire/layout/home.dart';
import 'package:fire/modules/register/cubit/cubit.dart';
import 'package:fire/modules/register/cubit/states.dart';
import 'package:fire/shared/components/components.dart';
import 'package:fire/shared/components/constants.dart';
import 'package:fire/shared/network/local/cache_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
        listener: (context, state) {
          if (state is RegisterCreateUserSuccessState) {
            CacheHelper.saveData(key: "uId", value: state.uId).then((value) {
              uId = state.uId;
              navigateAndFinish(context: context, widget: const HomeScreen());
            });
          }
          if (state is RegisterCreateUserFailureState) {
            showToast(msg: state.error, state: ToastStates.Error);
          }
        },
        builder: (context, state) {
          var cubit = RegisterCubit.get(context);
          Color cubitColor = AppCubit.get(context).isDark
              ? Colors.white.withOpacity(.9)
              : Colors.black.withOpacity(.6);
          return Scaffold(
            appBar: AppBar(),
            body: Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Register",
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontSize: 25,
                                    color: cubitColor,
                                  ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Register now to communicate with your friends",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        defaultFormField(
                          controller: nameController,
                          keyboardType: TextInputType.name,
                          label: "Name",
                          prefix: Icons.person,
                          validate: (value) {
                            if (value!.isEmpty) {
                              return "Name mustn't be empty";
                            }
                            return null;
                          },
                          generalWidgetsColor: cubitColor,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  color: cubitColor,
                                  fontWeight: FontWeight.normal),
                          radius: 20.0,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        defaultFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          label: "Email Address",
                          prefix: Icons.email,
                          validate: (value) {
                            if (value!.isEmpty) {
                              return "Email Address mustn't be empty";
                            }
                            return null;
                          },
                          generalWidgetsColor: cubitColor,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  color: cubitColor,
                                  fontWeight: FontWeight.normal),
                          radius: 20.0,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        defaultFormField(
                          controller: passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          label: "Password",
                          prefix: Icons.lock,
                          validate: (value) {
                            if (value!.isEmpty) {
                              return "Password mustn't be empty";
                            }
                            return null;
                          },
                          generalWidgetsColor: cubitColor,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  color: cubitColor,
                                  fontWeight: FontWeight.normal),
                          radius: 20.0,
                          isPassword: cubit.isPassword,
                          suffix: cubit.suffix,
                          suffixPressed: () {
                            cubit.changePasswordVisibility();
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        defaultFormField(
                            controller: phoneController,
                            keyboardType: TextInputType.phone,
                            label: "Phone",
                            prefix: Icons.phone,
                            validate: (value) {
                              if (value!.isEmpty) {
                                return "Phone mustn't be empty";
                              }
                              return null;
                            },
                            generalWidgetsColor: cubitColor,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    color: cubitColor,
                                    fontWeight: FontWeight.normal),
                            radius: 20.0,
                            onSubmitted: (value) {
                              if (formKey.currentState!.validate()) {
                                cubit.userRegister(
                                    name: nameController.text,
                                    email: emailController.text,
                                    password: passwordController.text,
                                    phone: phoneController.text);
                              }
                            }),
                        const SizedBox(
                          height: 25,
                        ),
                        ConditionalBuilder(
                          condition: state is! RegisterLoadingState,
                          builder: (context) => defaultButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                cubit.userRegister(
                                    name: nameController.text,
                                    email: emailController.text,
                                    password: passwordController.text,
                                    phone: phoneController.text);
                              }
                            },
                            text: "register",
                            radius: 20.0,
                            isUpper: true,
                          ),
                          fallback: (context) =>
                              const Center(child: CircularProgressIndicator()),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
