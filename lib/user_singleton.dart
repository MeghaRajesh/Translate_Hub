class UserSingleton {
  static final UserSingleton _instance = UserSingleton._internal();
  factory UserSingleton() => _instance;
  
  UserSingleton._internal();

  String userEmail = '';
}