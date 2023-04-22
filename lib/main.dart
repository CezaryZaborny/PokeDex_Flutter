import 'dart:convert';

import 'package:asynch/page.dart';
import 'package:asynch/pokemon_model.dart';
import 'package:asynch/search.dart';
import 'package:asynch/youtube.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

late final Box<PokemonModel> pokemonsBox;

void main() async {
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(PokemonModelAdapter().typeId)) {
    Hive.registerAdapter(PokemonModelAdapter());
  }

  pokemonsBox = await Hive.openBox('pokemons');
  runApp(const MyApp());
  pokemonsBox.clear();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Połkemon',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Pokedex'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final future = Future.delayed(Duration(seconds: 3), () async {
    final uri =
        Uri.parse("https://pokeapi.co/api/v2/pokemon?limit=100000&offset=0");
    final response = await http.get(uri);
    return jsonDecode(response.body)["results"] as List;
  });

  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Youtube(),
      Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            IconButton(
              onPressed: () async {
                final pokemons = await future;
                final pokemonsModel =
                    pokemons.map((e) => PokemonModel(name: e["name"])).toList();
                pokemonsBox.addAll(pokemonsModel);
                setState(() {});
              },
              icon: Icon(Icons.catching_pokemon_sharp),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const Youtube(),
              )),
              child: const Icon(Icons.ac_unit),
            ),
          ],
        ),
        body: ListView.builder(
          itemCount: pokemonsBox.values.length,
          itemBuilder: (context, index) {
            final pokemon = pokemonsBox.values.toList()[index];

            return Dismissible(
              onDismissed: (direction) {
                pokemonsBox.deleteAt(index);
              },
              key: Key(pokemon.name),
              child: ListTile(
                onTap: () {
                  setState(
                    () {
                      if (selectedIndex == null) {
                        selectedIndex = index;
                      } else if (selectedIndex == index) {
                        selectedIndex = null;
                      } else if (selectedIndex != index) {
                        selectedIndex = index;
                      }
                    },
                  );
                  print(selectedIndex);
                },
                title: Text(pokemon.name),
                leading: AnimatedContainer(
                  duration: Duration(seconds: 2),
                  height: selectedIndex == index ? 200 : 100,
                  width: selectedIndex == index ? 200 : 100,
                  child: Hero(
                    tag: 'image_$index',
                    child: CachedNetworkImage(
                        width: 100,
                        height: 100,
                        imageUrl:
                            "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${index + 1}.png"),
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.loupe),
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => PokemonDetails(index: index),
                  )),
                ),
              ),
            );
          },
        ),
      ),
    ]);
  }
}
