import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokeapi_app/models/pokemon_model.dart';
import 'package:pokeapi_app/repositories/pokemon_repository.dart';

// Notifier class for managing the state of the Pokemon list
// This class extends StateNotifier and manages the state of the Pokemon list using AsyncValue.
// It fetches the list of Pokemon from the repository and updates the state accordingly.

class PokemonNotifier extends StateNotifier<AsyncValue<List<PokemonModel>>> {
  final PokemonRepository repository;
  int _offset = 0;
  final int _limit = 20;
  bool _isFetching = false;

  PokemonNotifier(this.repository) : super(const AsyncValue.loading()) {
    fetchPokemonList();
  }

  Future<void> fetchPokemonList({bool loadMore = false}) async {
    if (_isFetching) return;
    _isFetching = true;

    try {
      final previous = state.value ?? [];
      final newList = await repository.fetchPokemonList(offset: _offset, limit: _limit);

      _offset += _limit;

      final combinedList = loadMore ? [...previous, ...newList] : newList;

      state = AsyncValue.data(combinedList);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    } finally {
      _isFetching = false;
    }
  }

  Future<void> fetchPokemonDescription(int id) async {
    try {
      final currentList = state.value ?? [];
      final description = await repository.fetchPokemonDescription(id);

      // Update the description of the specific Pokémon
      final updatedList = currentList.map((pokemon) {
        if (pokemon.number == id) {
          return pokemon.copyWith(description: description);
        }
        return pokemon;
      }).toList();

      state = AsyncValue.data(updatedList);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
