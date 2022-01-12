import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ponto_prevent/models/ponto_model.dart';
import 'package:ponto_prevent/models/user_model.dart';
import 'package:ponto_prevent/themes/app_colors.dart';
import 'package:ponto_prevent/themes/app_text_styles.dart';
import 'package:ponto_prevent/views/widgets/recipe_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/adicionar_ponto_widget.dart';
import 'package:dio/dio.dart';

class HomePage extends StatefulWidget {
  final UserModel user;

  const HomePage({Key? key, required this.user}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<PontoModel>> futureAlbum;
  var dio = Dio();
  var pontos = <PontoModel>[];
  bool value = true;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchGetComprovante();
  }

  Future<List<PontoModel>> fetchGetComprovante() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('idUser', '${widget.user.id}');
    final response = await dio.get(
        'https://comprovante-ponto.herokuapp.com/pontos/${widget.user.id}');
    if (response.statusCode == 200) {
      final list = response.data['pontos'];
      return (list as List).map((json) => PontoModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load album');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(152),
        child: Container(
          height: 152,
          color: AppColors.primary,
          child: Center(
            child: ListTile(
              title: Text.rich(
                TextSpan(
                  text: "Olá, ",
                  style: TextStyles.titleRegular,
                  children: [
                    TextSpan(
                      text: "${widget.user.name}",
                      style: TextStyles.titleBoldBackground,
                    ),
                  ],
                ),
              ),
              subtitle: SizedBox(
                height: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Mantenha seus pontos em dia',
                      style: TextStyles.captionShape,
                    ),
                  ],
                ),
              ),
              trailing: Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(5),
                  image: DecorationImage(
                    image: NetworkImage(widget.user.photoURL!),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: FutureBuilder<List<PontoModel>>(
              future: futureAlbum,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: snapshot.data!
                        .map(
                          (e) => RecipeCard(
                            date: e.dateTime == "" ? e.dateTile : e.dateTime,
                            image: e.image,
                            idComprovante: e.sIdComprovante,
                          ),
                        )
                        .toList(),
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return Container(
                  height: MediaQuery.of(context).size.height - 152,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Visibility(
        visible: true,
        child: FloatingActionButton(
          backgroundColor: AppColors.aqua,
          onPressed: () {
            setState(() {
              value = false;
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: Duration(minutes: 10),
                content: AdicionarPontoWidget(),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30),
                  ),
                ),
              ),
            );
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  bool isVisible = true;
}
