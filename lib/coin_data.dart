import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

const apikey = '5637D3CC-2173-4574-864E-8098FCBD8802';
const coinApiUrl = 'https://rest.coinapi.io/v1/exchangerate';

class CoinData {
  Future getCoinData(String selectedCurrency) async {
    Map<String, String> cryptoPrices = {};
    for (String crypto in cryptoList) {
      var url = '$coinApiUrl/$crypto/$selectedCurrency?apikey=$apikey';
      http.Response response = await http.get(
        Uri.parse(url),
      );
      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body);
        double lastPrice = decodedData['rate'];
        cryptoPrices[crypto] = lastPrice.toStringAsFixed(0);
        // var currency = decodedData['rates']['asset_id_quote'];
        // print(decodedData);
      } else {
        if (kDebugMode) {
          print('Error ${response.statusCode}');
        }

        throw 'Problem with the get request';
      }
    }
    return cryptoPrices;
  }
}
