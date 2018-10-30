import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

Future<List<String>> fetchTrending() async {
  final response = await http.get(
      "https://api.giphy.com/v1/gifs/trending?api_key=S2caek9KgSdfHo7OqPQwdV9POlLEgSs1&limit=25&rating=G");
  final parsed = json.decode(response.body);
  final List<Map<String, dynamic>> images =
      parsed["data"].cast<Map<String, dynamic>>();
  return images.map<String>((image) {
    return image["images"]["preview_gif"]["url"];
  }).toList();
}

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Giphy Random Feed',
      theme: ThemeData.dark(),
      home: Giphyimages(),
    );
  }
}

class Giphyimages extends StatefulWidget {
  @override
  _GiphyimagesState createState() => _GiphyimagesState();
}

class _GiphyimagesState extends State<Giphyimages> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Giphy Random Feed'),
      ),
      body: FutureBuilder(
        future: fetchTrending(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 4.0,
                  crossAxisSpacing: 4.0,
                  childAspectRatio: 1.0,
                ),
                padding: const EdgeInsets.all(4.0),
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return GridTile(
                      child: new Image.network(snapshot.data[index],
                          fit: BoxFit.cover));
                });
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
