import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;
import 'package:bitcoin_ticker/price_screen.dart';
import 'dart:convert';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurreny = 'USD';
  double currencyPrice = 5.0;
  DropdownButton<String> dropDownButton() {
    List<DropdownMenuItem<String>> dropDownItems = [];
    for (int i = 0; i < currenciesList.length; i++) {
      String curreny = currenciesList[i];
      var newItem = DropdownMenuItem(
        child: Text(curreny),
        value: curreny,
      );
      dropDownItems.add(newItem);
    }
    return DropdownButton<String>(
      value: selectedCurreny,
      items: dropDownItems,
      onChanged: (value) {
        this.setState(() {
          selectedCurreny = value;
        });
      },
    );
  }

  CupertinoPicker iosPicker() {
    List<Widget> cupertinoItems = [];
    for (int i = 0; i < currenciesList.length; i++) {
      String curreny = currenciesList[i];
      cupertinoItems.add(Text(curreny));
    }
    return CupertinoPicker(
        itemExtent: 32.0,
        onSelectedItemChanged: (selectedIndex) {
          setState(() {
            selectedCurreny = currenciesList[selectedIndex];
          });
        },
        children: cupertinoItems);
  }

  Future<CoinData> fetchCoin() async {
    final response = await http.get(Uri.parse(
        'https://rest.coinapi.io/v1/exchangerate/BTC/$selectedCurreny?apikey=6108B336-61C2-4EAD-A7E4-95D99E276B6A'));
    currencyPrice = CoinData.fromJson(jsonDecode(response.body)).exchangeValue;
    return CoinData.fromJson(jsonDecode(response.body));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                child: Text(
                  '1 BTC = $currencyPrice USD',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Container(
              height: 150.0,
              alignment: Alignment.center,
              padding: EdgeInsets.only(bottom: 30.0),
              color: Colors.lightBlue,
              child: Platform.isIOS ? iosPicker() : dropDownButton()),
        ],
      ),
    );
  }
}
