import 'dart:math' as math;

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plinko_flame_game/bloc/plinko_bloc.dart';
import 'package:plinko_flame_game/plinko_game.dart';
import 'package:plinko_flame_game/src/plinko_configs.dart';
import 'package:plinko_flame_game/utils/screen_size.dart';

class PlinkoGameScreen extends StatefulWidget {
  const PlinkoGameScreen({super.key});

  @override
  State<PlinkoGameScreen> createState() => _PlinkoGameScreenState();
}

class _PlinkoGameScreenState extends State<PlinkoGameScreen> {
  ValueNotifier<bool> audioEnabledListenable = ValueNotifier(true);
  final ValueNotifier<int> betAmountListenable = ValueNotifier(50);
  late final PlinkoGame game;

  @override
  void initState() {
    PlinkoConfigs.init();
    game = PlinkoGame();
    super.initState();
  }

  //==================== Show Overlay ====================//
  void showOverlay(double multiplier) async {
    final overlayEntry = OverlayEntry(
      builder: (_) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: PlinkoConfigs.gameHeight * 0.55),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: multiplier < 1 ? Colors.red : Colors.green,
                borderRadius: BorderRadius.circular(20),
              ),
              child: DefaultTextStyle(
                style: TextStyle(
                  fontSize: 60.w(),
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                child: Text('${multiplier}x'),
              ),
            ),
          ],
        );
      },
    );

    Overlay.of(context).insert(overlayEntry);

    await Future.delayed(const Duration(milliseconds: 2000));
    overlayEntry.remove();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0f212e),
      body: BlocListener<PlinkoBloc, PlinkoState>(
        listener: (context, state) {
          if (state is PlinkoScoreCalculatingState) {
            showOverlay(state.multiplier);
          }
        },
        child: SafeArea(
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
                width: 32.w(),
                height: 32.w(),
                decoration: BoxDecoration(
                  color: const Color(0xFF10b981),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.trending_up,
                  color: Colors.white,
                  size: 22.w(),
                ),
              ),
              SizedBox(width: 8.w()),
              Text(
                'Plinko',
                style: TextStyle(
                  fontSize: 26.w(),
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
                BlocBuilder<PlinkoBloc, PlinkoState>(
                  builder: (context, state) {
                    return Text(
                      '${state.points}',
                      style: TextStyle(
                        fontSize: 28.w(),
                        fontFamily: 'monospace',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 18.h()),

          // Bet Amount
          ValueListenableBuilder(
            valueListenable: betAmountListenable,
            builder: (context, betAmount, child) {
              return _buildInputField(
                label: 'BET AMOUNT',
                value: betAmount,
                onChanged: (value) =>
                    betAmountListenable.value = math.max(0, value),
              );
            },
          ),

          SizedBox(height: 38.h()),

          // Bet Button
          BlocBuilder<PlinkoBloc, PlinkoState>(
            builder: (context, state) {
              return ElevatedButton(
                onPressed: () {
                  if (state.points < betAmountListenable.value ||
                      state is! PlinkoLoadedState) {
                    return;
                  }
                  game.dropBall(betAmount: betAmountListenable.value);
                },

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
                  state is PlinkoPlayingState
                      ? '...'
                      : state is PlinkoScoreCalculatingState
                      ? 'Calculating Score'
                      : 'BET',
                  style: TextStyle(
                    fontSize: 18.w(),
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 16.h()),

          // Footer
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () =>
                  audioEnabledListenable.value = !audioEnabledListenable.value,
              child: ValueListenableBuilder(
                valueListenable: audioEnabledListenable,
                builder: (context, audioEnabled, child) {
                  return Icon(
                    audioEnabled ? Icons.volume_up : Icons.volume_off,
                    color: Colors.grey[400],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required int value,
    required Function(int) onChanged,
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
        SizedBox(height: 8.h()),
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
