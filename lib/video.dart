import 'package:flutter/material.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class VideoPage extends StatefulWidget {
  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  bool isRecording = false; // 녹화 상태 관리
  String? outputPath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          '화면 녹화',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(top: 30),
              child: Image.asset(
                'assets/icon_main.png',
                width: 350,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: isRecording
                  ? null
                  : () async {
                bool granted = await requestPermissions();
                if (granted) {
                  await startScreenRecording(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("권한이 필요합니다.")),
                  );
                }
              },
              child: Text(
                '녹화 시작',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(250, 60),
                backgroundColor: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isRecording
                  ? () async {
                await stopScreenRecording(context);
              }
                  : null,
              child: Text(
                '녹화 중지',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(250, 60),
                backgroundColor: isRecording ? Colors.red : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> requestPermissions() async {
    // 필요한 권한 요청
    Map<Permission, PermissionStatus> statuses = await [
      Permission.microphone,
      Permission.storage,
    ].request();

    return statuses.values.every((status) => status.isGranted);
  }

  Future<void> startScreenRecording(BuildContext context) async {
    // 내부 저장소 경로 얻기
    final directory = await getExternalStorageDirectory();
    outputPath = '${directory?.path}/recording.mp4';

    // FFmpeg 명령어 생성
    String command =
        '-f lavfi -i testsrc=duration=10:size=1280x720:rate=30 -codec:v libx264 -preset ultrafast $outputPath';

    // FFmpeg 명령어 실행
    FFmpegKit.execute(command).then((session) {
      setState(() {
        isRecording = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("녹화가 시작되었습니다. 파일 경로: $outputPath")),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("녹화 시작에 실패했습니다: $error")),
      );
    });
  }

  Future<void> stopScreenRecording(BuildContext context) async {
    // 녹화 상태 변경
    setState(() {
      isRecording = false;
    });

    // 녹화 중지 메시지
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("녹화가 중지되었습니다. 파일 경로: $outputPath")),
    );
  }
}
