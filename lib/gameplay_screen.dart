import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'gameplay_model.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      left: false,
      bottom: false,
      child: Scaffold(
        backgroundColor: Colors.deepPurple[50],
        body: Stack(
          children: [
            Consumer<GameplayModel>(
              builder: (context, gameProvider, child) {
                if (gameProvider.gameplayState is Completed) {
                  return _buildResults(gameProvider);
                }
                return _buildLandscapeLayout(context, gameProvider);
              },
            ),
            Consumer<GameplayModel>(
              builder: (context, gameProvider, child) {
                if (gameProvider.gameplayState is Overlayed) {
                  return Container(
                    color: (gameProvider.gameplayState as Overlayed)
                        .color
                        .withOpacity(0.8),
                  );
                }
                return SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLandscapeLayout(BuildContext context, GameplayModel provider) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Skip button
          ElevatedButton(
            onPressed: provider.skipWord,
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.close,
                  size: 64,
                  color: Colors.white,
                ),
                Text('Skip',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white))
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  provider.currentWord,
                  style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurpleAccent),
                ),
                const SizedBox(height: 20),
                Text(
                  'Time left: ${provider.timeLeft} s',
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          // Guessed button
          ElevatedButton(
            onPressed: provider.guessedWord,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check,
                  size: 64,
                  color: Colors.white,
                ),
                Text('Guess',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white))
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResults(GameplayModel provider) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Game is over',
          style: TextStyle(
              fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: provider.guessedWords.length,
            itemBuilder: (context, index) {
              final wordResult = provider.guessedWords[index];
              return ListTile(
                title: Text(
                  wordResult.word,
                  style: TextStyle(
                      fontSize: 24,
                      color: wordResult.isGuessed ? Colors.green : Colors.red),
                ),
                leading: Icon(
                  wordResult.isGuessed ? Icons.check : Icons.close,
                  color: wordResult.isGuessed ? Colors.green : Colors.red,
                ),
              );
            },
          ),
        ),
        Expanded(
          child: Center(),
        ),
      ],
    );
  }
}
