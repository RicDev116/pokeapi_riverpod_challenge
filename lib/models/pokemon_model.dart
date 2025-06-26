class PokemonModel {
  final String name;
  final String imageUrl;
  final int number;
  final List<String> types;
  final String? description;
  final double? weight;
  final double? height;
  final String? category;
  final String? ability;

  PokemonModel({
    required this.name,
    required this.imageUrl,
    required this.number,
    required this.types,
    this.description,
    this.weight,
    this.height,
    this.category,
    this.ability,
  });

  factory PokemonModel.fromJson(Map<String, dynamic> json) {
    return PokemonModel(
      name: json['name'],
      number: json['id'],
      imageUrl: json['sprites']['other']['official-artwork']['front_default'] ?? '',
      types: (json['types'] as List)
          .map((t) => t['type']['name'] as String)
          .toList(),
      weight: (json['weight'] / 10), // decagramos a kg
      height: (json['height'] / 10), // decímetros a metros
      ability: json['abilities'][0]['ability']['name'] ?? 'unknown',
      category: json['species']['name'],
      description: '', // this value is required in other endpoint: /pokemon-species/{id}
    );
  }

  PokemonModel copyWith({
    String? name,
    String? imageUrl,
    int? number,
    List<String>? types,
    String? description,
    double? weight,
    double? height,
    String? category,
    String? ability,
  }) {
    return PokemonModel(
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      number: number ?? this.number,
      types: types ?? this.types,
      description: description ?? this.description,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      category: category ?? this.category,
      ability: ability ?? this.ability,
    );
  }
}
