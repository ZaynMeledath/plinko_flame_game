part of 'plinko_bloc.dart';

sealed class PlinkoState {
  final int points;
  final int betAmount;

  PlinkoState({required this.points, required this.betAmount});
}

class PlinkoPlayingState extends PlinkoState {
  PlinkoPlayingState({required super.points, required super.betAmount});
}

class PlinkoScoreCalculatingState extends PlinkoState {
  final double multiplier;

  PlinkoScoreCalculatingState({
    required this.multiplier,
    required super.points,
    required super.betAmount,
  });
}

class PlinkoLoadedState extends PlinkoState {
  PlinkoLoadedState({required super.points, required super.betAmount});
}
