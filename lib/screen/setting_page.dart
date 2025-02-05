import 'package:flutter/material.dart';
import 'package:lolplatform/screen/match_page.dart';

const buttonColor = Color(0xFFE5E9F0); // 연한 회색빛 색상
const tintColor = Color(0xFFE5E9F0);

// BottomNavigationBar 설정 클릭시 넘어오는 화면 구현
class Setting extends StatefulWidget {
  @override
  _Setting createState() => _Setting(); // createState 매서드에서 _MatchState라는 State 객체 생성하여 MatchScreen과 연결
}

class _Setting extends State<Setting> {

  Widget buildButton(String title, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity, // 가로로 꽉 채움
      height: 80,
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
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  int _selectedIndex = 1; // 0: 매칭, 1:설정

// 탭을 눌렀을 때 해당 페이지로 이동하는 함수
  void _onItemTapped(int index) {
    if (index != _selectedIndex) { // 현재 페이지가 아닌 다른 탭을 눌렀을 때만
      if (index == 0) { // 추천 탭
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MatchScreen()),
        );
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold (
      backgroundColor: Colors.white,
      appBar: AppBar(
        title : Text (
          'Setting',
          style: TextStyle(
            color:Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white54,
        elevation: 0,
      ),

      body: Container(
        child: Column (
          children: [

            buildButton('나의 정보', () {

            }),
            buildButton('매칭 기록', () {

            }),
            buildButton('내가 남긴 리뷰', (){

            }),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar (
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex, // currentIndex 속성에 _selectedIndex로 지정
        onTap: (index) { // indexsms 클릭된 items의 위치 (0,1,2)를 자동으로 받음
          if (index == 0) {
            Navigator.pushReplacement (
              context,
              MaterialPageRoute(builder: (context) => MatchScreen()),
            );
          } else if (index == 1) {
            // 현재 페이지
          }
        },
        items: [
          //BottomNavigationBar는 내부적으로 배열로 구현되어있고, 모든 리스트는 0으로부터 시작
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
        unselectedItemColor:Colors.black,
      ),
    );
  }
}