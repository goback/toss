import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:toss/models/account.dart';
import 'package:toss/models/account_list_service.dart';
import 'package:toss/pages/account_add_page.dart';
import 'package:toss/pages/transfer_page.dart';

class AccountListPage extends StatefulWidget {
  const AccountListPage({Key? key}) : super(key: key);

  @override
  State<AccountListPage> createState() => _AccountListPageState();
}

class _AccountListPageState extends State<AccountListPage> {
  @override
  Widget build(BuildContext context) {
    final List<Account> accountList =
        context.watch<AccountListService>().state.accountList;

    return Scaffold(
      backgroundColor: const Color(0xfff4f3f8),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/images/toss_logo.png',
                  color: Colors.grey[400],
                  height: 20,
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.qr_code_2),
                  color: Colors.grey[400],
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.message),
                  color: Colors.grey[400],
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.add_alert),
                  color: Colors.grey[400],
                  onPressed: () {},
                ),
              ],
            ),
            Expanded(
              child: Card(
                color: Colors.white,
                // 모서리 둥글게
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                // 그림자 없음
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            '자산',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Spacer(),
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AccountAddPage()));
                            },
                            icon: Icon(Icons.add),
                          ),
                        ],
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: accountList.length,
                          itemBuilder: (context, index) {
                            final account = accountList[index];
                            return accountInfoTile(
                                account.bank, account.balance, account.image);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget accountInfoTile(String bank, int balance, String image) {
    return ListTile(
      leading: Image.asset(
        image,
      ),
      title: Text(
        bank,
        style: TextStyle(
          color: Colors.grey[700],
          fontSize: 12,
        ),
      ),
      subtitle: Text(
        '${NumberFormat('###,###').format(balance)} 원',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ),
      trailing: ElevatedButton(
        style: ElevatedButton.styleFrom(primary: Colors.grey[300]),
        child: Text(
          '송금',
          style: TextStyle(color: Colors.black),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TransferPage(bank: bank, balance: balance),
            ),
          );
        },
      ),
    );
  }
}
