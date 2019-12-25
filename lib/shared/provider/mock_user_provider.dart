import 'package:app/shared/entity/user.dart';

class MockUserProvider{

  Future<User> fetchUser() {
   return Future<User>.delayed(Duration(milliseconds: 1500), (){
      return User(
        avatarUrl: "http://www.millattashlar.ru/images/thumb/5/57/%D0%A5%D0%B0%D0%B4%D0%B8%D0%B5%D0%B2_%D0%A0%D0%B0%D0%B2%D0%B8%D0%BB%D1%8C_%D0%9C%D0%B0%D0%B3%D1%81%D1%83%D0%BC%D0%BE%D0%B2%D0%B8%D1%87.jpg/300px-%D0%A5%D0%B0%D0%B4%D0%B8%D0%B5%D0%B2_%D0%A0%D0%B0%D0%B2%D0%B8%D0%BB%D1%8C_%D0%9C%D0%B0%D0%B3%D1%81%D1%83%D0%BC%D0%BE%D0%B2%D0%B8%D1%87.jpg",
        name: "Равиль",
        surname: "Хадиев",
        token: ";;lk123;lk123a"
      );
    });
  }

}