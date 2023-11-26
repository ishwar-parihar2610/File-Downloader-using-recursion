import 'package:downloading_application/controller/downloader_controller.dart';
import 'package:downloading_application/model/download_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreenPage extends ConsumerStatefulWidget {
  const HomeScreenPage({super.key});

  @override
  ConsumerState<HomeScreenPage> createState() => _HomeScreenPageState();
}

class _HomeScreenPageState extends ConsumerState<HomeScreenPage> {
  String name = "title";

  @override
  void initState() {
    ref.read(downloadNotifier).fileDownloadResurcion(0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Home Page"),
        ),
        body: Consumer(builder: (context, ref, child) {
          final controller = ref.watch(downloadNotifier);

          return ListView.builder(
            itemCount: controller.downloadTaskList.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 1,
                margin: const EdgeInsets.all(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(controller.downloadTaskList[index].title ?? ""),
                      switch (
                          (controller.downloadTaskList[index].downloadEnum ??
                              DownloadEnum.pending)) {
                        DownloadEnum.pending => const Text(
                            "Pending",
                            style: TextStyle(
                                color: Colors.redAccent, fontSize: 15),
                          ),
                        DownloadEnum.started => progrossView(),
                        DownloadEnum.completed => const Center(
                              child: Icon(
                            Icons.check_box,
                            color: Colors.green,
                          )),
                      }
                    ],
                  ),
                ),
              );
            },
          );
        }));
  }
}

Widget progrossView() {
  return const CircularProgressIndicator();
}
