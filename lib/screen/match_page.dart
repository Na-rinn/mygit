import 'package:flutter/material.dart';
import 'package:lolplatform/screen/write_page.dart';
import 'package:lolplatform/screen/setting_page.dart';
import 'package:lolplatform/screen/content_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

const buttonColor = Color(0xFFE5E9F0); // 연한 회색빛 색상
const tintColor = Color(0xFFE5E9F0);

class MatchScreen extends StatefulWidget {
  @override
  _MatchState createState() => _MatchState(); // createState 매서드에서 _MatchState라는 State 객체 생성하여 MatchScreen과 연결
}

class _MatchState extends State<MatchScreen> {
  int _selectedIndex = 0; // 0: 매칭, 1:설정

  // 버튼 빌더 함수
  Widget buildButton(String text, String subtitle, String date, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity, // 가로로 꽉 채움
      height: 130,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          surfaceTintColor: tintColor,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: const BorderSide(color: Colors.white),
          ),
        ),
        child: Row(
          children: [
            const SizedBox(width: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.center, // 글자 세로 중앙 정렬
              crossAxisAlignment: CrossAxisAlignment.start, // 텍스트 왼쪽 정렬
              children: [
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 25,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
                Text(
                  date,
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Stream<QuerySnapshot> getMatchesStream() {
    return FirebaseFirestore.instance
        .collection('write')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Match',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
        body: StreamBuilder<QuerySnapshot>(
          stream: getMatchesStream(),
          builder: (context, snapshot) {
            if (snapshot.hasError) { // 에러 메시지 표시
              return Center(child: Text('오류가 발생했습니다: ${snapshot.error}'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) { // 로딩 화면 표시
              return Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) { // hasData가 없으면 "등록된 글이 없습니다"표시
              return Center(child: Text('등록된 글이 없습니다'));
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: snapshot.data!.docs.map((doc) {
                  // Firestore 문서의 데이터를 Map으로 변환
                  Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                  // 부제목 구성
                  String subtitle = ''; // 부제목 변수 초기화
                  if (data['type'] != null && data['type'].toString().isNotEmpty) {
                    subtitle += "${data['type']} / ";
                  }
                  if (data['position'] != null && data['position'].toString().isNotEmpty) {
                    subtitle += "${data['position']} / ";
                  }
                  subtitle += "${data['people']} 모집 ";

                  return Column(
                    children: [
                      buildButton(
                        data['type'] ?? '제목 없음',  // type을 제목으로 사용
                        '${data['mode'] ?? ''} / ${data['position'] ?? ''} / ${data['people'] ?? ''} 모집',  // 부제목 수정
                        data['datetime'] ?? '날짜 없음',
                            () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Content(
                                  key: UniqueKey(),
                                  nickname: "Faker", // Content 페이지에 nickname을 전달
                                  rating: "4.3/5.0",
                                  type: data['type'] ?? '', //Firestore에서 가져온 게임 타입 전달
                                  mode: data['mode'] ?? '',
                                  position: data['position'] ?? '',
                                  people: data['people'] ?? '',
                                  tier: data['tier'] ?? '',
                                  dateTime: data['datetime'] ?? '' ,
                                  chatlink: data['chatlink'] ?? '',
                                ),
                             ),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                    ],
                  );
                }).toList(),
              ),
            );
          },
        ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Write()),
          );
        },
        child: const Icon(Icons.add), // 추가 아이콘
        shape: const CircleBorder(),
        elevation: 0,
        backgroundColor: Color(0xFFCFD4DE),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index == 0) {
            // 현재 페이지
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Setting()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: '매칭',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '설정',
          ),
        ],
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.black,
      ),
    );
  }
}
