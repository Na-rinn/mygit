import 'package:flutter/material.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RiotLogin extends StatefulWidget {
  @override
  _RiotLoginState createState() => _RiotLoginState();
}

class _RiotLoginState extends State<RiotLogin> {
  final String clientId = '723791';
  final String redirectUri = "lolplatform://oauth2redirect";
  final String apiKey = 'RGAPI-1a0ec87c-c5b5-4819-9d5c-7eb9c8271423';

  Future<void> riotLogin() async {
    try{
      // 1. Riot 0Auth 인증 URL 생성
      final url= Uri.https('auth.riotgames.com', '/authorize', {
        'client_id' : clientId,
        'redirect_uri': redirectUri,
        'response_type': 'code',
        'scope': 'openid offline_access',
      });

      // 2. 웹 브라우저로 0Auth 인증 실행
      final result = await FlutterWebAuth.authenticate(
        url: url.toString(),
        callbackUrlScheme: 'lolplatform',
      );

      // 3. 인증 코드 추출
      final code = Uri.parse(result).queryParameters['code'];

      if (code != null) {
        // 4.액세스 토큰 요청
        final tokenResponse = await http.post(
          Uri.parse('https://auth.riotgames.com/token'),
          headers: {
            'Content-Type' : 'application/x-www-form-urlencoded',
          },
          body: {
            'client_id' : clientId,
            'code' : code,
            'grant_type' : 'authorization_code',
            'redirect_uri' : redirectUri,
          },
        );

        if (tokenResponse.statusCode == 200) {
          final tokenData = jsonDecode(tokenResponse.body);
          final accessToken = tokenData['access_token'];

          //5. 소환사 정보 가져오기
          final summonerResponse = await http.get(
            Uri.parse('https://kr.api.riotgames.com/lol/summoner/v4/summoners/me'),
            headers:{
              'Authorization' : 'Bearer $accessToken',
              'X-Riot-Token' : apiKey
            },
          );

          if (summonerResponse.statusCode == 200) {
            final summonerData = jsonDecode(summonerResponse.body);
            //6.로그인 성공 처리 및 데이터 저장
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('로그인 성공: ${summonerData['name']}')),
            );

            //7. 메인 페이지로 이동
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MainPage(summonerData: summonerData),
              ),
            );
          }
        }
      }
    } catch (e) {
      print('Error during login: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('로그인 중 오류가 발생했습니다.')),
      );
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Riot Log in'),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Center(
          child: SizedBox(
            width: 300,
            child: ElevatedButton(
              onPressed: riotLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFD13639),
                padding: EdgeInsets.symmetric(horizontal:20, vertical: 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)
                ),
              ),
              child: Text(
                'Riot Log In',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  final Map<String, dynamic> summonerData;

  MainPage({required this.summonerData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text(summonerData['name']),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('소환사 이름: ${summonerData['name']}'),
            Text('레벨 : ${summonerData['summonerLevel']}'),
          ],
        ),
      ),
    );
  }
}
