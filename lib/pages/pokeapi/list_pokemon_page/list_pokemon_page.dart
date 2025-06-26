import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokeapi_app/constants/strings.dart';
import 'package:pokeapi_app/models/pokemon_model.dart';
import 'package:pokeapi_app/pages/pokeapi/detail_pokemon_page/detail_pokemon_page.dart';
import 'package:pokeapi_app/providers/pokemon_providers/pokemon_provider.dart';
import 'package:pokeapi_app/utils/get_text_color_for_background.dart';
import 'package:pokeapi_app/utils/get_type_colors.dart';

class ListPokemonPage extends ConsumerStatefulWidget {
  const ListPokemonPage({super.key});

  @override
  ConsumerState<ListPokemonPage> createState() => _ListPokemonPageState();
}

class _ListPokemonPageState extends ConsumerState<ListPokemonPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    if (currentScroll >= maxScroll - 200 && !_isLoadingMore) {
      _loadMorePokemon();
    }
  }

  Future<void> _loadMorePokemon() async {
    setState(() => _isLoadingMore = true);

    await ref.read(pokemonProvider.notifier).fetchPokemonList(loadMore: true);

    setState(() => _isLoadingMore = false);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pokemonState = ref.watch(pokemonProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text(
          appTitle,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
      ),
      body: pokemonState.when(
        data: (pokemonList) => Stack(
          children: [
            ListView.builder(
              controller: _scrollController,
              itemCount: pokemonList.length,
              itemBuilder: (context, index) {
                final pokemon = pokemonList[index];
                final bgColor = getTypeColor(pokemon.types.first);
                final textColor = getTextColorForBackground(bgColor);

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: bgColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: _PokemonListTile(
                    pokemon: pokemon, 
                    textColor: textColor
                  ),
                );
              },
            ),
            if (_isLoadingMore)
              const Positioned(
                left: 0,
                right: 0,
                bottom: 16,
                child: Center(child: CircularProgressIndicator(
                  color: Colors.yellow,
                )),
              ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }
}

class _PokemonListTile extends StatelessWidget {
  const _PokemonListTile({
    required this.pokemon,
    required this.textColor,
  });

  final PokemonModel pokemon;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Hero(
        tag: pokemon.imageUrl,
        child: FadeInImage.assetNetwork(
          placeholder: 'assets/pokemon_placeholder.jpg',
          image: pokemon.imageUrl,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          imageErrorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.error, color: Colors.red);
          },
        ),
      ),
      title: Text(pokemon.name, style: TextStyle(color: textColor)),
      subtitle: Text(pokemon.types.first, style: TextStyle(color: textColor.withOpacity(0.8))),
      trailing: const Icon(Icons.chevron_right,color: Colors.white),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPokemonPage(pokemon: pokemon),
          ),
        );
      },
    );
  }
}
