// src/reserve.dart
import 'package:flutter/material.dart';

class ReservePage extends StatefulWidget {
  final String trainType;
  final DateTime date;
  final TimeOfDay time;
  final String departure;
  final String arrival;

  ReservePage({
    required this.trainType,
    required this.date,
    required this.time,
    required this.departure,
    required this.arrival,
  });

  @override
  _ReservePageState createState() => _ReservePageState();
}

class _ReservePageState extends State<ReservePage> {
  int _counter = 0;
  String? _selectedTrain;

  final List<String> _trainList = ['기차1', '기차2', '기차3'];

  void _reserve() {
    if (_selectedTrain == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('기차를 선택해주세요.')),
      );
      return;
    }
    setState(() {
      _counter++;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('예약이 완료되었습니다. 예약 횟수: $_counter')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('검색 결과')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('선택된 기차: ${widget.trainType}'),
            Text('날짜: ${widget.date.toLocal()}'),
            Text('시간: ${widget.time.format(context)}'),
            Text('출발역: ${widget.departure}'),
            Text('도착역: ${widget.arrival}'),
            SizedBox(height: 20),
            Text('기차 목록:'),
            ..._trainList.map((train) {
              return RadioListTile<String>(
                title: Text(train),
                value: train,
                groupValue: _selectedTrain,
                onChanged: (String? value) {
                  setState(() {
                    _selectedTrain = value;
                  });
                },
              );
            }).toList(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _reserve,
              child: Text('예약'),
            ),
          ],
        ),
      ),
    );
  }
}
