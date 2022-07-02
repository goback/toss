import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toss/models/account_list_service.dart';
import 'package:toss/pages/account_list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AccountListService>(
          create: (context) => AccountListService(),
        ),
      ],
      child: MaterialApp(
        title: 'Toss Bank',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SafeArea(
          child: AccountListPage(),
        ),
      ),
    );
  }
}
