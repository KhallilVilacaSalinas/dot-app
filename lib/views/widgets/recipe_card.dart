import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ponto_prevent/themes/app_text_styles.dart';

class RecipeCard extends StatefulWidget {
  final String date;
  final String image;
  final String idComprovante;
  RecipeCard({
    required this.date,
    required this.image,
    required this.idComprovante,
  });

  @override
  State<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  bool loading = false;
  var dio = Dio();

  Future<void> deleteComprovante() async {
    final response = await dio.delete(
        'https://comprovante-ponto.herokuapp.com/pontos/${widget.idComprovante}');
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to load album');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16))),
              contentPadding: EdgeInsets.all(16),
              title: Text(
                'Comprovante',
                style: TextStyles.titleBoldHeading,
                textAlign: TextAlign.center,
              ),
              content: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: Image.network(
                        widget.image,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(child: CircularProgressIndicator());
                          // You can use LinearProgressIndicator or CircularProgressIndicator instead
                        },
                        errorBuilder: (context, error, stackTrace) =>
                            Text('Some errors occurred!'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 22, vertical: 7),
        width: MediaQuery.of(context).size.width,
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.6),
              offset: Offset(
                1.0,
                1.0,
              ),
              blurRadius: 8.0,
              spreadRadius: -6.0,
            ),
          ],
        ),
        child: Stack(
          children: [
            Align(
              child: Padding(
                padding: EdgeInsets.only(left: 16),
                child: Container(
                  margin: EdgeInsets.only(
                    top: 16,
                    bottom: 16,
                  ),
                  child: Text(
                    widget.date,
                    style: TextStyles.titleListRegular,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              alignment: Alignment.centerLeft,
            ),
            Align(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CupertinoAlertDialog(
                            title: Text("Confirme para deletar!"),
                            actions: [
                              CupertinoButton(
                                  child: Text('Cancelar'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  }),
                              CupertinoButton(
                                child: Text('Confirmar'),
                                onPressed: () async {
                                  await deleteComprovante();
                                  Navigator.of(context).pop();
                                },
                              )
                            ],
                          );
                        },
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.all(11),
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete,
                            color: Colors.red[400],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              alignment: Alignment.centerRight,
            ),
          ],
        ),
      ),
    );
  }
}
