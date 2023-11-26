enum DownloadEnum { pending, started, completed }

class DownloadModel {
  String url;
  String? title;
  DownloadEnum? downloadEnum;
  String percenatage;

  DownloadModel(
      {required this.url,
      required this.title,
      required this.percenatage,
      required this.downloadEnum});
}
