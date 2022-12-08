import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:submission/domain/entities/tv.dart';
import 'package:submission/ui/views/watchlist/tv/bloc/watchlist_tv_bloc.dart';
import 'package:submission/ui/views/watchlist/tv/watchlist_tv_view.dart';

class MockWatchlistTvBloc extends MockBloc<WatchlistTvEvent, WatchlistTvState>
    implements WatchlistTvBloc {}

void main() {
  late MockWatchlistTvBloc mockBloc;

  setUp(() => mockBloc = MockWatchlistTvBloc());

  final tTvList = [
    const Tv(
      id: 60625,
      name: 'Rick and Morty',
      posterPath: '/url.jpg',
      overview: 'overview',
      voteAverage: 8.7,
      voteCount: 7426,
      popularity: 1377.974,
      originalName: 'Rick and Morty',
      originalLanguage: 'en',
      originCountry: ['US'],
      firstAirDate: '2013-12-02',
      genreIds: [16, 35, 10765, 10759],
      backdropPath: '/url.jpg',
    ),
  ];

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<WatchlistTvBloc>.value(
      value: mockBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('''Should display Text with empty message when empty state''',
      (WidgetTester tester) async {
    // Arrange
    when(() => mockBloc.state)
        .thenReturn(const WatchlistTvEmpty('Empty message'));
    // Act
    final textFinder = find.byKey(const Key('empty_message'));
    final centerFinder = find.byType(Center);
    await tester.pumpWidget(makeTestableWidget(const WatchlistTvView()));
    // Assert
    expect(textFinder, findsOneWidget);
    expect(centerFinder, findsOneWidget);
  });

  testWidgets('Should display ListView when state is success',
      (WidgetTester tester) async {
    // Arrange
    when(() => mockBloc.state).thenReturn(WatchlistTvHasData(tTvList));
    // Act
    final listViewFinder = find.byType(ListView);
    await tester.pumpWidget(makeTestableWidget(const WatchlistTvView()));
    // Assert
    expect(listViewFinder, findsOneWidget);
  });
}
