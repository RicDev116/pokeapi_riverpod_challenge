import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:pokeapi_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Navigate to detail page and load description', (WidgetTester tester) async {
    // Arrange: init the application
    app.main();
    await tester.pumpAndSettle();//ensure the app is fully loaded

    // Act: find the first Pokémon in the list and tap on it
    final firstPokemonFinder = find.text('Bulbasaur'); // assuming Bulbasaur is the first Pokémon
    expect(firstPokemonFinder, findsOneWidget);

    await tester.tap(firstPokemonFinder);
    await tester.pumpAndSettle();

    // Assert: verify that we are on the detail page and shows it correctly
    expect(find.text('Bulbasaur'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Wait for the description to load
    await tester.pumpAndSettle();

    // Assert: verify that the description is displayed
    expect(find.textContaining('is a Grass/Poison type Pokémon'), findsOneWidget);
  });
}