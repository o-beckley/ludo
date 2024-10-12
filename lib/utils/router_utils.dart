import 'package:go_router/go_router.dart';

extension RouterUtil on GoRouter{
  void clearStackAndNavigate(String location, {Object? extra}){
    while(canPop()){
      pop();
    }
    pushReplacement(location, extra: extra);
  }
}