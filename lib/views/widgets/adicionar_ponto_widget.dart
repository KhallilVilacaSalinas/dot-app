import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:ponto_prevent/models/user_model.dart';
import 'package:ponto_prevent/themes/app_colors.dart';
import 'package:ponto_prevent/themes/app_text_styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';

class AdicionarPontoWidget extends StatefulWidget {
  const AdicionarPontoWidget({Key? key}) : super(key: key);

  @override
  _AdicionarPontoWidgetState createState() => _AdicionarPontoWidgetState();
}

class _AdicionarPontoWidgetState extends State<AdicionarPontoWidget> {
  File? image;
  String? base64Image;
  late UserModel user;
  var dio = Dio();

  final myController = TextEditingController();

  var myString;
  bool _value = false;

  @override
  void initState() {
    super.initState();
  }

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(
          source: source, imageQuality: 70, maxHeight: 900.0, maxWidth: 900.0);
      if (image == null) return;
      final imageTemporary = File(image.path);

      setState(() => this.image = imageTemporary);
    } on PlatformException catch (e) {
      print("Failed to pick image: $e");
    }
  }

  Future<void> fetchPostComprovante() async {
    final prefs = await SharedPreferences.getInstance();
    myString = prefs.getString('idUser') ?? '';
    final String dateFormater =
        DateFormat('dd-MM-yyyy H:m:s').format(DateTime.now());

    final String dateTime = myController.text == "" ? dateFormater : "";
    final String dateTile = myController.text == "" ? "" : myController.text;
    print(dateTime);
    print(dateTile);

    try {
      String fileName = image!.path.split('/').last;
      var data = new FormData.fromMap({
        "idUser": myString,
        "dateTime": dateTime,
        "dateTile": dateTile,
        "comprovante": await MultipartFile.fromFile(image!.path,
            filename: fileName, contentType: MediaType('image', 'jpg')),
      });
      final response = await dio.post(
        'https://comprovante-ponto.herokuapp.com/pontos',
        data: data,
        options: Options(
            followRedirects: false,
            validateStatus: (status) => true,
            headers: {'accept': "*/*", 'Content-Type': 'multipart/form-data'}),
      );
      ScaffoldMessenger.of(context).clearSnackBars();
      return response.data;
    } on DioError catch (e) {
      print("Erro Dio :" + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 25),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.75,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              right: 16,
              child: GestureDetector(
                onTap: () => ScaffoldMessenger.of(context).clearSnackBars(),
                child: Icon(Icons.close_rounded),
              ),
            ),
            image != null
                ? Padding(
                    padding:
                        const EdgeInsets.only(top: 36.0, left: 16, right: 16),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.0),
                        child: Image.file(image!)),
                  )
                : Center(
                    child: Text(
                    'Tire uma foto',
                    style: TextStyles.titleRegularBlack,
                  )),
            Positioned(
              bottom: 6,
              right: 16,
              left: 16,
              child: image == null
                  ? SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width - 32,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Color(0xff022244)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                          ),
                        ),
                        onPressed: () {
                          pickImage(ImageSource.camera);
                        },
                        child: Text(
                          'Fotografar',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  : Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: _value,
                                onChanged: (value) {
                                  setState(() {
                                    _value = value!;
                                    if (value == false) {
                                      myController.clear();
                                    }
                                  });
                                },
                              ),
                              Text(
                                "Adicionar uma data diferente",
                                style: TextStyles.titleRegularBlack,
                              )
                            ],
                          ),
                          Visibility(
                            visible: _value,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 1),
                              child: TextField(
                                controller: myController,
                                keyboardType: TextInputType.datetime,
                                decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black45)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xff022244))),
                                    hintText: 'Ex. "01-01-2022 13:00"',
                                    labelText: 'Ex. "01-01-2022 13:00"',
                                    labelStyle: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff022244),
                                    )),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                child: Icon(
                                  Icons.close_rounded,
                                  size: 30,
                                ),
                                onTap: () {
                                  pickImage(ImageSource.camera);
                                },
                              ),
                              GestureDetector(
                                child: Icon(
                                  Icons.check_rounded,
                                  size: 30,
                                ),
                                onTap: () {
                                  fetchPostComprovante();
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
