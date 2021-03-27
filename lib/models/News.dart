import 'dart:convert';

import 'Article.dart';
import 'package:http/http.dart' as http;

class News {

  List<Article> articles=[];

  Future<void> getNews()  async{

   var url=Uri.parse("https://newsapi.org/v2/top-headlines?country=in&apiKey=570c273afcd64c548822b19634387d92");

    var response = await http.get(url);

    var jsonData=jsonDecode(response.body);
    if(jsonData['status']=="ok"){
      jsonData["articles"].forEach((element){
        if(element["urlToImage"] != null &&element['description']!=null){
          Article artcle=Article(
            title:element["title"],
            author:element["author"],
            urlToImage:element["urlToImage"],
            description:element["description"],
            url: element["url"],
            content:element["content"],
          );

          articles.add(artcle);
        }
      });
    }
  }

}