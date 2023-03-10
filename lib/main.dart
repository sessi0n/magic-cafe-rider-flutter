import 'dart:async';
import 'dart:io';
import 'package:bike_adventure/app_binding.dart';
import 'package:bike_adventure/constants/environment.dart';
import 'package:bike_adventure/logo_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk_navi/kakao_flutter_sdk_navi.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = NoCheckCertificateHttpOverrides(); // 생성된 HttpOverrides 객체 등록

  await dotenv.load(fileName: Environment.fileName);
  // await initializeDateFormatting('ko_KR', null);
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // ).whenComplete(() => debugPrint("completed firebase initializeApp"));

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent
  ));

  KakaoSdk.init(nativeAppKey: 'e4fce95ee57703a494f6e5fed871dde5');
  // localhostServer.start();
  // if (Platform.isAndroid) {
  //   await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(false);
  // }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Bike Adventure',
      initialBinding: AppBinding(),
      theme: ThemeData(
        fontFamily: 'NotoSansKR',
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        primaryColor: Colors.white,
        ),
      home: const LogoPage(),
    );
  }
}

class TempContainer extends StatefulWidget {
  const TempContainer({Key? key}) : super(key: key);

  @override
  State<TempContainer> createState() => _TempContainerState();
}

class _TempContainerState extends State<TempContainer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Text('1111111111111111111'),
        ),
      ),
    );
  }
}


class NoCheckCertificateHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

