import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  DateTime _date = new DateTime.now();

  Future<Null> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(DateTime.now().year),
        lastDate: new DateTime.now(),
        locale: const Locale('ja'));

    if (picked != null) {
      setState(() => _date = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        const CupertinoSliverNavigationBar(
          largeTitle: const Text('Home'),
        ),
        SliverList(
            delegate: SliverChildListDelegate([
          Container(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                CupertinoButton(
                  onPressed: () => _selectDate(context),
                  child: new Text(
                    DateFormat.yMd('ja_JP').format(_date),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ]))
        ]))
      ],
    );
  }
}
