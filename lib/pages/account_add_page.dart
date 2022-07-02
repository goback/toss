import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:provider/provider.dart';
import 'package:toss/models/account_list_service.dart';

class AccountAddPage extends StatefulWidget {
  const AccountAddPage({Key? key}) : super(key: key);

  @override
  State<AccountAddPage> createState() => _AccountAddPageState();
}

class _AccountAddPageState extends State<AccountAddPage> {
  TextEditingController _bankTextController = TextEditingController();
  TextEditingController _balanceTextController = TextEditingController();
  String _bankErrorText = '';
  String _balanceErrorText = '';

  @override
  void dispose() {
    super.dispose();
    _bankTextController.dispose();
    _balanceTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f3f8),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          color: Colors.black,
          icon: Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _validation();
              _submit();
            },
            child: Text('확인'),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  '은행 추가하기',
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  horizontalTitleGap: 0,
                  leading: Text('은행명'),
                  title: TextField(
                    controller: _bankTextController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      errorText: _bankErrorText,
                    ),
                    textAlign: TextAlign.end,
                  ),
                  trailing: Text('은행'),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  horizontalTitleGap: 0,
                  leading: Text('잔액'),
                  title: TextField(
                    controller: _balanceTextController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      errorText: _balanceErrorText,
                    ),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.end,
                    inputFormatters: [
                      MoneyInputFormatter(
                        thousandSeparator: ThousandSeparator.Comma,
                        mantissaLength: 0,
                      )
                    ],
                  ),
                  trailing: Text('원'),
                ),
              ],
            ),
            Column(
              children: [
                Container(
                  width: double.infinity,
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
                          Image.asset(
                            'assets/images/toss_icon.png',
                            width: 60,
                          ),
                          Text(
                            '토스 은행',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '비대면으로 통장을 개설 할 수 있어요',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            child: Text('지금 바로 만들기'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _validation();
                      _submit();
                    },
                    child: Text('확인'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    if (_bankErrorText.isEmpty & _balanceErrorText.isEmpty) {
      final bank = _bankTextController.text;
      final balance = int.parse(_balanceTextController.text.replaceAll(',', ''));

      context.read<AccountListService>().addAccount(bank, balance);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('개설 완료'),
        backgroundColor: Colors.blue,
      ));
      Navigator.pop(context);
    }
    setState(() => {});
  }

  void _validation() {
    final bank = _bankTextController.text;
    final balance = _balanceTextController.text;

    _bankErrorText = bank.trim().isEmpty ? '은행명을 입력해주세요' : '';
    _balanceErrorText = balance.trim().isEmpty ? '잔액을 입력해주세요' : '';
  }
}
