import 'package:bloc/bloc.dart';

late var uId;

String deviceToken =
    "ftuvOOvvTHuVCF_VpiK-D7:APA91bHDJ6zWD4ZrOS7DvCemSsrhGlu6l9KqtmV2zblQ9tXokzkcQQRt2pLdNRBbDH2jFgph0ZKE2qVWczWiD3swVm-kBtHASnDVAJYabFtFVGC1BLf-I_rVv8VIDRyaMIBU79Twr_oe";
String SEND = "send";

class MyBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    print('onCreate -- ${bloc.runtimeType}');
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    print('onEvent -- ${bloc.runtimeType}, $event');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print('onChange -- ${bloc.runtimeType}, $change');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print('onTransition -- ${bloc.runtimeType}, $transition');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    print('onError -- ${bloc.runtimeType}, $error');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    print('onClose -- ${bloc.runtimeType}');
  }
}
