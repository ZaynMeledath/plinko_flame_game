import 'package:flutter_bloc/flutter_bloc.dart';

part 'plinko_event.dart';
part 'plinko_state.dart';

class PlinkoBloc extends Bloc<PlinkoEvent, PlinkoState> {
  PlinkoBloc() : super(PlinkoLoadedState(points: 1000, betAmount: 50)) {
    //==================== Plinko Bet Event ====================//
    on<PlinkoBetEvent>((event, emit) {
      return emit(
        PlinkoPlayingState(
          points: state.points - event.betAmount,
          betAmount: event.betAmount,
        ),
      );
    });

    //==================== Plinko Win Event ====================//
    on<PlinkoWinEvent>((event, emit) async {
      emit(
        PlinkoScoreCalculatingState(
          multiplier: event.multiplier,
          points: state.points,
          betAmount: state.betAmount,
        ),
      );
      await Future.delayed(const Duration(seconds: 3));
      final points = (state.points + state.betAmount * event.multiplier)
          .toInt();
      return emit(
        PlinkoLoadedState(points: points, betAmount: state.betAmount),
      );
    });
  }
}

final plinkoBloc = PlinkoBloc();
