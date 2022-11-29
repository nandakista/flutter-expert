import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:submission/core/constant/network_state.dart';
import 'package:submission/domain/entities/tv.dart';
import 'package:submission/ui/views/watchlist/tv/watchlist_tv_provider.dart';
import 'package:submission/ui/views/watchlist/tv/watchlist_tv_view.dart';

import 'watchlist_tv_view_test.mocks.dart';

@GenerateMocks([WatchlistTvProvider])
void main() {
  late MockWatchlistTvProvider mockProvider;

  setUp(() => mockProvider = MockWatchlistTvProvider());

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
    return ChangeNotifierProvider<WatchlistTvProvider>.value(
      value: mockProvider,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('''Should display Text with empty message when empty state''',
          (WidgetTester tester) async {
        // Arrange
        when(mockProvider.state).thenReturn(RequestState.empty);
        when(mockProvider.data).thenReturn(<Tv>[]);
        when(mockProvider.message).thenReturn('Empty message');
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
        when(mockProvider.state).thenReturn(RequestState.success);
        when(mockProvider.data).thenReturn(tTvList);
        // Act
        final listViewFinder = find.byType(ListView);
        await tester.pumpWidget(makeTestableWidget(const WatchlistTvView()));
        // Assert
        expect(listViewFinder, findsOneWidget);
      });
}
