import 'dart:async';

import 'package:fit_kit/fit_kit.dart';
import 'package:flutter/material.dart';

class FitKitPage extends StatefulWidget {
  @override
  _FitKitAppState createState() => _FitKitAppState();
}

class _FitKitAppState extends State<FitKitPage> {
  String result = '';
  Map<DataType, List<FitData>> results = {};
  bool permissions;

  RangeValues _dateRange = const RangeValues(1, 8);
  final List<DateTime> _dates = <DateTime>[];
  double _limitRange = 0;

  DateTime get _dateFrom => _dates[_dateRange.start.round()];
  DateTime get _dateTo => _dates[_dateRange.end.round()];
  int get _limit => _limitRange == 0.0 ? null : _limitRange.round();

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    _dates.add(null);
    for (var i = 7; i >= 0; i--) {
      _dates.add(DateTime(
        now.year,
        now.month,
        now.day,
      ).subtract(Duration(days: i)));
    }
    _dates.add(null);

    hasPermissions();
  }

  Future<void> read() async {
    results.clear();

    try {
      permissions = await FitKit.requestPermissions(DataType.values.sublist(0,7));
      if (!permissions) {
        result = 'requestPermissions: failed';
      } else {
        for (var type in DataType.values.sublist(0,7)) {
          results[type] = await FitKit.read(
            type,
            dateFrom: _dateFrom,
            dateTo: _dateTo,
            limit: _limit,
          );
        }

        result = 'readAll: success';
      }
    } catch (e) {
      result = 'readAll: $e';
    }

    setState(() {});
  }

  Future<void> revokePermissions() async {
    results.clear();

    try {
      await FitKit.revokePermissions();
      permissions = await FitKit.hasPermissions(DataType.values.sublist(0,7));
      result = 'revokePermissions: success';
    } catch (e) {
      result = 'revokePermissions: $e';
    }

    setState(() {});
  }

  Future<void> hasPermissions() async {
    try {
      permissions = await FitKit.hasPermissions(DataType.values.sublist(0,7));
    } catch (e) {
      result = 'hasPermissions: $e';
    }

    if (!mounted) return;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final items =
        results.entries.expand((entry) => [entry.key, ...entry.value]).toList();

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('FitKit Example'),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(padding: EdgeInsets.symmetric(vertical: 8)),
              Text(
                  'Date Range: ${_dateToString(_dateFrom)} - ${_dateToString(_dateTo)}'),
              Text('Limit: $_limit'),
              Text('Permissions: $permissions'),
              Text('Result: $result'),
              _buildDateSlider(context),
              _buildLimitSlider(context),
              _buildButtons(context),
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    if (item is DataType) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          '$item - ${results[item].length}',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      );
                    } else if (item is FitData) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 8,
                        ),
                        child: Text(
                          '$item',
                          style: Theme.of(context).textTheme.caption,
                        ),
                      );
                    }

                    return Container();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _dateToString(DateTime dateTime) {
    if (dateTime == null) {
      return 'null';
    }

    return '${dateTime.day}.${dateTime.month}.${dateTime.year}';
  }

  Widget _buildDateSlider(BuildContext context) {
    return Row(
      children: [
        const Text('Date Range'),
        Expanded(
          child: RangeSlider(
            values: _dateRange,
            min: 0,
            max: 9,
            divisions: 10,
            onChanged: (values) => setState(() => _dateRange = values),
          ),
        ),
      ],
    );
  }

  Widget _buildLimitSlider(BuildContext context) {
    return Row(
      children: [
        const Text('Limit'),
        Expanded(
          child: Slider(
            value: _limitRange,
            min: 0,
            max: 4,
            divisions: 4,
            onChanged: (newValue) => setState(() => _limitRange = newValue),
          ),
        ),
      ],
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FlatButton(
            color: Theme.of(context).accentColor,
            textColor: Colors.white,
            onPressed: read,
            child: const Text('Read'),
          ),
        ),
        const Padding(padding: EdgeInsets.symmetric(horizontal: 4)),
        Expanded(
          child: FlatButton(
            color: Theme.of(context).accentColor,
            textColor: Colors.white,
            onPressed: revokePermissions,
            child: const Text('Revoke permissions'),
          ),
        ),
      ],
    );
  }
}
