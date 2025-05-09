# pokeapi_app

Una aplicación Flutter que muestra detalles de Pokémon usando la [PokeAPI](https://pokeapi.co/). Diseñada con una interfaz atractiva al estilo Pokédex.

(Aplicacion solo testeada en Android)

---

## 🚀 Requisitos

- Flutter SDK versión **3.27.1**
- Dart SDK compatible
- Conexión a internet (para consumir la PokeAPI)

## ▶️ ¿Cómo correr la app?

### En modo desarrollo

```bash
flutter pub get
flutter run
```

### En modo release (producción)

1 Asegúrate de tener un archivo key.properties dentro de la carpeta android/:

storePassword=your_store_password
keyPassword=your_key_password
keyAlias=your_key_alias
storeFile=keystore.jks

2 Genera un archivo de firma (keystore):

```bash
keytool -genkey -v -keystore keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias your_key_alias
```

3 Coloca keystore.jks dentro del directorio android/app/.

4 Construye el APK en modo release:

```bash
flutter build apk --release
```

## Distribuir con Firebase App Distribution (si está configurado)
firebase appdistribution:distribute build/app/outputs/flutter-apk/app-release.apk --app <APP_ID> --groups <TESTERS_GROUP>

## 🧪 Pruebas en DetailPokemonPage
La clase Image.network realiza solicitudes HTTP reales durante los tests, lo cual está bloqueado. Para evitar errores, se recomienda simularla con un widget de prueba (MockNetworkImage).

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
```
### Solución Recomendada para Tests
Reemplazar Image.network por un mock en los tests. Puedes usar un paquete como mocktail_image_network o crear tu propio widget simulado para evitar la carga de red.

## 💡 Mejoras Futuras (Escenario Real)

Si esta app se desarrollara como un producto real, las siguientes serían las mejoras que se podrían implementar para llevarla a otro nivel:

Funcionalidad	                      Descripción	                                                          Tiempo estimado
🔐 Registro/Login con Firebase Auth	Permitir que los usuarios se registren e inicien sesión	                  1 semana
🔍 Funcionalidad de Búsqueda	      Buscar Pokémon por nombre o número	                                      2 días
🧪 Integrar Crashlytics	            Reporte automático de errores en producción con Firebase Crashlytics	    1 día
🔄 CI/CD con GitHub Actions	        Automatización de pruebas, builds y despliegues en Firebase Distribution	1 semana
🎨 Mejora de UI/UX	                Transiciones, dark mode, diseño responsive	                              3-4 días

##  Tecnologías Utilizadas
Flutter 3.27.1

Dart

PokeAPI REST

Firebase (planificado)

GitHub Actions (planificado)

## 🤝 Autor
Desarrollado por Ricardo
Contacto: ricardo_29leyva@outlook.com
