import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:submission/domain/entities/movie.dart';
import 'package:submission/ui/views/watchlist/movie/bloc/watchlist_movie_bloc.dart';
import 'package:submission/ui/views/watchlist/movie/watchlist_movie_view.dart';

class MockWatchlistMovieBloc
    extends MockBloc<WatchlistMovieEvent, WatchlistMovieState>
    implements WatchlistMovieBloc {}

void main() {
  late MockWatchlistMovieBloc mockBloc;

  setUp(() => mockBloc = MockWatchlistMovieBloc());

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

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<WatchlistMovieBloc>(
      create: (_) => mockBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('''Should display Text with error message when error state''',
      (WidgetTester tester) async {
    // Arrange
    when(() => mockBloc.state)
        .thenReturn(const WatchlistMovieError('Error message'));
    // Act
    final textFinder = find.byKey(const Key('error_message'));
    final centerFinder = find.byType(Center);
    await tester.pumpWidget(makeTestableWidget(const WatchlistMovieView()));
    // Assert
    expect(textFinder, findsOneWidget);
    expect(centerFinder, findsOneWidget);
  });

  testWidgets('''Should display Text with empty message when empty state''',
      (WidgetTester tester) async {
    // Arrange
    when(() => mockBloc.state)
        .thenReturn(const WatchlistMovieEmpty('Empty message'));
    // Act
    final textFinder = find.byKey(const Key('empty_message'));
    final centerFinder = find.byType(Center);
    await tester.pumpWidget(makeTestableWidget(const WatchlistMovieView()));
    // Assert
    expect(textFinder, findsOneWidget);
    expect(centerFinder, findsOneWidget);
  });

  testWidgets('Should display ListView when state is success',
      (WidgetTester tester) async {
    // Arrange
    when(() => mockBloc.state).thenReturn(WatchlistMovieHasData(tMovieList));
    // Act
    final listViewFinder = find.byType(ListView);
    await tester.pumpWidget(makeTestableWidget(const WatchlistMovieView()));
    // Assert
    expect(listViewFinder, findsOneWidget);
  });
}
