import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uchiha_saving/models/article.dart';
import 'package:uchiha_saving/models/person.dart';
import 'package:uchiha_saving/pages/articles_page/articles_page_bloc.dart';
import 'package:uchiha_saving/pages/articles_page/components/articles_page_appbar.dart';
import 'package:uchiha_saving/tools/custom_navigator.dart';
import 'package:uchiha_saving/uis/article_detail_ui/article_detail_ui.dart';

class ArticlesPage extends StatelessWidget {
  final Person person;
  ArticlesPage({Key? key, required this.person}) : super(key: key);

  ArticlesPageBloc _bloc = ArticlesPageBloc();
  @override
  Widget build(BuildContext context) {
    _bloc.add();
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        body: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            ArticlesPageAppBar(person: person, key: key),
            StreamBuilder<List<Article>>(
                stream: _bloc.stream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.2,
                            ),
                            LinearProgressIndicator(
                              backgroundColor: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return SliverList(
                    delegate: SliverChildBuilderDelegate((context, i) {
                      final item = snapshot.data![i];

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 7,
                          child: ListTile(
                            onTap: () {
                              customNavigator(
                                  context,
                                  ArticleDetailUI(
                                    article: snapshot.data![i],
                                    person: person,
                                  ));
                            },
                            contentPadding: EdgeInsets.all(14),
                            isThreeLine: true,
                            title: Column(
                              children: [
                                Text(
                                  item.title,
                                  style: GoogleFonts.lato(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(30),
                                      child: Image.network(item.image)),
                                ),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Text(
                                      "~ " + item.author,
                                      textAlign: TextAlign.end,
                                      style: GoogleFonts.lato(
                                        fontWeight: FontWeight.w900,
                                        fontSize:
                                            MediaQuery.of(context).size.height *
                                                0.022,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          StreamBuilder<DocumentSnapshot>(
                                              stream: FirebaseFirestore.instance
                                                  .collection('Articles')
                                                  .doc(person.id)
                                                  .collection('Articles')
                                                  .doc(item.title)
                                                  .snapshots(),
                                              builder: (context, snapshot) {
                                                if (!snapshot.hasData) {
                                                  return Icon(Icons.save_alt);
                                                }

                                                return IconButton(
                                                    icon: Icon(
                                                      snapshot.data!.exists
                                                          ? Icons.bookmark
                                                          : Icons
                                                              .bookmark_add_rounded,
                                                      size:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.035,
                                                    ),
                                                    onPressed: () {
                                                      snapshot.data!.exists
                                                          ? FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'Articles')
                                                              .doc(person.id)
                                                              .collection(
                                                                  'Articles')
                                                              .doc(item.title
                                                                  .replaceAll(
                                                                      new RegExp(
                                                                          r'[^\w\s]+'),
                                                                      "")
                                                                  .split(' ')
                                                                  .join(''))
                                                              .delete()
                                                              .then((value) {
                                                              Fluttertoast
                                                                  .showToast(
                                                                      msg:
                                                                          "Article has been unsaved.");
                                                            })
                                                          : FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'Articles')
                                                              .doc(person.id)
                                                              .collection(
                                                                  'Articles')
                                                              .doc(item.title
                                                                  .replaceAll(
                                                                      new RegExp(
                                                                          r'[^\w\s]+'),
                                                                      "")
                                                                  .split(' ')
                                                                  .join(''))
                                                              .set(item.toMap())
                                                              .then((value) {
                                                              Fluttertoast
                                                                  .showToast(
                                                                      msg:
                                                                          "Article has been saved.");
                                                            });
                                                    });
                                              }),
                                          IconButton(
                                              icon: Icon(
                                                Icons.share,
                                                size: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.035,
                                              ),
                                              onPressed: () {}),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }, childCount: snapshot.data!.length),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
