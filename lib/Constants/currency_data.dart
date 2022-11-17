import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

const apikey = '63C257E9-B58A-46B5-B749-7B233EA988B9';
const key = 'https://rest.coinapi.io/v1/exchangerate/BTC/';
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

class CoinData {
  Future<dynamic> getcoinData(String currency) async {
    var url = Uri.parse('$key$currency?apikey=$apikey');
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      try {
        var jasonResponse = jsonDecode(response.body);
        return jasonResponse;
      } catch (e) {
        Fluttertoast.showToast(msg: e.toString());
      }
    } else {
      Fluttertoast.showToast(msg: response.statusCode.toString());
    }
  }
}
