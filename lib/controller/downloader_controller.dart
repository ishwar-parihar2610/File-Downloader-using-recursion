import 'dart:io';

import 'package:downloading_application/model/download_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

final downloadNotifier = ChangeNotifierProvider((ref) => DownloderController());

class DownloderController extends ChangeNotifier {
  List<DownloadModel> downloadTaskList = [
    DownloadModel(
        downloadEnum: DownloadEnum.pending,
        url: "https://css4.pub/2015/textbook/somatosensory.pdf",
        percenatage: "0",
        title: "sample 1"),
    DownloadModel(
        downloadEnum: DownloadEnum.pending,
        url: "https://css4.pub/2015/textbook/somatosensory.pdf",
        percenatage: "0",
        title: "sample 2"),
    DownloadModel(
        downloadEnum: DownloadEnum.pending,
        url: "https://css4.pub/2015/textbook/somatosensory.pdf",
        percenatage: "0",
        title: "sample 3"),
    DownloadModel(
        downloadEnum: DownloadEnum.pending,
        url: "https://css4.pub/2015/textbook/somatosensory.pdf",
        percenatage: "0",
        title: "sample 4"),
    DownloadModel(
        downloadEnum: DownloadEnum.pending,
        url: "https://css4.pub/2015/textbook/somatosensory.pdf",
        percenatage: "0",
        title: "sample 5"),
    DownloadModel(
        downloadEnum: DownloadEnum.pending,
        url: "https://css4.pub/2015/textbook/somatosensory.pdf",
        percenatage: "0",
        title: "sample 6"),
    DownloadModel(
        downloadEnum: DownloadEnum.pending,
        url: "https://css4.pub/2015/textbook/somatosensory.pdf",
        percenatage: "0",
        title: "sample 7"),
    DownloadModel(
        downloadEnum: DownloadEnum.pending,
        url: "https://css4.pub/2015/textbook/somatosensory.pdf",
        percenatage: "0",
        title: "sample 8"),
    DownloadModel(
        downloadEnum: DownloadEnum.pending,
        url: "https://css4.pub/2015/textbook/somatosensory.pdf",
        percenatage: "0",
        title: "sample 9"),
    DownloadModel(
        downloadEnum: DownloadEnum.pending,
        url: "https://css4.pub/2015/textbook/somatosensory.pdf",
        percenatage: "0",
        title: "sample 10"),
  ];

  updateMyIndexListValue(int index, DownloadModel modelData) {
    downloadTaskList[index] = modelData;
    notifyListeners();
  }

  fileDownloadResurcion(int index) async {
    if (index == downloadTaskList.length) {
      return;
    }
    await downloadFile(
        url: downloadTaskList[index].url,
        filename: downloadTaskList[index].title ?? "",
        index: index);
    await Future.delayed(const Duration(seconds: 1));
    fileDownloadResurcion(index + 1);
  }

  Future downloadFile(
      {required String url,
      required String filename,
      required int index}) async {
    File? downloadedFile;
    String downloadMessage = "Press download";

    try {
      HttpClient client = HttpClient();
      List<int> downloadData = [];

      Directory downloadDirectory;

      if (Platform.isIOS) {
        downloadDirectory = await getApplicationDocumentsDirectory();
      } else {
        downloadDirectory = Directory('/storage/emulated/0/Download');
        if (!await downloadDirectory.exists()) {
          downloadDirectory = (await getExternalStorageDirectory())!;
        }
      }

      String filePathName = "${downloadDirectory.path}/$filename.pdf";
      File savedFile = File(filePathName);
      bool fileExists = await savedFile.exists();

      if (fileExists) {
        updateMyIndexListValue(
            index,
            DownloadModel(
                url: url,
                downloadEnum: DownloadEnum.completed,
                percenatage: "0",
                title: filename));
      } else {
        updateMyIndexListValue(
            index,
            DownloadModel(
                url: url,
                downloadEnum: DownloadEnum.started,
                percenatage: "0",
                title: filename));

        await client.getUrl(Uri.parse(url)).then(
          (HttpClientRequest request) {
            downloadMessage = "Loading";
            print(downloadMessage);
            return request.close();
          },
        ).then(
          (HttpClientResponse response) async {
            response.listen((d) => downloadData.addAll(d), onDone: () async {
              await savedFile.writeAsBytes(downloadData);
              downloadedFile = savedFile;
              updateMyIndexListValue(
                  index,
                  DownloadModel(
                      url: url,
                      downloadEnum: DownloadEnum.completed,
                      percenatage: "0",
                      title: filename));

              print("donwloaded file ${downloadedFile?.path}");
            });
          },
        );
      }
    } catch (error) {
      print("Some error occurred -> $error");
    }
  }
}
