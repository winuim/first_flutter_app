import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fit_kit/fit_kit.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final DateTime now = new DateTime.now();
  DateTime _date;
  bool _permissions;
  int _stepCount;

  @override
  void initState() {
    super.initState();

    _date = new DateTime(now.year, now.month, now.day);
    _permissions = false;
    hasPermissions();
    _stepCount = 0;
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(2020),
        lastDate: now,
        locale: const Locale('ja'));

    if (picked != null) {
      print('_selectDate: $picked');
      setState(() => _date = picked);
    }
  }

  Future<void> hasPermissions() async {
    try {
      _permissions = await FitKit.hasPermissions([DataType.STEP_COUNT]);
      print('hasPermissions: success');
    } on Exception catch (e) {
      print('hasPermissions: $e');
    }
    setState(() {});
  }

  Future<void> requestPermissions() async {
    try {
      _permissions = await FitKit.requestPermissions([DataType.STEP_COUNT]);
      print('requestPermissions: success');
    } on Exception catch (e) {
      print('requestPermissions: $e');
    }
    setState(() {});
  }

  Future<void> revokePermissions() async {
    try {
      await FitKit.revokePermissions();
      _permissions = await FitKit.hasPermissions([DataType.STEP_COUNT]);
      print('revokePermissions: success');
    } on Exception catch (e) {
      print('revokePermissions: $e');
    }

    setState(() {});
  }

  Future<void> read() async {
    _stepCount = 0;
    try {
      _permissions = await FitKit.hasPermissions([DataType.STEP_COUNT]);
      final results = await FitKit.read(
        DataType.STEP_COUNT,
        dateFrom: _date,
        dateTo: _date.add(const Duration(days: 1)),
      );
      print('read $_date: ${results.length}');
      for (var data in results) {
        print(
            '[${data.source}] ${data.dateFrom} - ${data.dateTo} : ${data.value}');
        _stepCount += data.value.toInt();
      }
    } on Exception catch (e) {
      print('read: $e');
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        CupertinoSliverNavigationBar(
          largeTitle: const Text('Home'),
          trailing: CupertinoSwitch(
            value: _permissions,
            onChanged: (bool value) {
              if (value) {
                requestPermissions();
              } else {
                revokePermissions();
              }
            },
          ),
        ),
        SliverList(
            delegate: SliverChildListDelegate([
          Container(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                CupertinoButton(
                  onPressed: () => _selectDate(context).then((value) => read()),
                  child: new Text(
                    DateFormat.yMd('ja_JP').format(_date),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: read,
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(width: 3, color: Colors.blue),
                    ),
                    child: Center(
                        child: Text(
                      '${_stepCount.toString()} step' +
                          (_stepCount > 1 ? 's' : ''),
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.blue),
                    )),
                  ),
                ),
              ]))
        ]))
      ],
    );
  }
}
