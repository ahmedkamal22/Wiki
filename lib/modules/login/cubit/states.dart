abstract class LoginStates {}

class LoginInitialState extends LoginStates {}

class LoginLoadingState extends LoginStates {}

class LoginSuccessState extends LoginStates {
  String uId;

  LoginSuccessState(this.uId);
}

class LoginFailureState extends LoginStates {
  String error;

  LoginFailureState(this.error);
}

class LoginChangeIconState extends LoginStates {}
