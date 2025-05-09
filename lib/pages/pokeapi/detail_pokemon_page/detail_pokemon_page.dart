import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokeapi_app/models/pokemon_model.dart';
import 'package:pokeapi_app/providers/pokemon_providers/pokemon_description_provider.dart';
import 'package:pokeapi_app/utils/get_type_colors.dart';

class DetailPokemonPage extends ConsumerWidget {
  final PokemonModel pokemon;

  const DetailPokemonPage({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bgColor = getTypeColor(pokemon.types.first);

    // Usar el FutureProvider para obtener la descripción
    final descriptionAsyncValue = ref.watch(pokemonDescriptionProvider(pokemon.number));

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: Colors.white),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.favorite_border, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        children: [
          Hero(
            tag: pokemon.imageUrl,
            child:
            //This Widget need to be replaced for MockNetworkImage when testing 
            Image.network(
              pokemon.imageUrl, 
              height: 180,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.error, size: 180); // Muestra un ícono de error si falla la carga
              },
            ),
            //  MockNetworkImage(height: 20),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Header(pokemon: pokemon),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: pokemon.types.map((type) {
                        return Chip(
                          label: Text(type),
                          backgroundColor: getTypeColor(type).withOpacity(0.2),
                          labelStyle: TextStyle(color: getTypeColor(type)),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    //description
                    descriptionAsyncValue.when(
                      data: (description) => Text(
                        description,
                        style: const TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (error, _) => Text(
                        'Error: $error',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // StateCards
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _StatCard(title: "Weight", value: "${pokemon.weight} kg"),
                        _StatCard(title: "Height", value: "${pokemon.height} m"),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _StatCard(title: "Category", value: pokemon.category ?? 'N/A'),
                        _StatCard(title: "Ability", value: pokemon.ability ?? 'N/A'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    super.key,
    required this.pokemon,
  });

  final PokemonModel pokemon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          pokemon.name,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        Text(
          '#${pokemon.number.toString().padLeft(3, '0')}',
          style: const TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;

  const _StatCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(title, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class MockNetworkImage extends StatelessWidget {
  final double height;

  const MockNetworkImage({required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      color: Colors.grey,
    );
  }
}