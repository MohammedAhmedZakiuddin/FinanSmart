import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uchiha_saving/api/article_fetcher.dart';
import 'package:uchiha_saving/models/article.dart';
import 'package:uchiha_saving/models/article_detail.dart';
import 'package:uchiha_saving/models/person.dart';

class ArticleDetailUI extends StatefulWidget {
  final Article article;
  final Person person;
  ArticleDetailUI({required this.article, required this.person});
  @override
  _ArticleDetailUIState createState() => _ArticleDetailUIState();
}

class _ArticleDetailUIState extends State<ArticleDetailUI> {
  final _key = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final _ref = FirebaseFirestore.instance
        .collection('Articles')
        .doc(widget.person.id)
        .collection('Articles')
        .doc(widget.article.title
            .replaceAll(new RegExp(r'[^\w\s]+'), "")
            .split(' ')
            .join(''));
    return Scaffold(
      key: _key,
      floatingActionButton: StreamBuilder<DocumentSnapshot>(
          stream: _ref.snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center();
            }
            return FloatingActionButton(
              backgroundColor: Colors.white70,
              onPressed: () {
                snapshot.data!.exists
                    ? _ref.delete().then((value) {
                        Fluttertoast.showToast(
                            msg: "Article has been unsaved successfully.");
                      })
                    : _ref.set(widget.article.toMap()).then((value) {
                        Fluttertoast.showToast(
                            msg: "Article has been saved successfully.");
                      });
              },
              child: Icon(
                snapshot.data!.exists
                    ? Icons.bookmark
                    : Icons.bookmark_add_rounded,
                color: Colors.black87,
                size: 30,
              ),
            );
          }),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            expandedHeight: MediaQuery.of(context).size.height * 0.4,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                widget.article.image,
                fit: BoxFit.cover,
              ),
              title: Text(
                widget.article.title,
                maxLines: 1,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Text(
              widget.article.title,
              textAlign: TextAlign.center,
              style: GoogleFonts.lato(
                fontSize: MediaQuery.of(context).size.height * 0.028,
              ),
            ),
          ),
          FutureBuilder<ArticleDetail>(
              future: ArticleFetcher()
                  .fetchArticleDetail(link: widget.article.link),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                return SliverToBoxAdapter(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: snapshot.data!.detail
                            .map((e) => Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    e,
                                    style: GoogleFonts.lato(fontSize: 18),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                ));
              })
        ],
      ),
    );
  }
}
