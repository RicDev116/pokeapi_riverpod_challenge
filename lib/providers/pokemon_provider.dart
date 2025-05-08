import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokeapi_app/providers/repository_provider.dart';
import 'package:pokeapi_app/state/pokemon_notifier.dart';

// This provider creates an instance of the PokemonNotifier and injects the PokemonRepository into it.
// (StateNotifierProvider) connect pokemonNotifier to the UI, allowing the UI to react to changes in the Pokemon list state.
final pokemonProvider = StateNotifierProvider<PokemonNotifier, AsyncValue<List<String>>>((ref) {
  final repository = ref.watch(pokemonRepositoryProvider);
  return PokemonNotifier(repository);
});

