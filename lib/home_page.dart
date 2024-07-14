import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_excel/excel.dart';
import 'package:flutter_to_excel_file/list_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Map<String, dynamic>> dataList=[];


  Future<List<Post>> getPosts() async {
    var url = Uri.parse("https://jsonplaceholder.typicode.com/albums/1/photos");
    final response = await http.get(url, headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((item) => Post.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load items');
    }

  }

   downloadExcelFile(data) async {

    var permissionStatus = await Permission.storage.status;
    print("lkjklj1 ${permissionStatus}");
    if (permissionStatus.isGranted) {
      print("lkjklj1 ${permissionStatus.isGranted}");
      print("lkjk ${Permission.storage.request().isGranted}");
      if (await Permission.storage.request().isGranted) {

        Excel excel = Excel.createExcel();
        Sheet sheet = excel['Sheet1'];

        // Adding header row
        sheet.appendRow(['albumId', 'id', 'title', 'url', 'thumbnailUrl']);

        // Adding data rows
        for (dynamic item in data) {
          sheet.appendRow([
            item.albumId,
            item.id,
            item.title,
            item.url,
            item.thumbnailUrl,
          ]);
        }

        // Save the Excel file
        String filePath = '/storage/emulated/0/Download/Pending.xlsx';
        var fileBytes = excel.encode();
        File(filePath).writeAsBytesSync(fileBytes!);


        // toast message to user
        Fluttertoast.showToast(
          msg: 'Excel file successfully downloaded',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
        );

        final result = await OpenFile.open(filePath);

      } else {
        // Handle the case when permission is not granted
        print('Permission denied');
      }
    }


  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter to Excel file Store"),
      ),
body: Center(
  child: ElevatedButton(onPressed: () async {
    List<Post> listData = await getPosts();
print("lsajdlk ${listData[0].title}");
    downloadExcelFile(listData);

  },
  child: Text("Dpwnload Exce file"),),
)
    );
  }


}
