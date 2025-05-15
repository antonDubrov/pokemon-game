import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:guess_pokemon/ui/screens/game_round_screen.dart';
import 'package:guess_pokemon/ui/widgets/custom_scaffold.dart';

class ResultScreen extends StatefulWidget {
  final Map<String, dynamic> pokemon;
  final int score;
  final int streak;

  const ResultScreen({
    super.key,
    required this.pokemon,
    required this.score,
    required this.streak,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  Future<void> _updateLeaderboard(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final docRef = FirebaseFirestore.instance.collection('leaderboard').doc(user.uid);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final snapshot = await transaction.get(docRef);

        if (snapshot.exists) {
          final currentScore = snapshot.data()?['score'] ?? 0;
          if (widget.score > currentScore) {
            transaction.set(docRef, {
              'email': user.email,
              'score': widget.score,
              'streak': widget.streak,
              'timestamp': FieldValue.serverTimestamp(),
            });
          }
        } else {
          transaction.set(docRef, {
            'email': user.email,
            'score': widget.score,
            'streak': widget.streak,
            'timestamp': FieldValue.serverTimestamp(),
          });
        }
      });
    }
  }

  @override
  void initState() {
    _updateLeaderboard(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: AppBar(
        title: const Text("Result"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      bgImage: AssetImage('assets/background_images/start_screen_background.png'),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Oops! It was ${(widget.pokemon['name'])} 😅",
              style: const TextStyle(fontSize: 24),
            ),
            CachedNetworkImage(
              imageUrl: widget.pokemon['sprites']['front_default'],
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              height: 200,
            ),
            Text("Name: ${widget.pokemon['name']}", style: const TextStyle(fontSize: 20)),
            Text("Type: ${widget.pokemon['types'].map((t) => t['type']['name']).join(', ')}"),
            Text("HP: ${widget.pokemon['stats'][0]['base_stat']}"),
            Text("Attack: ${widget.pokemon['stats'][1]['base_stat']}"),
            Text("Defense: ${widget.pokemon['stats'][2]['base_stat']}"),
            Text("Score: ${widget.score}"),
            Text("Streak: ${widget.streak}"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const GameRoundScreen()),
              ),
              child: const Text("Play Again"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Back to Start"),
            ),
          ],
        ),
      ),
    );
  }
}
