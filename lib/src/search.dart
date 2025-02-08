// src/search.dart
import 'package:flutter/material.dart';
import 'reserve.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String? _selectedTrainType = 'SRT';
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final TextEditingController _departureController = TextEditingController();
  final TextEditingController _arrivalController = TextEditingController();

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime)
      setState(() {
        _selectedTime = picked;
      });
  }

  void _search() {
    if (_selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('모든 필드를 입력해주세요.')),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReservePage(
          trainType: _selectedTrainType!,
          date: _selectedDate!,
          time: _selectedTime!,
          departure: _departureController.text,
          arrival: _arrivalController.text,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('기차 검색')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<String>(
              value: _selectedTrainType,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedTrainType = newValue;
                });
              },
              items: <String>['SRT', 'KTX']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            TextField(
              controller: _departureController,
              decoration: InputDecoration(labelText: '출발역'),
            ),
            TextField(
              controller: _arrivalController,
              decoration: InputDecoration(labelText: '도착역'),
            ),
            Row(
              children: [
                Text(_selectedDate == null
                    ? '날짜 선택'
                    : '${_selectedDate!.toLocal()}'.split(' ')[0]),
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: _selectDate,
                ),
                Text(_selectedTime == null
                    ? '시간 선택'
                    : _selectedTime!.format(context)),
                IconButton(
                  icon: Icon(Icons.access_time),
                  onPressed: _selectTime,
                ),
              ],
            ),
            ElevatedButton(
              onPressed: _search,
              child: Text('검색'),
            ),
          ],
        ),
      ),
    );
  }
}
