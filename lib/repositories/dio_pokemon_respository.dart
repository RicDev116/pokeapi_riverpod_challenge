import 'package:dio/dio.dart';
import 'pokemon_repository.dart';
/// This class implements the PokemonRepository interface using Dio for network requests.
/// It fetches a list of Pokemon names from the PokeAPI.
class DioPokemonRepository implements PokemonRepository {

  final Dio _dio = Dio();

  DioPokemonRepository();

  @override
  Future<List<String>> fetchPokemonList() async {
    try {
      final response = await _dio.get('https://pokeapi.co/api/v2/pokemon?limit=50&offset=0');
      final results = response.data['results'] as List;
      return results.map((pokemon) => pokemon['name'] as String).toList();
    } catch (e) {
      throw Exception('Failed to fetch Pokemon list: $e');
    }
  }
}