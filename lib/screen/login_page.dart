import 'package:flutter/material.dart';
import 'package:lolplatform/screen/match_page.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lolplatform/screen/roit_login.dart';

class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  // google login
  final FirebaseAuth _auth = FirebaseAuth
      .instance; // Firebase 인증을 위한 인스턴스 (로그인 or 로그아웃 할 때 사용
  GoogleSignIn _googleSignIn = GoogleSignIn(); // Google 계정으로 로그인 할 수 있는 기능 제공

  Future<void> signInWithGoogle() async {
    // 구글 로그인 프로세스
    try {
      GoogleSignInAccount? _account = await _googleSignIn.signIn();

      if (_account != null) {
        final GoogleSignInAuthentication _googleAuth = await _account
            .authentication;

        // Firebase 인증정보 생성
        final credential = GoogleAuthProvider.credential(
          accessToken: _googleAuth.accessToken,
          idToken: _googleAuth.idToken,
        );

        // Firebase 로그인 수행
        await _auth.signInWithCredential(credential);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("로그인 완료"),
            duration: Duration(seconds: 1),
          ),
        );

        //match_page.dart 페이지로 이동
        Navigator.pushReplacement( // 뒤로 가기 버튼을 눌러도 돌아 갈 수 없음
          context,
          MaterialPageRoute(builder: (context) => RiotLogin()),
        );
      }
    } catch (error) {
      print('Google 로그인 에러 : $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("로그인 중 오류가 발생했습니다."),
            duration: Duration(seconds: 1),
        ),
      );
    }
  }

  Widget buildButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: 300,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(color: Colors.black),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFE5E9F0),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Log in'), // Appbar 중앙에 "log in" 이라는 텍스트를 표시
        backgroundColor: Colors.white,
        centerTitle: true,
      ),

      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus(); // 화면 탭 시 키보드 숨기기
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬
          children: [
            Form(
              child: Theme(
                data: ThemeData(
                  inputDecorationTheme: InputDecorationTheme( // TextField  안에 있는 라벨의 스타일을 지정
                      labelStyle: TextStyle(color: Colors.black, fontSize: 13.0)
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 50.0),
                  child: Column(
                    children: [
                      buildButton('google로 로그인', () {
                        signInWithGoogle();
                      }),
                      SizedBox(height: 30.0), // 구분선과 다음 button의 간격
                      buildButton('apple로 로그인', () {
                        // 동작 구현
                      }),
                      SizedBox(height: 70.0), // 구분선과 다음 button의 간격
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}