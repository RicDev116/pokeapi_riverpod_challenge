import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokeapi_app/providers/pokemon_providers/repository_provider.dart';

final pokemonDescriptionProvider = FutureProvider.family<String, int>((ref, id) async {
  final repository = ref.watch(pokemonRepositoryProvider);
  return repository.fetchPokemonDescription(id);
});