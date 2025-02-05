import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Write extends StatefulWidget {
  @override
  _WriteState createState() => _WriteState();
}

class _WriteState extends State<Write> {
  // 선택 버튼으로 선택하는 값을 일시적으로 저장(이후 Firestore에 저장)
  String? selectedGameType;
  String? selectedMatchType;
  String? selectedPosition;
  String? selectedMemberCount;
  final TextEditingController tierController = TextEditingController();
  final TextEditingController dateTimeController = TextEditingController();
  final TextEditingController chatLinkController = TextEditingController();

  Future<void> saveToFirestore()async {
    try{
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      DateTime now = DateTime.now(); // 현재 시간을 저장

      Map<String, dynamic> postData = { // 저장할 데이터의 구조와 내용 postData Map
        'type' : selectedGameType ?? '', // 게임 타입(소환사의 협곡/칼바람)
        'mode' : selectedMatchType ?? '', // 게임모드(랭크/자유랭크/일반)
        'position' : selectedPosition ?? '', // 역할(탑/정글/미드/원딜/서폿)
        'people' : selectedMemberCount ?? '', // 모집 인원
        'tier' : tierController.text, // 티어
        'datetime' : dateTimeController.text, // 날짜, 시간
        'chatlink' : chatLinkController.text, // 오픈채탱 링크
        'createdAt' : now, // 생성 시간 저장
      };

      await firestore.collection('write').add(postData); // Firestore에 저장
      Navigator.pop(context);
    } catch(e) {

    }
  }

  Widget buildOptionGroup(String title, List<String> options, String? selectedValue, Function(String) onSelect) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: options.map((option) { // 각 옵션('소환사 협곡', '칼바람')을 반복적으로 빌드
                bool isSelected = selectedValue == option; // 현재 옵션이 선택되었는지 확인
                return Expanded( // 옵션 버튼들이 가로 공간을 균등하게 나눠서 차지
                  child: GestureDetector(
                    onTap: () => onSelect(option),
                    child: Text(
                      option,
                      textAlign: TextAlign.center, // 텍스트를 가운데 정렬
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, // 선택된 경우 굵은 글씨
                        color: Colors.black,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMemberCount() { // 필요한 인원 수를 선택
    List<String> counts = ['1명', '2명', '3명', '4명', '5명', '6명', '7명', '8명', '9명'];
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text('필요한 인원'),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 1,
              //runSpacing: ,
              children: counts.map((count) {
                bool isSelected = selectedMemberCount == count;
                return SizedBox(  // SizedBox로 고정 크기 지정
                  width: 50,      // 고정된 너비
                  height: 40,     // 고정된 높이
                  child: GestureDetector(
                    onTap: () => setState(() => selectedMemberCount = count),
                    child: Center(  // Center 위젯으로 텍스트 중앙 정렬
                      child: Text(
                        count,
                        style: TextStyle(
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextField(String title) { // 텍스트 입력할 수 있는 필드 생성
    TextEditingController getController(String title) {
      switch (title) {
        case '티어' :
          return tierController;
        case '날짜, 시간' :
          return dateTimeController;
        case '오픈채팅 링크' :
          return chatLinkController;
        default:
          return TextEditingController();
      }
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5), //  외부 여백
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(1),
            child: Text(title), // 입력 필드 위에 표시할 제목
          ),
          TextField(
            controller: getController(title),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(10), // 입력 영역 내 여백
              border: InputBorder.none, // 기본 테두리 없음
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          '글 쓰기',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: saveToFirestore,
            child: Text(
              '완료',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          buildOptionGroup(
            '소환사의 협곡 / 칼바람', // title
            ['소환사의 협곡', '칼바람'], // option
            selectedGameType, // 현재 선택된 값
                (value) => setState(() => selectedGameType = value), // 값 선택시 실행할 콜백
          ),
          buildOptionGroup(
            '랭크 / 자유랭크 / 일반',
            ['랭크', '자유랭크', '일반'],
            selectedMatchType,
                (value) => setState(() => selectedMatchType = value),
          ),
          buildOptionGroup(
            '탑 / 정글 / 미드 / 원딜 / 서폿',
            ['탑', '정글', '미드', '원딜', '서폿'],
            selectedPosition,
                (value) => setState(() => selectedPosition = value),
          ),
          buildMemberCount(),
          buildTextField('티어'),
          buildTextField('날짜, 시간'),
          buildTextField('오픈채팅 링크'),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: '매칭'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: '설정'),
        ],
        currentIndex: 1,
        selectedItemColor: Colors.black,
      ),
    );
  }

  @override
  void dispose() {
    tierController.dispose();
    dateTimeController.dispose();
    chatLinkController.dispose();
    super.dispose();
  }
}