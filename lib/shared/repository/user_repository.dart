

import 'package:app/shared/entity/user.dart';
import 'package:app/shared/provider/mock_user_provider.dart';

class UserRepository{

  final MockUserProvider _userMockProvider = MockUserProvider();

  bool get isAuthorized => true;

  Future<User> get()async{
    return await _userMockProvider.fetchUser();
  }

  Future<User> authorize(String login, String password)async{
    return Future.delayed(Duration(seconds: 1), (){
      return _userMockProvider.fetchUser();
    });
  }

}