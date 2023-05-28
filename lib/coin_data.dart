import 'package:http/http.dart' as http;
import 'dart:convert';

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
  Future getExchangeData() async {
    http.Response response = await http.get(Uri.parse(
        'https://rest.coinapi.io/v1/exchangerate/BTC/USD?apikey=906CB353-CDDE-492F-82D9-4765611BDFAC#'));
    if (response.statusCode == 200) {
      String data = response.body;
      return jsonDecode(data);
    } else {
      print(response.statusCode);
    }
  }

  Future<String> getCurrencyData() async {
    String exchangeRate = '?';
    var currencyInfo = await getExchangeData();
    if (currencyInfo == null) {
      exchangeRate = 'null';
    } else {
      double rate = currencyInfo['rate'];
      exchangeRate = rate.toStringAsFixed(2);
    }
    print(exchangeRate);
    return exchangeRate;
  }
}
