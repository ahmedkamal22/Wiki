abstract class RegisterStates {}

class RegisterInitialState extends RegisterStates {}

class RegisterLoadingState extends RegisterStates {}

class RegisterSuccessState extends RegisterStates {}

class RegisterFailureState extends RegisterStates {
  String error;

  RegisterFailureState(this.error);
}

class RegisterCreateUserSuccessState extends RegisterStates {
  String uId;

  RegisterCreateUserSuccessState(this.uId);
}

class RegisterCreateUserFailureState extends RegisterStates {
  String error;

  RegisterCreateUserFailureState(this.error);
}

class RegisterChangeIconState extends RegisterStates {}
