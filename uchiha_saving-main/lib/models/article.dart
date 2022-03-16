import 'package:cloud_firestore/cloud_firestore.dart';

class Article {
  final String title, link, author, image;

  Article(
      {required this.title,
      required this.link,
      required this.author,
      required this.image});

  Map<String, dynamic> toMap() =>
      {"title": title, "link": link, "author": author, "image": image};

  factory Article.fromDocumentSnapshot(DocumentSnapshot doc) => Article(
      author: doc['author'],
      image: doc['image'],
      link: doc['link'],
      title: doc['title']);

  factory Article.fromMap(Map<String, dynamic> doc) => Article(
      author: doc['author'],
      image: doc['image'],
      link: doc['link'],
      title: doc['title']);
}
