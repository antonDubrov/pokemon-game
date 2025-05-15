import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:guess_pokemon/ui/screens/result_screen.dart';
import 'package:guess_pokemon/ui/widgets/custom_scaffold.dart';
import 'package:guess_pokemon/utils/capitalize.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

class GameRoundScreen extends StatefulWidget {
  const GameRoundScreen({super.key});

  @override
  State<GameRoundScreen> createState() => _GameRoundPageState();
}

class _GameRoundPageState extends State<GameRoundScreen> {
  Map<String, dynamic>? correctPokemon;
  List<String> options = [];
  int score = 0;
  int streak = 0;
  int timeLeft = 20;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    fetchPokemon();
    startTimer();
  }

  Future<void> fetchPokemon() async {
    final random = Random();
    final pokemonId = random.nextInt(201) + 1; // Gen 1 Pokémon
    final response = await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/$pokemonId'));
    final pokemonData = jsonDecode(response.body);

    List<String> distractors = [];
    while (distractors.length < 3) {
      final distractorId = random.nextInt(201) + 1;
      if (distractorId != pokemonId) {
        final distractorResponse =
            await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/$distractorId'));
        distractors.add(jsonDecode(distractorResponse.body)['name']);
      }
    }

    setState(() {
      correctPokemon = pokemonData;
      options = [pokemonData['name'], ...distractors]..shuffle();
    });
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (timeLeft > 0) {
          timeLeft--;
        } else {
          timer.cancel();
          navigateToResult(false);
        }
      });
    });
  }

  void navigateToResult(bool isCorrect) {
    timer?.cancel();
    if (isCorrect) {
      correctPokemon = null;
      fetchPokemon();
      setState(() {
        score += 10 + (streak * 5);
        streak++;
        timeLeft = 20;
        startTimer();
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            pokemon: correctPokemon!,
            score: score,
            streak: streak,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (correctPokemon == null) {
      return CustomScaffold(
        bgImage: AssetImage('assets/background_images/game_screen_background.png'),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return CustomScaffold(
      bgImage: AssetImage('assets/background_images/game_screen_background.png'),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Score: $score",
              style: const TextStyle(
                fontSize: 20,
                fontFamily: 'LuckiestGuy',
                color: Colors.white,
              ),
            ),
            Text(
              "Streak: $streak",
              style: const TextStyle(
                fontSize: 20,
                fontFamily: 'LuckiestGuy',
                color: Colors.white,
              ),
            ),
            Text(
              "Time: $timeLeft s",
              style: const TextStyle(
                fontSize: 20,
                fontFamily: 'LuckiestGuy',
                color: Colors.white,
              ),
            ),
            Stack(
              alignment: AlignmentDirectional.center,
              children: [
                CachedNetworkImage(
                  imageUrl: correctPokemon!['sprites']['front_default'],
                  imageBuilder: (context, imageProvider) => Image(
                    image: imageProvider,
                    color: Colors.black.withOpacity(0.7),
                    colorBlendMode: BlendMode.darken,
                  ),
                  placeholder: (context, url) => Center(child: const CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  height: 180,
                ),
                Icon(
                  Icons.question_mark,
                  size: 60,
                  color: Colors.white,
                ),
              ],
            ),
            const SizedBox(height: 20),
            ...options.map((option) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: GestureDetector(
                    onTap: () => navigateToResult(option == correctPokemon!['name']),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 24),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue[700]!, width: 3),
                        borderRadius: BorderRadius.circular(36),
                      ),
                      child: Center(
                        child: Stack(
                          children: [
                            Text(
                              option.capitalize(),
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'LuckiestGuy',
                                foreground: Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = 6
                                  ..color = Colors.blue[700]!,
                              ),
                            ),
                            Text(
                              option.capitalize(),
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'LuckiestGuy',
                                color: Colors.grey[300],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
