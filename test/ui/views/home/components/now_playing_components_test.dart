import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:submission/domain/entities/movie.dart';
import 'package:submission/ui/views/home/bloc/home_bloc.dart';
import 'package:submission/ui/views/home/components/now_playing_components.dart';

class MockHomeBloc extends MockBloc<HomeEvent, HomeState> implements HomeBloc {}

void main() {
  late MockHomeBloc mockBloc;

  setUp(() => mockBloc = MockHomeBloc());

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<HomeBloc>(
      create: (_) => mockBloc,
      child: MaterialApp(home: body),
    );
  }

  final tMovieList = [
    const Movie(
      adult: false,
      backdropPath: '/url.jpg',
      genreIds: [
        28,
        14,
        878,
      ],
      id: 436270,
      originalTitle: 'Black Adam',
      overview: 'Some Overview',
      popularity: 23828.993,
      posterPath: '/url.jpg',
      releaseDate: '2022-10-19',
      title: 'Black Adam',
      video: false,
      voteAverage: 6.8,
      voteCount: 1270,
    ),
  ];

  testWidgets('''Should display loading indicator when loading state''',
      (widgetTester) async {
    // Arrange
    when(() => mockBloc.state).thenReturn(HomeLoading());
    // Act
    final progressBarFinder =
        find.byKey(const Key('now_playing_component_loading'));
    await widgetTester
        .pumpWidget(makeTestableWidget(const NowPlayingComponents()));
    // Assert
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('''Should display Text with error message when error state''',
      (WidgetTester tester) async {
    // Arrange
    when(() => mockBloc.state).thenReturn(const HomeError('Error message'));
    // Act
    final textFinder = find.byKey(const Key('now_playing_component_error'));
    await tester.pumpWidget(makeTestableWidget(const NowPlayingComponents()));
    // Assert
    expect(textFinder, findsOneWidget);
  });

  testWidgets('Should display ListView when state is success',
      (WidgetTester tester) async {
    // Arrange
    when(() => mockBloc.state).thenReturn(HomeHasData(tMovieList));
    // Act
    final listViewFinder = find.byType(GridView);
    await tester.pumpWidget(makeTestableWidget(const NowPlayingComponents()));
    // Assert
    expect(listViewFinder, findsOneWidget);
  });
}
