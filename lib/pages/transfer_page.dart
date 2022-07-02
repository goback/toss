import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/money_input_enums.dart';
import 'package:flutter_multi_formatter/formatters/money_input_formatter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:toss/models/account.dart';
import 'package:toss/models/account_list_service.dart';
import 'package:toss/pages/account_list_page.dart';

class TransferPage extends StatefulWidget {
  final bank;
  final balance;

  const TransferPage({Key? key, required this.bank, required this.balance})
      : super(key: key);

  @override
  State<TransferPage> createState() => _TransferPageState();
}

class _TransferPageState extends State<TransferPage> {
  TextEditingController _balanceTextController = TextEditingController();
  Account? _selectedValue;

  @override
  void dispose() {
    super.dispose();
    _balanceTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accountList = context.watch<AccountListService>().state.accountList;
    _selectedValue = _selectedValue ?? accountList[0];

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
                  '송금하기',
                ),
                SizedBox(height: 10),
                Text(
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.blue,
                  ),
                  '어디로 보낼까요?',
                ),
                DropdownButton(
                  value: _selectedValue,
                  items: accountList.map(
                    (account) {
                      return DropdownMenuItem<Account>(
                        value: account,
                        child: Text(account.bank),
                      );
                    },
                  ).toList(),
                  onChanged: (dynamic value) {
                    setState(() {
                      _selectedValue = value;
                    });
                  },
                ),
                TextField(
                  controller: _balanceTextController,
                  decoration: InputDecoration(
                    counterText:
                        "현재 잔액 : ${NumberFormat('###,###').format(widget.balance)} 원",
                  ),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.end,
                  inputFormatters: [
                    MoneyInputFormatter(
                      thousandSeparator: ThousandSeparator.Comma,
                      mantissaLength: 0,
                    ),
                  ],
                ),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submit,
                    child: Text('보내기'),
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
    final balance = int.parse(_balanceTextController.text.replaceAll(',', ''));

    if (widget.balance < balance) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('잔액이 부족해요'),
      ));
      FocusManager.instance.primaryFocus?.unfocus();
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('${_selectedValue!.bank} 으로 ${balance} 원을 보내시겠어요?'),
          content: CircleAvatar(
            backgroundColor: Color(0xfff4faf8),
            radius: 50,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Image.asset('assets/images/money.png'),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                context.read<AccountListService>().toTransfer(widget.bank, _selectedValue!.bank, balance);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('전송 완료'),
                  backgroundColor: Colors.blue,
                ));
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AccountListPage()));
              },
              child: Text('보내기'),
            ),
          ],
        );
      },
    );
  }
}
