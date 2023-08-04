import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:zego_uikit_prebuilt_video_conference/zego_uikit_prebuilt_video_conference.dart';

Future<void> main() async {
  await dotenv.load(
    fileName: ".env",
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'zoom',
      home: HomePage(),
    );
  }
}

final String userId = Random().nextInt(90000 + 10000).toString();
final String randomConferenceId =
    (Random().nextInt(1000000000) * 10 + Random().nextInt(10))
        .toString()
        .padLeft(10, '0');

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final conferenceIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('your userId: $userId'), // Fixed variable name
            const SizedBox(
              height: 20,
            ),
            TextField(
              maxLength: 10,
              keyboardType: TextInputType.number,
              controller: conferenceIdController,
              decoration: const InputDecoration(
                labelText: 'Join by Input ID', // Fixed property name
              ),
            ),
            ElevatedButton(
              onPressed: () => jumpToMeetingPage(
                context,
                conferenceId: conferenceIdController.text,
              ),
              child: const Text('Join'),
            ),
            ElevatedButton(
              onPressed: () => jumpToMeetingPage(
                context,
                conferenceId: randomConferenceId,
              ),
              child: const Text('New Meeting'),
            )
          ],
        ),
      ),
    );
  }

  void jumpToMeetingPage(BuildContext context, {required String conferenceId}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => VideoConferencePage(conferenceID: conferenceId)),
    );
  }
}

class VideoConferencePage extends StatelessWidget {
  final String conferenceID;

  VideoConferencePage({
    Key? key,
    required this.conferenceID,
  }) : super(key: key);

  final int appID = int.parse(dotenv.get('ZEGO_APP_ID'));
  final String appSign = dotenv.get('ZEGO_APP_SIGN');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ZegoUIKitPrebuiltVideoConference(
        appID: appID,
        appSign: appSign,
        userID: userId,
        userName: 'user_$userId',
        conferenceID: conferenceID,
        config: ZegoUIKitPrebuiltVideoConferenceConfig(),
      ),
    );
  }
}
