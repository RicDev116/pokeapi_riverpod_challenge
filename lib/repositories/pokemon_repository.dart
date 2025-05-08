
// This is an abstract class that defines the contract for a Pokemon repository.
// It can be implemented by different classes to fetch Pokemon data from various sources.
abstract class PokemonRepository {
  Future<List<String>> fetchPokemonList();
}