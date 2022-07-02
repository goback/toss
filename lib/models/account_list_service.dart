import 'package:flutter/material.dart';
import 'package:toss/models/account.dart';

class AccountListState {
  List<Account> accountList;

  AccountListState({
    required this.accountList,
  });

  AccountListState copyWith({
    List<Account>? accountList,
  }) {
    return AccountListState(
      accountList: accountList ?? this.accountList,
    );
  }
}

class AccountListService extends ChangeNotifier {
  AccountListState state = AccountListState(accountList: [
    Account(
      bank: '카카오뱅크',
      balance: 4281,
      image: 'assets/images/kakaobank_icon.png',
    ),
    Account(
      bank: '신한은행',
      balance: 14676,
      image: 'assets/images/shinhan_icon.png',
    ),
  ]);

  void addAccount(String bank, int balance, {String image: 'assets/images/toss_icon.png'}) {
    final newAccount = Account(bank: bank, balance: balance, image: image);
    final newAccountList = [...state.accountList, newAccount];
    state = state.copyWith(accountList: newAccountList);
    notifyListeners();
  }

  void toTransfer(String from, String to, int amount) {
    Account fromAccount = state.accountList.firstWhere((account) => account.bank == from);
    Account toAccount = state.accountList.firstWhere((account) => account.bank == to);
    fromAccount.balance -= amount;
    toAccount.balance += amount;
    notifyListeners();
  }
}
