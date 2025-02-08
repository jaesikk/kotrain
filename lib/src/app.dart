// src/app.dart
import 'package:flutter/material.dart';
import 'search.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:encrypt/encrypt.dart' as encrypt;


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '기차 예약 앱',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

  Future<Map<String, String>> __encPw(String password) async {
    final url = Uri.parse('https://smart.letskorail.com:443/classes/com.korail.mobile.common.code.do');
    final response = await http.post(url, body: {'code': 'app.login.cphd'});
    print('@@ > encPw_url : ${url}');
    final Map<String, dynamic> jsonResponse = json.decode(response.body);

    if (jsonResponse['strResult'] == 'SUCC' && jsonResponse['app.login.cphd'] != null) {
      final String idx = jsonResponse['app.login.cphd']['idx'];
      final String key = jsonResponse['app.login.cphd']['key'];

      final encryptKey = utf8.encode(key);
      final iv = utf8.encode(key.substring(0, 16));

      final encrypter = encrypt.Encrypter(encrypt.AES(
        encrypt.Key.fromLength(32), // AES key length is 32
        mode: encrypt.AESMode.cbc,
        padding: null,
      ));

      final encrypted = encrypter.encrypt(password, iv: encrypt.IV.fromLength(16));

      // Fix: Use base64Encode directly on encrypted.bytes (List<int>)
      final base64Encrypted = base64.encode(encrypted.bytes);
      print('@@ > encPw_base64 : ${base64Encrypted}');
      return {
        'idx': idx,
        'encPw': base64Encrypted,
      };
    } else {
      return {
        'idx': '',
        'encPw': '',
      };
    }
  }

  void _login() async {
    String korailId = _idController.text;
    String korailPw = _pwController.text;

    // ID 유형 판단 (이메일, 전화번호, 회원번호)
    String txtInputFlg;
    if (RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$').hasMatch(korailId)) {
      txtInputFlg = '5'; // 이메일
    } else if (RegExp(r'^\d{3}-\d{4}-\d{4}$').hasMatch(korailId)) {
      txtInputFlg = '4'; // 전화번호
    } else {
      txtInputFlg = '2'; // 회원번호
    }

    print('txtInputFlg >>> $txtInputFlg');
    print('korailId >>> $korailId');
    print('korailPw >>> $korailPw');

    // // Encrypt password and get idx
    // final encResult = await __encPw(korailPw); 
    // final encPw = encResult['encPw'];
    // final idx = encResult['idx'];
    // print('@@ encResult >> ${encPw}, ${idx}');

    // if (encPw == '' || idx == '') {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('암호화 실패 또는 서버 응답 오류')),
    //   );
    //   return;
    // }

    final response = await http.post(
      Uri.parse('https://smart.letskorail.com:443/classes/com.korail.mobile.login.Login'),
      headers: {'User-Agent': 'Dalvik/2.1.0 (Linux; U; Android 5.1.1; Nexus 4 Build/LMY48T)'},
      body: json.encode({
        'Device': 'AD',
        'Version': '231231001',
        'txtInputFlg': txtInputFlg,
        'txtMemberNo': korailId,
        'txtPwd': 'test',
        'idx': '123',
      }),
    );

    print('>>>>>>>> ${response.body}');

    if (_idController.text == 'admin' && _pwController.text == '1111') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SearchPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('아이디 또는 비밀번호가 잘못되었습니다.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('로그인')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _idController,
              decoration: InputDecoration(labelText: '아이디'),
            ),
            TextField(
              controller: _pwController,
              obscureText: true,
              decoration: InputDecoration(labelText: '비밀번호'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text('로그인'),
            ),
          ],
        ),
      ),
    );
  }
}
