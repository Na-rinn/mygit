import 'package:flutter/material.dart';
import 'package:lolplatform/screen/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main () async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    if (e is FirebaseException && e.code == 'duplicate-app') {
      // Firebase 앱이 이미 초기화되어 있는 경우 그냥 넘어감
    } else {
      // 그 외의 에러 발생 시 처리
      rethrow;
    }
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp (
      home : LogIn(),
      debugShowCheckedModeBanner: false, // 오른쪽 상단에 배너 띠를 없애줌
    );
  }
}