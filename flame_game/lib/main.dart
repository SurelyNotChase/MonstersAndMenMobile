import './AboutGame.dart';
import 'PlayGame.dart';

import 'CardReference.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';


void main() {
  print('load the game widgets');
  runApp(MyGameApp());
}

class MyGameApp extends StatefulWidget {
  const MyGameApp({super.key});

  @override
  State<MyGameApp> createState() => _MyGameAppState();
}

class _MyGameAppState extends State<MyGameApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bible App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'FrizQuadrata'
      ),
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Reference', icon: Icon(Icons.info_outlined)),
                Tab(text: 'Play', icon: Icon(Icons.table_restaurant_rounded)),
                Tab(text: 'About', icon: Icon(Icons.menu_book)),
              ],
            ),
            title: Text("Monsters & Men Card Game"),
          ),
          body: TabBarView(
            children: [
              referencePage(),
              GameWidget(game: PlayGame()),
                GameWidget(game: AboutGame()),
            ],
          ),
        ),
      ),
    );
  }
}


