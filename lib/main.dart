import 'dart:convert';
// ignore: unused_import
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:date_format_field/date_format_field.dart';
import 'detail.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:file_picker/file_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //disappear debug sign
      debugShowCheckedModeBanner: false,
      title: 'flutter get_json',
      theme: ThemeData.dark().copyWith(primaryColor: Colors.blue),
      home: const MyHomePage(title: 'flutter get_json'),
    );
  }
}

Future<List<Map<String, dynamic>>> loadJsonFromAssets(
    String LocalFilePath) async {
  String jsonString = await rootBundle.loadString(LocalFilePath);
  List<dynamic> jsonData = jsonDecode(jsonString);
  return jsonData.cast<Map<String, dynamic>>();
}

String? validateEmail(String? value) {
  const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
      r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
      r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
      r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
      r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
      r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
      r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
  final regex = RegExp(pattern);

  return value!.isNotEmpty && !regex.hasMatch(value)
      ? 'Enter a valid email address'
      : null;
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final myController = TextEditingController();
  bool _isCheckMen = false;
  bool _isCheckWomen = false;
  String jsonPath = 'assets/jsonFile/user.json';
  String UserName = '';
  bool? UserGender;
  List<Map<String, dynamic>> data = [];
  List<Map<String, dynamic>> origindata = [];
  List<Map<String, dynamic>> searchedData = [];
  bool setPassword = true;
  String? isSelectedItem = '1';
  String? select_radioBTN;
  bool checkedValue1 = false;
  bool checkedValue2 = false;

  @override
  void initState() {
    super.initState();
    loadJsonData();
  }

  Future<void> loadJsonData() async {
    data = await loadJsonFromAssets(jsonPath);
    origindata = await loadJsonFromAssets(jsonPath);
    setState(() {});
  }

  List<Map<String, dynamic>> resultSearch() {
    List<Map<String, dynamic>> filteredData = List.from(origindata);

    //search name
    if (UserName.isNotEmpty) {
      filteredData
          .retainWhere((item) => item['name'].toString().contains(UserName));
    }
    //print(filteredData);

    //search gender
    if (UserGender != null) {
      filteredData.retainWhere(
          (item) => item['Gender'] == (UserGender! ? 'Male' : 'Female'));
    }
    //print(filteredData);
    return filteredData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        child: ListView(
          children: [
            SizedBox(
              width: 300,
              height: 50,
              child: Container(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.08,
                    ),
                    Text("NAME  :  "),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.10,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: TextField(
                        controller: myController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'name',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.07,
                    ),
                    Text("Gender  :  "),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.10,
                    ),
                    Text("Male"),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.12,
                    ),
                    Checkbox(
                      activeColor: Colors.blue,
                      value: _isCheckMen,
                      onChanged: (value) {
                        setState(() {
                          _isCheckMen = value!;
                          _isCheckWomen = false;
                        });
                      },
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.1,
                    ),
                    Text("Female"),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.12,
                    ),
                    Checkbox(
                      activeColor: Colors.red,
                      value: _isCheckWomen,
                      onChanged: (value) {
                        setState(() {
                          _isCheckWomen = value!;
                          _isCheckMen = false;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.2,
                  height: 70,
                  child: Row(
                    children: [
                      Text('search'),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            UserName = myController.text;
                            UserGender = _isCheckMen
                                ? true
                                : _isCheckWomen
                                    ? false
                                    : null;
                            searchedData = resultSearch();
                            print(searchedData);
                            data = searchedData;
                          });
                        },
                        icon: const Icon(Icons.search),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(),
                  color: Colors.white12,
                ),
                child: data.isEmpty
                    //on loading circul
                    ? Center(
                        child: Text(
                        'there is no data',
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        style: TextStyle(
                          fontFamily: "Open Sans",
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: Colors.white,
                        ),
                      ))
                    : DataTable(
                        columns: const [
                          DataColumn(label: Text('NAME')),
                          DataColumn(label: Text('Gender')),
                          DataColumn(label: Text('Details')),
                        ],
                        rows: data.map<DataRow>((item) {
                          return DataRow(
                            cells: [
                              DataCell(Text(item['name'])),
                              DataCell(Text(item['Gender'])),
                              DataCell(
                                IconButton(
                                  icon: const Icon(Icons.settings),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => detailData(
                                            title: 'Details', data: item),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                decoration: (BoxDecoration(border: Border.all())),
                child: Column(
                  children: [
                    //Name,
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'name',
                      ),
                    ),
                    //password
                    TextFormField(
                      obscureText: setPassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                      ),
                    ),
                    Form(
                      autovalidateMode: AutovalidateMode.always,
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'email',
                        ),
                        validator: validateEmail,
                      ),
                    ),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'phone',
                      ),
                      keyboardType: TextInputType.phone,
                      autofillHints: [
                        AutofillHints.telephoneNumber,
                      ],
                    ),
                    TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'input number'),
                    ),
                    DateFormatField(
                      type: DateFormatType.type4,
                      addCalendar: true,
                      onComplete: (date) {},
                    ),
                    DropdownButton(
                      //4
                      items: const [
                        //5
                        DropdownMenuItem(
                          child: Text('1'),
                          value: '1',
                        ),
                        DropdownMenuItem(
                          child: Text('2'),
                          value: '2',
                        ),
                        DropdownMenuItem(
                          child: Text('3'),
                          value: '3',
                        ),
                      ],
                      //6
                      onChanged: (String? value) {
                        setState(() {
                          isSelectedItem = value;
                        });
                      },
                      //7
                      value: isSelectedItem,
                    ),
                    RadioListTile<String>(
                      title: Text('1'),
                      value: '1',
                      groupValue: select_radioBTN,
                      onChanged: (value) {
                        setState(() {
                          select_radioBTN = value;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: Text('2'),
                      value: '2',
                      groupValue: select_radioBTN,
                      onChanged: (value) {
                        setState(() {
                          select_radioBTN = value;
                        });
                      },
                    ),
                    Checkbox(
                      activeColor: Colors.white30,
                      value: checkedValue1,
                      onChanged: (value) {
                        setState(() {
                          checkedValue1 = value!;
                        });
                      },
                    ),
                    Checkbox(
                      activeColor: Colors.white30,
                      value: checkedValue2,
                      onChanged: (value) {
                        setState(() {
                          checkedValue2 = value!;
                        });
                      },
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text('button'),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text('button'),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text('request'),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text('reset'),
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        label: Text('label'),
                      ),
                    ),
                    Icon(
                      Icons.image,
                      size: 150,
                      color: Colors.grey,
                    ),
                    IconButton(
                      onPressed: () {
                        myDialog(context);
                      },
                      icon: Icon(Icons.image),
                      iconSize: 150.0,
                    ),
                    Text('hyper link test'),

                    InkWell(
                      child: Text(
                        'ハイパーリンク!',
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      onTap: () {
                        _launchURL(context);
                      },
                    ),
                    Container(
                      decoration: BoxDecoration(border: Border.all()),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          'File Upload',
                          style: TextStyle(
                              fontSize: 10.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10.0),
                        ElevatedButton.icon(
                          onPressed: () {
                            fileSelect(context);
                          },
                          icon: Icon(Icons.file_upload),
                          label: Text('ファイルを選択'),
                        ),
                      ],
                    ),

                    Container(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Table',
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 20.0),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(),
                            ),
                            child: Table(
                              border: TableBorder.all(),
                              columnWidths: {
                                0: FlexColumnWidth(1),
                                1: FlexColumnWidth(1),
                              },
                              children: [
                                TableRow(children: [
                                  TableCell(
                                    child: Center(
                                      child: Text(
                                        'ボタン',
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    child: Center(
                                      child: Text(
                                        'リンク',
                                      ),
                                    ),
                                  ),
                                ]),
                                TableRow(
                                  children: [
                                    TableCell(
                                      child: Center(
                                        child: ElevatedButton(
                                          onPressed: () {},
                                          child: Text('ボタン'),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Center(
                                        child: InkWell(
                                          child: Text(
                                            'リンク',
                                            style: TextStyle(
                                              color: Colors.blue,
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                          ),
                                          onTap: () {
                                            _launchURL(context);
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

Future<void> _launchURL(BuildContext context) async {
  String url = 'https://www.google.com';
  bool launched = await launchUrl(Uri.parse(url));
  print(launched);
  if (!launched) {
    //throw 'Could not launch $url';
  }
}

Future<bool> launchUrl(Uri url) async {
  return await launch(
    url.toString(),
    forceWebView: false,
    enableJavaScript: true,
    enableDomStorage: true,
  );
}

void fileSelect(BuildContext context) async {
  FilePickerResult? result =
      await FilePicker.platform.pickFiles(allowMultiple: false);

  if (result != null) {
    //List<dynamic> filePaths = result.paths;
    PlatformFile file = result.files.first;

    print(file.extension);
    print(' file selected');
  } else {
    print('User canceled the picker');
  }
}

void myDialog(context) {
  showDialog(
    context: context,
    builder: (context) {
      //전체화면은 dialog.fullscreen
      return Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("pop-up."),
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.close),
            )
          ],
        ),
      );
    },
  );
}
