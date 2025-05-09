import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokeapi_app/models/pokemon_model.dart';
import 'package:pokeapi_app/pages/pokeapi/detail_pokemon_page/detail_pokemon_page.dart';
import 'package:pokeapi_app/providers/pokemon_providers/repository_provider.dart';
import 'package:pokeapi_app/repositories/pokemon_repository.dart';

class TestHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (cert, host, port) => true;
  }
}

class FakePokemonRepository implements PokemonRepository {
  @override
  Future<List<PokemonModel>> fetchPokemonList({int offset = 0, int limit = 20}) async {
    return [];
  }

  @override
  Future<String> fetchPokemonDescription(int id) async {
    if (id == 1) {
      return 'Bulbasaur is a Grass/Poison type Pokémon.';
    } else {
      throw Exception('Failed to fetch description');
    }
  }
}

void main() {
  late FakePokemonRepository fakeRepository;

  setUpAll(() {
    HttpOverrides.global = TestHttpOverrides();
  });

  setUp(() {
    fakeRepository = FakePokemonRepository();
  });

  testWidgets('Shows loading indicator while fetching description', (WidgetTester tester) async {
  // Arrange
  final pokemon = PokemonModel(
    name: 'Bulbasaur',
    imageUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png',
    number: 1,
    types: ['Grass', 'Poison'],
  );

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        pokemonRepositoryProvider.overrideWithValue(fakeRepository),
      ],
      child: MaterialApp(
        home: DetailPokemonPage(pokemon: pokemon),
      ),
    ),
  );

  // Assert
  expect(find.byType(CircularProgressIndicator), findsOneWidget);
});

  testWidgets('Displays description when data is loaded', (WidgetTester tester) async {
    // Arrange
    final pokemon = PokemonModel(
      name: 'Bulbasaur',
      imageUrl: 'https://example.com/bulbasaur.png',
      number: 1,
      types: ['Grass', 'Poison'],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          pokemonRepositoryProvider.overrideWithValue(fakeRepository),
        ],
        child: MaterialApp(
          home: DetailPokemonPage(pokemon: pokemon),
        ),
      ),
    );

    // Wait for the Future to complete
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('Bulbasaur is a Grass/Poison type Pokémon.'), findsOneWidget);
  });

  testWidgets('Displays error message when fetching description fails', (WidgetTester tester) async {
    // Arrange
    final pokemon = PokemonModel(
      name: 'Charmander',
      imageUrl: 'https://example.com/charmander.png',
      number: 2,
      types: ['Fire'],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          pokemonRepositoryProvider.overrideWithValue(fakeRepository),
        ],
        child: MaterialApp(
          home: DetailPokemonPage(pokemon: pokemon),
        ),
      ),
    );

    // Wait for the Future to complete
    await tester.pumpAndSettle();

    // Assert
    expect(find.textContaining('Error'), findsOneWidget);
  });
}