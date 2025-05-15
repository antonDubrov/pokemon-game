import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:guess_pokemon/ui/screens/game_round_screen.dart';
import 'package:guess_pokemon/ui/screens/leaderboard_screen.dart';
import 'package:guess_pokemon/ui/widgets/custom_scaffold.dart';

class StartGameScreen extends StatelessWidget {
  const StartGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () => FirebaseAuth.instance.signOut(),
            icon: Icon(Icons.exit_to_app, color: Colors.red[900], size: 50),
          )
        ],
      ),
      bgImage: AssetImage('assets/background_images/start_screen_background.png'),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/icons/start_screen_logo.png'),
              const SizedBox(height: 50),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GameRoundScreen()),
                ),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(73),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 35),
                      child: Text(
                        'START',
                        style: TextStyle(
                          fontSize: 64,
                          color: Colors.white,
                          fontFamily: 'LuckiestGuy',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LeaderboardScreen(),
                  ),
                ),
                child: Stack(
                  alignment: AlignmentDirectional.topEnd,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.yellow,
                        borderRadius: BorderRadius.circular(73),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(8, 8),
                            blurStyle: BlurStyle.normal,
                            color: Color.fromRGBO(238, 175, 39, 1),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 35),
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: Text(
                            'LEADERBOARDS',
                            style: TextStyle(
                              fontSize: 48,
                              color: Colors.white,
                              fontFamily: 'LuckiestGuy',
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 136, 0, 1),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      padding: EdgeInsets.all(10),
                      child: Icon(
                        Icons.leaderboard,
                        color: Color.fromRGBO(255, 234, 0, 1),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
