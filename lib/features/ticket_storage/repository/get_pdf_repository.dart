import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class GetPdfRepository {
  final Dio dio;
  GetPdfRepository({required this.dio});

  Future<String> getPdf(String url) async {
    final Response response = await dio.get(
      url,
      onReceiveProgress: (receivedBytes, totalBytes) {
        if (totalBytes != -1) {
          double progress = receivedBytes / totalBytes * 100;
          print(progress);
        }
      },
      options: Options(responseType: ResponseType.bytes),
    );
    final dir = await getTemporaryDirectory();
    final fileName = '${dir.path}/url';
    final file = File(fileName);
    await file.writeAsBytes(response.data);
    return file.path;
  }
}
