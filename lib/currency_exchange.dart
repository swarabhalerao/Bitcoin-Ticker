import 'package:bitcoin_ticker/networking.dart';

const apiKey = '906CB353-CDDE-492F-82D9-4765611BDFAC';
const coinapiURL = 'https://rest.coinapi.io/v1/exchangerate';

class CurrencyExchange {
  Future<dynamic> getExchangeRate({required String currency}) async {
    NetworkHelper networkHelper =
        NetworkHelper(url: '$coinapiURL/BTC/$currency?apikey=$apiKey');
    var currencyData = await networkHelper.getData();
    return currencyData;
  }
}
