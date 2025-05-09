# pokeapi_app






## Running Tests in `DetailPokemonPage`

### Changes Required for Testing

Since `Image.network` attempts to make real network requests during tests, it is necessary to temporarily replace it with a simulated widget (`MockNetworkImage`) to avoid errors related to blocked network requests.

#### Original Code (Production)
```dart
Hero(
  tag: pokemon.imageUrl,
  child: Image.network(
    pokemon.imageUrl,
    height: 180,
    errorBuilder: (context, error, stackTrace) {
      return const Icon(Icons.error, size: 180); // Displays an error icon if the image fails to load
    },
  ),
),