import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Constants/currency_data.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  double? currencyValue;
  int selectedItem = 0;
  String dropDownValue = Platform.isAndroid ? 'USD' : 'AUD';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  void getData() async {
    CoinData coinData = CoinData();

    var data = await coinData.getcoinData(dropDownValue);
    setState(() {
      if (data == null) {
        currencyValue = 0.0;
        Fluttertoast.showToast(
          msg: 'No data recived from the server',
        );
      } else {
        currencyValue = data['rate'];
      }
    });
  }

  DropdownButton getDropDownMenuButton() {
    List<DropdownMenuItem<String>> items = [];
    for (String currency in currenciesList) {
      items.add(DropdownMenuItem(
        value: currency,
        child: Text(currency),
      ));
    }
    return DropdownButton(
      menuMaxHeight: MediaQuery.of(context).size.height / 2,
      value: dropDownValue,
      items: items,
      onChanged: (value) async {
        setState(() {
          dropDownValue = value;
          getData();
        });
      },
    );
  }

  CupertinoPicker getIOSPicker() {
    List<Text> items = [];
    for (String currency in currenciesList) {
      items.add(Text(currency));
    }
    return CupertinoPicker(
      itemExtent: 32.0,
      onSelectedItemChanged: (int value) async {
        setState(() {
          selectedItem = value;
          dropDownValue = currenciesList[value];
          getData();
        });
      },
      children: items,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('🤑 Coin Ticker'),
      ),
      body: currencyValue == null
          ? Container(
              alignment: Alignment.topCenter,
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 2.5),
              child: const CircularProgressIndicator(
                color: Colors.white,
              ))
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
                  child: Card(
                    color: Colors.grey.shade800,
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 28.0),
                      child: Text(
                        Platform.isAndroid
                            ? '1 BTC = ${currencyValue?.toStringAsFixed(4)} $dropDownValue'
                            : '1 BTC = ${currencyValue?.toStringAsFixed(4)} $dropDownValue ',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 150.0,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade800,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                  ),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(bottom: 30.0),
                  child:
                      Platform.isIOS ? getIOSPicker() : getDropDownMenuButton(),
                ),
              ],
            ),
    );
  }
}
