import 'dart:io';

import 'package:ext_storage/ext_storage.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class FlutterzoopUtils {
  /// Método para recuperação do diretório de downloads
  Future<String> getDownloadDirectoryPath() async {
    return await ExtStorage.getExternalStoragePublicDirectory(
        ExtStorage.DIRECTORY_DOWNLOADS);
  }

  /// Método para recuperação do arquivo de histórico
  Future<File> getPinpadHistoryFile() async {
    if (await Permission.storage.request().isGranted) {
      final directory = await getDownloadDirectoryPath();

      // Recuperando o arquivo do dia atual
      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      final String dtFormatted = formatter.format(DateTime.now());

      String path =
          '$directory/box247vm/logs_pinpad/${dtFormatted}_pinPadLogs.txt';

      if (await File(path).exists()) {
        return File(path);
      } else {
        return File(path).create(recursive: true);
      }
    } else {
      print(
          "Sem permissão para acesso ao diretório de salvamento do arquivo de texto");
      return null;
    }
  }

  /// Método para salvamento dos dados de histórico
  Future<File> savePinpadHistoryData(String data) async {
    int attempts = 0;

    while (attempts < 4) {
      try {
        final file = await getPinpadHistoryFile();

        return await file.writeAsString(
            '::: LOG: ${DateTime.now()} -- $data\n\n',
            mode: FileMode.append);
      } catch (e) {
        attempts++;
      }
    }
    return null;
  }
}
