import 'package:dio/dio.dart';
import 'package:pokeapi_app/models/pokemon_model.dart';
import 'pokemon_repository.dart';
/// This class implements the PokemonRepository interface using Dio for network requests.
/// It fetches a list of Pokemon names from the PokeAPI.
class DioPokemonRepository implements PokemonRepository {
  final Dio _dio = Dio();

  DioPokemonRepository();

  @override
  Future<List<PokemonModel>> fetchPokemonList({int offset = 0, int limit = 20}) async {
    try {
      final response = await _dio.get('https://pokeapi.co/api/v2/pokemon?limit=$limit&offset=$offset');
      
      if (response.statusCode == 200) {
        final results = response.data['results'] as List;

        final pokemons = await Future.wait(results.map((item) async {
          final detailResponse = await _dio.get(item['url']);
          return PokemonModel.fromJson(detailResponse.data);
        }));

        return pokemons;
      } else {
        throw Exception('Failed to load Pokemon list: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch Pokemon list: $e');
    }
  }
  
  @override
  Future<String> fetchPokemonDescription(int id) async {
    final url = 'https://pokeapi.co/api/v2/pokemon-species/$id';
    final response = await _dio.get(url);

    if (response.statusCode == 200) {
      final data = response.data;
      final flavorTextEntries = data['flavor_text_entries'] as List;

      // Filtrar la descripción en inglés
      final englishEntry = flavorTextEntries.firstWhere(
        (entry) => entry['language']['name'] == 'en',
        orElse: () => null,
      );

      return englishEntry != null
          ? (englishEntry['flavor_text'] as String).replaceAll('\n', ' ').replaceAll('\f', ' ')
          : 'No description available.';
    } else {
      throw Exception('Failed to load Pokémon description');
    }
  }
}
