import 'package:bitcoin_ticker/coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  const PriceScreen({Key? key}) : super(key: key);
  @override
  State<PriceScreen> createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'AUD';
  //String bitCointValue = '?';

  @override
  void initState() {
    super.initState();
    updateUI();
  }

  Map<String, String> coin = {};
  bool isWaiting = false;

  Future<dynamic> updateUI() async {
    isWaiting = true;
    try {
      dynamic data = await CoinData().getCoinData(selectedCurrency);
      isWaiting = false;
      setState(() {
        coin = data;
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  DropdownButton<String> getDropDownButton() {
    List<DropdownMenuItem<String>> addedCurrency = [];
    for (String currency in currenciesList) {
      var chosenCurrency = DropdownMenuItem(
        value: currency,
        child: Text(currency),
      );
      addedCurrency.add(chosenCurrency);
    }
    return DropdownButton<String>(
      value: selectedCurrency,
      items: addedCurrency,
      onChanged: (value) {
        setState(
          () {
            selectedCurrency = value!;
            updateUI();
          },
        );
      },
    );
  }

  NotificationListener<Notification> iosPicker() {
    List<Text> pickerItems = [];

    for (String currency in currenciesList) {
      pickerItems.add(Text(currency));
    }
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (kDebugMode) {
          print('$notification');
        }
        return true;
      },
      child: CupertinoPicker(
        backgroundColor: Colors.lightBlue,
        itemExtent: 35,
        onSelectedItemChanged: (selecIndex) {
          if (kDebugMode) {
            print(selecIndex);
          }
          setState(() {
            selectedCurrency = currenciesList[selecIndex];
            updateUI();
          });
        },
        children: pickerItems,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: const Center(
          child: Text('🤑 Coin Ticker'),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CryptoCard(
                bitCointValue: 'BTC',
                selectedCurrency: selectedCurrency,
                value: isWaiting ? '?' : ' ${coin['BTC']}',
              ),
              CryptoCard(
                bitCointValue: 'ETH',
                selectedCurrency: selectedCurrency,
                value: isWaiting ? '?' : ' ${coin['ETH']}',
              ),
              CryptoCard(
                bitCointValue: 'LTC',
                selectedCurrency: selectedCurrency,
                value: isWaiting ? '?' : ' ${coin['LTC']}',
              ),
            ],
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iosPicker() : getDropDownButton(),
          ),
        ],
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {
  const CryptoCard({
    Key? key,
    required this.bitCointValue,
    required this.selectedCurrency,
    required this.value,
  }) : super(key: key);

  final String value;
  final String bitCointValue;
  final String selectedCurrency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $bitCointValue = $value $selectedCurrency',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
