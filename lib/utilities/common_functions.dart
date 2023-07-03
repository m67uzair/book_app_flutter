import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:permission_handler/permission_handler.dart';

bool fileAlreadyExits(String filePath) {
  final file = File(filePath);
  if (file.existsSync()) {
    return true;
  } else {
    return false;
  }
}

Future<void> openFile(String fileName) async {
  String filePath = '/storage/emulated/0/Download/$fileName.pdf';
  var status = await Permission.storage.status;
  if (status.isGranted) {
    try {
      if (fileAlreadyExits(filePath)) {
        await OpenFile.open(filePath);
      } else {
        Fluttertoast.showToast(msg: "File doesn't exist anymore");
      }
    } on Exception catch (e) {
      Fluttertoast.showToast(msg: "Cant Open File $fileName");
    }
  } else {
    Fluttertoast.showToast(msg: "We need storage permission to open the file");
    await requestPermission();
  }
}

Future<void> requestPermission() async {
  await [Permission.manageExternalStorage, Permission.storage].request();
}
