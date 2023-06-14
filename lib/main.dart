import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Article {
  final int id;
  final String title;
  final String content;

  Article({required this.id, required this.title, required this.content});

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      content: json['description'] ?? '',
    );
  }
}

class ArticleListScreen extends StatefulWidget {
  @override
  _ArticleListScreenState createState() => _ArticleListScreenState();
}

class _ArticleListScreenState extends State<ArticleListScreen> {
  List<Article> articles = [];

  @override
  void initState() {
    super.initState();
    fetchArticles();
  }

  Future<void> fetchArticles() async {
    try {
      final response =
          await http.get(Uri.parse("http://10.8.100.66:3000/articles"));
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        print(jsonData);
        List<Article> fetchedArticles = [];
        for (var articleJson in jsonData) {
          print(articleJson);
          Article article = Article.fromJson(articleJson);
          fetchedArticles.add(article);
        }
        setState(() {
          articles = fetchedArticles;
        });
      } else {
        print('Failed to fetch articles. Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred while fetching articles: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Article List'),
      ),
      body: ListView.builder(
        itemCount: articles.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(articles[index].title),
            subtitle: Text(articles[index].content),
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ArticleListScreen(),
  ));
}
