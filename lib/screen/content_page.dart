import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
//import 'package:lolplatform/screen/match_page.dart';

const buttonColor = Color(0xFFE5E9F0); // 연한 회색빛 색상
const tintColor = Color(0xFFE5E9F0);
// 글쓴 화면을 보여줌
class Content extends StatefulWidget {
  final String nickname;
  final String rating;
  final String type;
  final String mode;
  final String position;
  final String people;
  final String tier;
  final String dateTime;
  final String chatlink;

  const Content({
    super.key,
    required this.nickname,
    required this.rating,
    required this.type,
    required this.mode,
    required this.position,
    required this.people,
    required this.tier,
    required this.dateTime,
    required this.chatlink,
  });

  @override
  State<Content> createState() => _ContentState();
}

class _ContentState extends State<Content> {
  Future<void> _launchURL() async {
    final Uri url = Uri.parse(widget.chatlink);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'content',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),

          SizedBox(
            width: 400,
            height: 100,
            child: ElevatedButton(
              onPressed: () {
                /*Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Review()),
                );*/
              },
              child: Row(
                children: [
                  Container(  // 프로필 동그라미
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      //color: Color(0xFFD8DDE6),
                      shape: BoxShape.circle,
                    ),
                    child: CircleAvatar(
                      backgroundColor: Color(0XFFCFD4DE),
                      radius: 25,  // 지름의 절반 크기
                      child: Icon(Icons.person),
                    ),
                  ),
                  SizedBox(width: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,  // 글자 세로 중앙 정렬
                    crossAxisAlignment: CrossAxisAlignment.start,  // 텍스트 왼쪽 정렬
                    children: [
                      Text(
                        "Faker",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        "(3.9/5.0)",
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                surfaceTintColor: tintColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          Padding (
            padding: EdgeInsets.symmetric(horizontal: 5.0), // 양 옆 사이즈 맞춤
            child : SizedBox(
              width: 400,
              height: 300,
              child: ElevatedButton(
                onPressed: () {},
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,  // 글자 세로 중앙 정렬
                  //crossAxisAlignment: CrossAxisAlignment.start,  // 텍스트 왼쪽 정렬
                  children: [
                    Text(
                      widget.type,
                      style: TextStyle (
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10,),

                    Text(
                      widget.mode,
                      style: TextStyle (
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10,),

                    Text(
                      "모집 인원 : ${widget.people}",
                      style: TextStyle (
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10,),

                    Text(
                      widget.position,
                      style: TextStyle (
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10,),

                    Text(
                      widget.tier,
                      style: TextStyle (
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10,),

                    Text(
                      widget.dateTime,
                      style: TextStyle (
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),

                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(buttonColor),
                  surfaceTintColor: MaterialStateProperty.all(tintColor),
                  splashFactory: NoSplash.splashFactory,
                  elevation: MaterialStateProperty.all(0),  // 모든 상태에서 높이 0
                  shadowColor: MaterialStateProperty.all(Colors.transparent),  // 그림자 색 투명하게
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                ),
              ),
            ),
          ),

          SizedBox(height: 30),

          SizedBox(
            width: 400,
            height: 80,
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        width: 400,
                        height: 200,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '오픈채팅 링크',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 20),
                            GestureDetector(
                              onTap: () => _launchURL(),
                              child: Container(
                                padding: EdgeInsets.all(20),
                                child: Text(
                                  widget.chatlink,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),
                          ],  // Column children 닫기
                        ),
                      ),
                    );
                  },
                );
              },
              child: Text(
                "신청하기 (0/4)",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black87,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                surfaceTintColor: tintColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}