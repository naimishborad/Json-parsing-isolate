import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      
      home: home()
    );
  }
}

class home extends StatefulWidget {
  home({Key? key}) : super(key: key);

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Photo>>(
        future: fetchPhoto(http.Client()),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if(snapshot.hasError){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          else if(snapshot.hasData){
            return PhotoList(photos: snapshot.data,);
          }
          else{
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

class PhotoList extends StatelessWidget {
  final List<Photo> photos;
  const PhotoList({Key? key, required this.photos}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: photos.length,
      itemBuilder: (BuildContext context, int index) {
        return Image.network(photos[index].thumbnailUrl);
      },
    );
  }
}

Future<List<Photo>> fetchPhoto(http.Client client)async{
  final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/photos'));
  return compute(parsePhotos,response.body);
}

List<Photo> parsePhotos(String responseBody){
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Photo>((json) => Photo.fromJson(json)).toList();  
}


class Photo{
  final int albumId;
  final int id;
  final String title;
  final String url;
  final String thumbnailUrl;

  Photo({required this.albumId, required this.id, required this.title, required this.url, required this.thumbnailUrl,});

  factory Photo.fromJson(Map<String,dynamic> json){
    return Photo(
      albumId: json['albumId'] as int,
      id: json['id'] as int,
      title: json['title'] as String,
      url: json['url'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String

      );
  }

}