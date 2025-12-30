part of 'plinko_bloc.dart';

sealed class PlinkoEvent {}

class PlinkoBetEvent extends PlinkoEvent {
  final int betAmount;

  PlinkoBetEvent({required this.betAmount});
}

class PlinkoWinEvent extends PlinkoEvent {
  final double multiplier;

  PlinkoWinEvent({required this.multiplier});
}
