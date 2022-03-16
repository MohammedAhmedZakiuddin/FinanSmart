import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:uchiha_saving/models/article.dart';
import 'package:uchiha_saving/models/person.dart';
import 'package:uchiha_saving/pages/articles_page/articles_page_bloc.dart';
import 'package:uchiha_saving/pages/articles_page/components/articles_page_appbar.dart';
import 'package:uchiha_saving/tools/custom_navigator.dart';
import 'package:uchiha_saving/uis/article_detail_ui/article_detail_ui.dart';

class BookmarksUI extends StatelessWidget {
  final Person person;
  BookmarksUI({Key? key, required this.person}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        body: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              title: Text(
                "Bookmarks",
                style: GoogleFonts.lato(),
              ),
              foregroundColor:
                  ThemeProvider.controllerOf(context).currentThemeId == "dark"
                      ? Colors.white
                      : Colors.black,
              backgroundColor: Colors.transparent,
              pinned: true,
            ),
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Articles')
                    .doc(person.id)
                    .collection('Articles')
                    .snapshots(),
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

                  List<Article> _list = snapshot.data!.docs
                      .map((e) => Article.fromDocumentSnapshot(e))
                      .toList();
                  return _list.isEmpty
                      ? SliverToBoxAdapter(
                          child: Center(
                            child: Column(
                              children: [
                                SizedBox(height: _size.height * 0.2),
                                Text(
                                  "Cannot find any saved articles\n\n😐😐😐",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.lato(
                                    fontSize: _size.height * 0.023,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : SliverList(
                          delegate: SliverChildBuilderDelegate((context, i) {
                            final item = _list[i];

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
                                          article: _list[i],
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
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            child: Image.network(item.image)),
                                      ),
                                    ],
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: <Widget>[
                                          Text(
                                            "~ " + item.author,
                                            textAlign: TextAlign.end,
                                            style: GoogleFonts.lato(
                                              fontWeight: FontWeight.w900,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.022,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                IconButton(
                                                    icon: Icon(
                                                      Icons.delete,
                                                      size:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.035,
                                                    ),
                                                    onPressed: () {
                                                      FirebaseFirestore.instance
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
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                "Article has been unsaved.");
                                                      });
                                                    }),
                                                IconButton(
                                                    icon: Icon(
                                                      Icons.share,
                                                      size:
                                                          MediaQuery.of(context)
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
                          }, childCount: _list.length),
                        );
                }),
          ],
        ),
      ),
    );
  }
}
