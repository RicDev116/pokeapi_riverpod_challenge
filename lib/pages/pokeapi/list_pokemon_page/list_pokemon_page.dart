import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokeapi_app/pages/pokeapi/detail_pokemon_page/detail_pokemon_page.dart';
import 'package:pokeapi_app/providers/first_load_provider.dart';
import 'package:pokeapi_app/providers/pokemon_provider.dart';


class ListPokemonPage extends ConsumerWidget {
  const ListPokemonPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final isFirstLoad = ref.watch(isFirstLoadProvider);
    final pokemonState = ref.watch(pokemonProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('List Pokemon Page'),
      ),
      body: pokemonState.when(
        data: (pokemonList) => ListView.builder(
          itemCount: pokemonList.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(pokemonList[index]),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailPokemonPage(pokemonName: pokemonList[index]),
                  ),
                );
              },
            );
          },
        ),
        loading: (){
          if (isFirstLoad) {
            return const Center(child: Text('No more data'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(isFirstLoadProvider.notifier).state = false;
          ref.read(pokemonProvider.notifier).fetchPokemonList();
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}