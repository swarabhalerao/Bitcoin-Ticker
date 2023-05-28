import 'dart:async';
import 'dart:convert';
import 'package:bitcoin_ticker/currency_exchange.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;

class PriceScreen extends StatefulWidget {
  const PriceScreen({Key? key}) : super(key: key);
  @override
  State<PriceScreen> createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  CurrencyExchange currencyExchange = CurrencyExchange();
  String selectedCurrency = 'USD';
  String rateBTC = '?';
  String rateETH = '?';
  String rateLTC = '?';

  DropdownButton<String> androidDropdownButton() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(value: currency, child: Text(currency));
      dropdownItems.add(newItem);
    }
    return DropdownButton<String>(
      dropdownColor: const Color(0xFFAEE2FF),
      style: const TextStyle(
          color: Color(0XFF2E7D32), fontWeight: FontWeight.w500),
      underline: Container(
        height: 2,
        color: Colors.grey, //<-- SEE HERE
      ),
      value: selectedCurrency,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value!;
          getAllRates();
        });
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerItems = [];
    for (String item in currenciesList) {
      pickerItems.add(Text(item));
    }
    return CupertinoPicker(
      useMagnifier: true,
      magnification: 1.25,
      backgroundColor: Colors.lightBlue,
      itemExtent: 29.5,
      onSelectedItemChanged: (selectedItem) {
        setState(() {
          selectedCurrency = currenciesList[selectedItem];
          getAllRates();
        });
      },
      children: pickerItems,
    );
  }

  Widget getPicker() {
    if (Platform.isIOS || Platform.isMacOS) {
      return iOSPicker();
    } else {
      return androidDropdownButton();
    }
  }

  @override
  void initState() {
    super.initState();
    // getRate();
    // getAnyRate(selectedCurrency);
    // getData();
    getAllRates();
  }

  Future<String> getRateFor(String fromCurrency, String toCurrency) async {
    http.Response response = await http.get(Uri.parse(
        'https://rest.coinapi.io/v1/exchangerate/$fromCurrency/$toCurrency?apikey=906CB353-CDDE-492F-82D9-4765611BDFAC#'));
    if (response.statusCode == 200) {
      String data = response.body;
      return jsonDecode(data)['rate'].toStringAsFixed(2);
    } else {
      print(response.statusCode);
      return 'null';
    }
  }

  Future<void> getFinalRateForBTC(String selectedCurrency) async {
    String rateInfo = await getRateFor('BTC', selectedCurrency);
    if (rateInfo == 'null') {
      rateBTC = 'null';
    } else {
      rateBTC = rateInfo;
    }
    setState(() {
      rateBTC;
    });
  }

  Future<void> getFinalRateForETH(String selectedCurrency) async {
    String rateInfo = await getRateFor('ETH', selectedCurrency);
    if (rateInfo == 'null') {
      rateETH = 'null';
    } else {
      rateETH = rateInfo;
    }
    setState(() {
      rateETH;
    });
  }

  Future<void> getFinalRateForLTC(String selectedCurrency) async {
    String rateInfo = await getRateFor('LTC', selectedCurrency);
    if (rateInfo == 'null') {
      rateLTC = 'null';
    } else {
      rateLTC = rateInfo;
    }
    setState(() {
      rateLTC;
    });
  }

  Future<void> getAllRates() async {
    getFinalRateForBTC(selectedCurrency);
    getFinalRateForETH(selectedCurrency);
    getFinalRateForLTC(selectedCurrency);
  }

  //early code
  // Future<void> getData() async {
  //   var currencyInfo =
  //       await currencyExchange.getExchangeRate(currency: selectedCurrency);
  //   print(currencyInfo);
  //   print(selectedCurrency);
  //   if (currencyInfo['rate'] != null) {
  //     double rawRate = currencyInfo['rate'];
  //     // print(rawRate);
  //     rate = rawRate.toStringAsFixed(2);
  //     // print(currencyInfo['rate']);
  //   }
  //   setState(() {
  //     rate;
  //   });
  // }

  // void getAnyRate(String selectedCurrency) async {
  //   var currencyInfo = getData();
  //   data = await currencyInfo.toStringAsFixed(2);
  //   setState(() {
  //     // var doubleRate = currencyInfo['rate'];
  //   });
  //   print(rate);
  // }

  void getRate() async {
    CoinData myCoin = CoinData();
    rateBTC = await myCoin.getCurrencyData();
    setState(() {
      rateBTC;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Coin Ticker 🤑')),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
                child: Card(
                  color: Colors.lightBlueAccent,
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 28.0),
                    child: Text(
                      '1 BTC = $rateBTC $selectedCurrency',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
                child: Card(
                  color: Colors.lightBlueAccent,
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 28.0),
                    child: Text(
                      '1 ETH = $rateETH $selectedCurrency',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
                child: Card(
                  color: Colors.lightBlueAccent,
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 28.0),
                    child: Text(
                      '1 LTC = $rateLTC $selectedCurrency',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS || Platform.isMacOS
                ? iOSPicker()
                : androidDropdownButton(),
          ),
        ],
      ),
    );
  }
}
