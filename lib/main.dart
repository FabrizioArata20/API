import 'package:api_mvp/presenters/presenter_crud.dart';
import 'package:api_mvp/presenters/services/crud_service.dart';
import 'package:api_mvp/view/user_detail.dart';
import 'package:api_mvp/view/user_list.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserService userService = UserService();
    final UserPresenter userPresenter = UserPresenter(userService);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'User List MVP',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: UserListView(presenter: userPresenter),
    );
  }
}


