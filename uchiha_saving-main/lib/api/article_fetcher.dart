import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:html/parser.dart';
import 'package:uchiha_saving/models/article.dart';
import 'package:uchiha_saving/models/article_detail.dart';

class ArticleFetcher {
  Future<Map<String, dynamic>> fetchQuote() async {
    final url = Uri.parse(
        "https://www.forbes.com/sites/robertberger/2014/04/30/top-100-money-quotes-of-all-time");
    final response = await http.get(url);
    final document = parse(response.body);

    int i = Random().nextInt(document.querySelectorAll('ol > li').length);

    Map<String, dynamic> data = {
      "author": document
          .querySelectorAll('ol > li')[i]
          .text
          .trim()
          .split("--")[1]
          .trim(),
      "quote": document
          .querySelectorAll('ol > li')[i]
          .text
          .trim()
          .split("--")[0]
          .trim(),
    };

    return data;
  }

  Future<List<Article>> fetchArtilces() async {
    var response = await http.get(Uri.parse("https://www.lifehack.org/money"));

    final document = parse(response.body);

    return document
        .querySelectorAll('div.col-lg-3.col-sm-6')
        .map((element) => Article(
              link:
                  element.querySelector('a.article-photo')!.attributes['href']!,
              image: element
                  .querySelector('a.article-photo > img')!
                  .attributes['data-lazy-src']!,
              title:
                  element.querySelector('div.article-card-body > h6 > a')!.text,
              author: element.querySelector('div.article-author > a')!.text,
            ))
        .toList();
  }

  Future<ArticleDetail> fetchArticleDetail({required String link}) async {
    final response = await http.get(Uri.parse(link));
    final document = parse(response.body);

    return ArticleDetail(
        detail: document
            .querySelectorAll('div.article-content > p')
            .map((e) => e.text)
            .toList());
  }
}
