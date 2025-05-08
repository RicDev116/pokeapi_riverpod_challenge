import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokeapi_app/pages/pokeapi/list_pokemon_page/list_pokemon_page.dart';
import 'package:pokeapi_app/providers/pokemon_providers/pokemon_provider.dart';
import 'package:pokeapi_app/repositories/dio_pokemon_respository.dart';
import 'package:pokeapi_app/state/pokemon_notifier.dart';

void main() {
  final repository = DioPokemonRepository();
  runApp(
    ProviderScope(
      overrides: [
        pokemonProvider.overrideWith((ref) => PokemonNotifier(repository)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const ListPokemonPage(),
    );
  }
}
