import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:submission/core/constant/network_state.dart';
import 'package:submission/domain/entities/movie.dart';
import 'package:submission/ui/views/search/search_provider.dart';
import 'package:submission/ui/views/search/search_view.dart';

import 'search_view_test.mocks.dart';

@GenerateMocks([SearchProvider])
void main() {
  late MockSearchProvider mockProvider;

  setUp(() => mockProvider = MockSearchProvider());

  Widget makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<SearchProvider>.value(
      value: mockProvider,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets(
      '''Initial state should not display loading, error text, empty text, and list''',
      (widgetTester) async {
    // Arrange
    when(mockProvider.state).thenReturn(RequestState.initial);
    // Act
    final progressBarFinder = find.byKey(const Key('loading_indicator_state'));
    final errorFinder = find.byKey(const Key('error_message'));
    final emptyFinder = find.byKey(const Key('empty_message'));
    final listViewFinder = find.byType(ListView);
    await widgetTester.pumpWidget(makeTestableWidget(const SearchView()));
    // Assert
    expect(progressBarFinder, findsNothing);
    expect(errorFinder, findsNothing);
    expect(emptyFinder, findsNothing);
    expect(listViewFinder, findsNothing);
  });

  testWidgets('''Should display loading indicator when loading state''',
      (widgetTester) async {
    // Arrange
    when(mockProvider.state).thenReturn(RequestState.loading);
    // Act
    final progressBarFinder = find.byKey(const Key('loading_indicator_state'));
    final errorFinder = find.byKey(const Key('error_message'));
    final emptyFinder = find.byKey(const Key('empty_message'));
    final listViewFinder = find.byType(ListView);
    await widgetTester.pumpWidget(makeTestableWidget(const SearchView()));
    // Assert
    expect(progressBarFinder, findsOneWidget);
    expect(errorFinder, findsNothing);
    expect(emptyFinder, findsNothing);
    expect(listViewFinder, findsNothing);
  });

  testWidgets('Should display ListView when state is success',
      (WidgetTester tester) async {
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
    // Arrange
    when(mockProvider.state).thenReturn(RequestState.success);
    when(mockProvider.data).thenReturn(tMovieList);
    // Act
    final listViewFinder = find.byType(ListView);
    final progressBarFinder = find.byKey(const Key('loading_indicator_state'));
    final errorFinder = find.byKey(const Key('error_message'));
    final emptyFinder = find.byKey(const Key('empty_message'));
    await tester.pumpWidget(makeTestableWidget(const SearchView()));
    // Assert
    expect(progressBarFinder, findsNothing);
    expect(errorFinder, findsNothing);
    expect(emptyFinder, findsNothing);
    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('''Should display Text with empty message when empty state''',
      (WidgetTester tester) async {
    // Arrange
    when(mockProvider.state).thenReturn(RequestState.empty);
    when(mockProvider.data).thenReturn(<Movie>[]);
    when(mockProvider.message).thenReturn('Empty message');
    // Act
    final listViewFinder = find.byType(ListView);
    final progressBarFinder = find.byKey(const Key('loading_indicator_state'));
    final errorFinder = find.byKey(const Key('error_message'));
    final emptyFinder = find.byKey(const Key('empty_message'));
    await tester.pumpWidget(makeTestableWidget(const SearchView()));
    // Assert
    expect(progressBarFinder, findsNothing);
    expect(errorFinder, findsNothing);
    expect(emptyFinder, findsOneWidget);
    expect(listViewFinder, findsNothing);
  });

  testWidgets('''Should display Text with error message when error state''',
      (WidgetTester tester) async {
    // Arrange
    when(mockProvider.state).thenReturn(RequestState.error);
    when(mockProvider.message).thenReturn('Error message');
    // Act
    final listViewFinder = find.byType(ListView);
    final progressBarFinder = find.byKey(const Key('loading_indicator_state'));
    final errorFinder = find.byKey(const Key('error_message'));
    final emptyFinder = find.byKey(const Key('empty_message'));
    await tester.pumpWidget(makeTestableWidget(const SearchView()));
    // Assert
    expect(progressBarFinder, findsNothing);
    expect(errorFinder, findsOneWidget);
    expect(emptyFinder, findsNothing);
    expect(listViewFinder, findsNothing);
  });
}
