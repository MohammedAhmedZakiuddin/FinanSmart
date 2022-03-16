import 'dart:async';

import 'package:uchiha_saving/api/article_fetcher.dart';
import 'package:uchiha_saving/models/article.dart';

class ArticlesPageBloc {
  StreamController<List<Article>> controller =
      StreamController<List<Article>>.broadcast();

  Stream<List<Article>> get stream => controller.stream.asBroadcastStream();

  dispose() => controller.close();

  ArticleFetcher scrapper = ArticleFetcher();

  add() async {
    List<Article> items = await scrapper.fetchArtilces();
    controller.sink.add(items);
  }
}
