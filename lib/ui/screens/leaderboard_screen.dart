import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:guess_pokemon/ui/widgets/custom_scaffold.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      bgImage: AssetImage('assets/background_images/start_screen_background.png'),
      child: Container(
        margin: EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(38)),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('leaderboard')
              .orderBy('score', descending: true)
              .limit(5)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("No leaderboard data yet."));
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final doc = snapshot.data!.docs[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(219, 248, 255, 1),
                    borderRadius: BorderRadius.circular(26),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    children: [
                      Icon(
                        Icons.person,
                        color: Color.fromRGBO(0, 187, 255, 1),
                        size: 100,
                      ),
                      const SizedBox(width: 36),
                      FittedBox(
                        fit: BoxFit.fill,
                        child: Column(
                          children: [
                            Text(
                              doc['email'],
                              style: TextStyle(fontFamily: 'LuckiestGuy'),
                            ),
                            Text(
                              "Score: ${doc['score']} | Streak: ${doc['streak']}",
                              style: TextStyle(fontFamily: 'LuckiestGuy'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
