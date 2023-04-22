

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PokemonDetails extends StatelessWidget {
  const PokemonDetails({Key? key, required this.index,}) : super(key: key);

  final int index;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: Navigator.of(context).pop,
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              title: Hero(
                child: Material(
                  child: Text(
                    "Item widget $index",
                  ),
                  type: MaterialType.transparency,
                ),
                tag: "title_$index",
              ),
            ),
          ),
          Positioned.fill(
            top: kToolbarHeight,
            child: Hero(
              tag: "image_$index",
              child: CachedNetworkImage(
                  height: 700,
                  width: 700,
                  fit: BoxFit.contain,
                  imageUrl:"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${index+1}.png"),
            ),
          ),
        ],
      ),
    );
  }
}
