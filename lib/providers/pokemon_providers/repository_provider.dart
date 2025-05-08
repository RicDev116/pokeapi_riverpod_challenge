import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokeapi_app/repositories/dio_pokemon_respository.dart';
import '../../repositories/pokemon_repository.dart';


// Provider for the PokemonRepository
// This provider creates an instance of the DioPokemonRepository and 
// makes it available for dependency injection.
final pokemonRepositoryProvider = Provider<PokemonRepository>((ref) {
  return DioPokemonRepository();
});