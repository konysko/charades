import 'package:charades/gameplay_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'gameplay_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MultiProvider(providers: [
        ChangeNotifierProvider(create: (_) => GameplayModel()),
      ], child: GameplayScreen()),
    );
  }
}

class GameplayScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final gameState = context.watch<GameplayModel>();
    if (!(gameState.gameplayState is Initial)) {
      return GameScreen();
    }
    return OrientationBuilder(builder: (context, orientation) {
      final gameState = context.read<GameplayModel>();
      if (orientation == Orientation.portrait) {
        return RotatePhoneScreen();
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        gameState.startGame();
      });
      return GameScreen();
    });
  }
}

class RotatePhoneScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedRotation(
                duration: Duration(seconds: 1),
                turns: 0.25,
                child: Icon(
                  Icons.screen_rotation,
                  size: 100,
                  color: Colors.red,
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Please rotate your phone to horizontal position",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
