import 'package:flutter/material.dart';

class DetailPokemonPage extends StatelessWidget {
  final String pokemonName;
  const DetailPokemonPage({
    required this.pokemonName, 
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pokemonName),
      ),
      body: Center(
        child: Text('Details for $pokemonName'),
      ),
    );
  }
}