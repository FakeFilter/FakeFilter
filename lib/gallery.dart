import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class GalleryPage extends StatefulWidget {
  final List<XFile> images; // 갤러리에서 선택한 이미지 목록

  GalleryPage({Key? key, required this.images}) : super(key: key);

  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  final ImagePicker picker = ImagePicker(); // 이미지 선택기 인스턴스

  Future<void> _pickImage(BuildContext context) async {
    // 갤러리에서 이미지를 선택하는 함수
    final XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      // 선택한 이미지가 있으면 갤러리 페이지로 다시 이동
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GalleryPage(images: [...widget.images, pickedImage]),
        ),
      );
    }
  }

  void _startInspection() {
    // 검사 시작 버튼 클릭 시 처리할 함수
    if (widget.images.isEmpty) {
      // 이미지가 없으면 경고 메시지 표시
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              '경고',
              style: TextStyle(
                fontWeight: FontWeight.bold, // 볼드체
                color: Colors.red, // 빨간색
              ),
            ),
            content: Text(
              '영상을 업로드 해주세요.',
              style: TextStyle(
                fontWeight: FontWeight.bold, // 볼드체
              ),
            ),
            actions: [
              TextButton(
                child: Text(
                  '확인',
                  style: TextStyle(
                    fontWeight: FontWeight.bold, // 볼드체
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      // 검사 시작 로직 추가
      // 여기서 검사 시작 관련 코드를 추가할 수 있습니다.
      print('검사 시작');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // 배경색을 검정색으로 설정
      appBar: AppBar(
        title: Text(
          '업로드',
          style: TextStyle(
            color: Colors.white, // 흰색
            fontWeight: FontWeight.bold, // 볼드체
          ),
        ),
        backgroundColor: Colors.black, // AppBar 배경색도 검정색으로 설정
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white), // 뒤로가기 버튼 아이콘 흰색으로 설정
          onPressed: () {
            Navigator.pop(context); // 이전 화면으로 돌아가기
          },
        ),
      ),
      body: Column(
        children: [
          // 위쪽에 네모 칸 추가 (높이를 50%로 설정)
          Container(
            height: MediaQuery.of(context).size.height * 0.5, // 화면 높이의 50% 차지
            margin: EdgeInsets.all(16.0), // 외부 여백
            padding: EdgeInsets.all(16.0), // 내부 여백
            decoration: BoxDecoration(
              color: Colors.grey[800], // 네모 칸 색상
              borderRadius: BorderRadius.circular(8.0), // 모서리 둥글게
            ),
            child: Center( // 자식 위젯을 중앙에 배치
              child: ElevatedButton.icon(
                onPressed: () => _pickImage(context), // 플러스 버튼 클릭 시 이미지 선택
                icon: Icon(Icons.add, color: Colors.black), // 플러스 아이콘 검정색
                label: Text(
                  '영상 추가',
                  style: TextStyle(
                    color: Colors.black, // 텍스트 검정색
                    fontWeight: FontWeight.bold, // 글씨를 볼드체로 설정
                    fontSize: 20, // 글씨 크기를 키움
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // 버튼 배경색 변경
                  minimumSize: Size(200, 60), // 버튼 크기를 크게 설정
                ),
              ),
            ),
          ),
          // 그리드 뷰 이미지 표시
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 열 수
                childAspectRatio: 1, // 가로세로 비율
              ),
              itemCount: widget.images.length,
              itemBuilder: (context, index) {
                return Image.file(
                  File(widget.images[index].path),
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
          // 검사 시작 버튼 추가 (맨 아래에 위치)
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: ElevatedButton(
              onPressed: _startInspection, // 버튼 클릭 시 경고 메시지 또는 검사 시작
              child: Text(
                '검사 시작',
                style: TextStyle(
                  color: Colors.black, // 글씨 색상을 검정색으로 설정
                  fontWeight: FontWeight.bold, // 볼드체
                  fontSize: 20, // 글씨 크기를 설정
                ),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(250, 60), // 버튼 너비를 전체로 설정
                backgroundColor: Colors.white, // 버튼 배경색을 흰색으로 설정
              ),
            ),
          ),
          SizedBox(height: 150),
        ],
      ),
    );
  }
}
