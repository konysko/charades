import 'dart:math';

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

class RotatePhoneScreen extends StatefulWidget {
  @override
  State<RotatePhoneScreen> createState() => _RotatePhoneScreenState();
}

class _RotatePhoneScreenState extends State<RotatePhoneScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2))
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _controller.reset();
              _controller.forward();
            }
          })
          ..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final phoneIcon = Transform.rotate(
      angle: -pi / 4,
      child: Transform.flip(
        flipY: true,
        child: Icon(
          Icons.screen_rotation,
          size: 100,
          color: Colors.red,
        ),
      ),
    );
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                  animation: _controller,
                  child: phoneIcon,
                  builder: (context, child) => Transform.rotate(
                      angle: (_controller.value * pi) / 2, child: child)),
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
