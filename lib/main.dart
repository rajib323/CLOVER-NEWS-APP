import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/models/Article.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'models/News.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
      ),
      home: Home_Page(),
    );
  }
}

class Home_Page extends StatefulWidget {
  @override
  _Home_PageState createState() => _Home_PageState();
}

class _Home_PageState extends State<Home_Page> {
  List<Article> newss=[];
  bool loading_State=false;

  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    getArticle();
  }
  getArticle() async{
    News newsClass=News();
    await newsClass.getNews();
    newss = newsClass.articles;
    setState(() {
      loading_State=true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Center(child: Text("C L O V E R",style: TextStyle(color: Colors.red[900],fontSize: 25,fontWeight: FontWeight.w800),)),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Stack(
          children: [

            loading_State?Column(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: ListView.builder(
                        itemBuilder: (BuildContext context, int index){
                          return GestureDetector(
                            onTap:(){
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ArticleView(ns: newss[index])));
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal:8.0,vertical: 8.0),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [BoxShadow(color: Colors.grey,offset: Offset.zero,blurRadius: 15,spreadRadius: 1)],
                                  borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(height: 10,),
                                      ClipRRect(child: Image.network(newss[index].urlToImage,fit: BoxFit.cover,height: 200,),borderRadius: BorderRadius.circular(10),),
                                      SizedBox(height: 15,),
                                      Text(newss[index].title,style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,),),
                                      SizedBox(height: 8,),
                                      Text(newss[index].description,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15),),
                                      SizedBox(height: 10,),
                                    ],
                                  ),
                              ),
                            ),
                          );
                        },
                        itemCount: newss.length),
                  ),
                ),
            ]):Center(child: CircularProgressIndicator(),),

            Positioned(
              bottom: 10,
              left: 0,
              child: Container(
                height: 60,
                width: 360,
                padding: EdgeInsets.symmetric(horizontal: 5),
                color: Colors.transparent,
                child: Container(
                    height: 60,
                    padding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [BoxShadow(color: Colors.blueGrey,offset: Offset.zero,blurRadius: 25,spreadRadius: 2)],
                    ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(CupertinoIcons.search),
                          SizedBox(width: 5,),
                          Text("Search",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),
                        ],
                      ),
                      Row(
                        children: [
                          Text("Sort",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),
                          SizedBox(width: 5,),
                          Icon(Icons.sort_sharp),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

        ]),
      ),
    );
  }
}



class ArticleView extends StatefulWidget {
  final Article ns;

  ArticleView({this.ns});

  @override
  _ArticleViewState createState() => _ArticleViewState();
}

class _ArticleViewState extends State<ArticleView> {

  final Completer<WebViewController> completer=Completer<WebViewController>();
  
  @override
  Widget build(BuildContext context) {
    print('${widget.ns.url}');
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text("C L O V E R",style: TextStyle(color: Colors.red[900],fontWeight: FontWeight.w900),),
        centerTitle: true,
        actions: [
          Icon(Icons.save,color: Colors.transparent,),
        ],
      ),
      body:Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: WebView(
          initialUrl: widget.ns.url,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: ((WebViewController webviewController){
            completer.complete(webviewController);
          }),
        ),
      )
    );
  }
}
