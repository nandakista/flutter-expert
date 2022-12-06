import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:submission/domain/entities/tv.dart';
import 'package:submission/domain/usecases/get_on_air_tv.dart';

part 'tv_on_air_event.dart';

part 'tv_on_air_state.dart';

class TvOnAirBloc extends Bloc<TvOnAirEvent, TvOnAirState> {
  final GetOnAirTv getOnAirTv;

  TvOnAirBloc(this.getOnAirTv) : super(TvOnAirInitial()) {
    on<LoadOnAirTv>((event, emit) async {
      emit(TvOnAirLoading());
      final result = await getOnAirTv();
      result.fold(
        (failure) => emit(TvOnAirError(failure.message)),
        (data) => emit(TvOnAirHasData(data)),
      );
    });
  }
}
