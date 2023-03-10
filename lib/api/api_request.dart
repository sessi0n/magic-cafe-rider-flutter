import 'dart:convert';
import 'dart:io';

import 'package:bike_adventure/constants/environment.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiRequest {
  final String url;
  final dynamic body;

  ApiRequest({required this.url, this.body});

  getUri() {
    if (Environment.isDev()) {
      return Uri.parse('${Environment.apiUrl}/api$url');
    }
    else
    {
      return Uri.https(Environment.apiUrl, '/api$url');
    }
  }

  Future<http.Response> post() {
    var parsedUrl = getUri();
    debugPrint('post url: $parsedUrl');
    debugPrint('body: $body');
    return http.post(parsedUrl,
        body: json.encode(body),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        }).timeout(const Duration(minutes: 2));
  }

  Future<http.Response> put() {
    var parsedUrl = getUri();
    debugPrint('put url: $parsedUrl');
    debugPrint('body: $body');
    return http.put(parsedUrl,
        body: json.encode(body),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        }).timeout(const Duration(minutes: 2));
  }

  Future<http.Response> get() {
    var parsedUrl = getUri();
    return http.get(parsedUrl).timeout(const Duration(minutes: 2));
  }

  Future<http.Response> del() {
    var parsedUrl = getUri();
    return http.delete(parsedUrl).timeout(const Duration(minutes: 2));
  }

  Future<http.Response> kakaoMap() {
    var parsedUrl = getUri();
    if (kDebugMode) {
      print('parsedUrl: $parsedUrl');
    }
    return http.get(parsedUrl).timeout(const Duration(minutes: 2));
  }

  Future<dynamic> uploadFormData(List<String> pickedImages) async {
    List<File> imageFileList = <File>[];

    var request = http.MultipartRequest("POST", getUri());

    request.fields['parameter'] = '보내고 싶은 파라미터';
    request.fields['parameter2'] = '보내고 싶은 파라미터2';

    for (var imageFile in imageFileList) {
      request.files.add(await http.MultipartFile.fromPath('files', imageFile.path));
    }

    var response = await request.send();

    return null;
  }


}
