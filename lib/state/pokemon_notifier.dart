import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokeapi_app/repositories/pokemon_repository.dart';

// Notifier class for managing the state of the Pokemon list
// This class extends StateNotifier and manages the state of the Pokemon list using AsyncValue.
// It fetches the list of Pokemon from the repository and updates the state accordingly.

class PokemonNotifier extends StateNotifier<AsyncValue<List<String>>> {

  final PokemonRepository repository;

  PokemonNotifier(this.repository) : super(const AsyncValue.loading());

  Future<void> fetchPokemonList() async {
    
    try {
      state = const AsyncValue.loading();
      final pokemonList = await repository.fetchPokemonList();
      state = AsyncValue.data(pokemonList);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}