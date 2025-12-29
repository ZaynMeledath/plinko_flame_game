import 'dart:math' as math;

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:plinko_flame_game/plinko_game.dart';
import 'package:plinko_flame_game/src/plinko_configs.dart';
import 'package:plinko_flame_game/utils/screen_size.dart';

class PlinkoGameScreen extends StatefulWidget {
  const PlinkoGameScreen({super.key});

  @override
  State<PlinkoGameScreen> createState() => _PlinkoGameScreenState();
}

class _PlinkoGameScreenState extends State<PlinkoGameScreen> {
  bool audioEnabled = true;
  double betAmount = 50;
  double balance = 1000;
  late final PlinkoGame game;

  @override
  void initState() {
    PlinkoConfigs.init();
    game = PlinkoGame();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0f212e),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                width: PlinkoConfigs.gameWidth,
                height: PlinkoConfigs.gameHeight,
                child: GameWidget(game: game),
              ),
            ),
            Spacer(),
            _buildActionsContainer(),
          ],
        ),
      ),
    );
  }

  Widget _buildActionsContainer() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w(), vertical: 8.h()),
      decoration: BoxDecoration(
        color: const Color(0xFF1a2c38),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withAlpha(25)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 30.w(),
                height: 30.w(),
                decoration: BoxDecoration(
                  color: const Color(0xFF10b981),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.trending_up,
                  color: Colors.white,
                  size: 20.w(),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Plinko',
                style: TextStyle(
                  fontSize: 24.w(),
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 18.w()),

          // Balance
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF0f212e),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white.withAlpha(50)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'BALANCE',
                  style: TextStyle(
                    fontSize: 12.w(),
                    color: Colors.grey[400],
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),
                SizedBox(height: 6.h()),
                Text(
                  '${balance.toInt()}',
                  style: TextStyle(
                    fontSize: 28.w(),
                    fontFamily: 'monospace',
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 18.h()),

          // Bet Amount
          _buildInputField(
            label: 'BET AMOUNT',
            value: betAmount,
            onChanged: (v) => setState(() => betAmount = math.max(0, v)),
          ),

          SizedBox(height: 38.h()),

          // Bet Button
          ElevatedButton(
            onPressed: balance >= betAmount ? game.dropBall : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10b981),
              foregroundColor: const Color(0xFF0f212e),
              padding: EdgeInsets.symmetric(vertical: 16.w()),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 4,
            ),
            child: Text(
              'BET',
              style: TextStyle(fontSize: 18.w(), fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 16.h()),

          // Footer
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () => setState(() => audioEnabled = !audioEnabled),
              child: Icon(
                audioEnabled ? Icons.volume_up : Icons.volume_off,
                color: Colors.grey[400],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required double value,
    required Function(double) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10.w(),
            color: Colors.grey[400],
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: TextEditingController(text: value.toString()),
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                enabled: false,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF0f212e),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.white.withAlpha(50)),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12.w(),
                    vertical: 8.h(),
                  ),
                ),
                onChanged: (v) => onChanged(double.tryParse(v) ?? value),
              ),
            ),
            SizedBox(width: 8.w()),
            _buildQuickButton('-50', () => onChanged(value - 50)),
            const SizedBox(width: 4),
            _buildQuickButton('+50', () => onChanged(value + 50)),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[700],
        padding: EdgeInsets.symmetric(horizontal: 8.w(), vertical: 4.h()),
        minimumSize: const Size(36, 32),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12.w(),
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
