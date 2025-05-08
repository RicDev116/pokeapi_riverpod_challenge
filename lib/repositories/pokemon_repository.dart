
// This is an abstract class that defines the contract for a Pokemon repository.
// It can be implemented by different classes to fetch Pokemon data from various sources.
import 'package:pokeapi_app/models/pokemon_model.dart';

abstract class PokemonRepository {
  Future<List<PokemonModel>> fetchPokemonList(
      {int offset = 0, int limit = 20}
  );

  Future<String> fetchPokemonDescription(int id);
}