import 'package:flutter/material.dart';
import 'package:guess_pokemon/ui/screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:guess_pokemon/ui/screens/start_game_screen.dart';
import 'package:guess_pokemon/ui/widgets/custom_scaffold.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const PokemonGameApp());
}

class PokemonGameApp extends StatelessWidget {
  const PokemonGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Who's That Pokémon?",
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.black)),
      ),
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CustomScaffold(
            bgImage: AssetImage('assets/background_images/start_screen_background.png'),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (snapshot.hasData) {
          return const StartGameScreen();
        }
        return const LoginScreen();
      },
    );
  }
}
