import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:submission/core/constant/network_state.dart';
import 'package:submission/domain/entities/tv.dart';
import 'package:submission/ui/views/tv_search/tv_search_provider.dart';
import 'package:submission/ui/views/tv_search/tv_search_view.dart';

import 'tv_search_view_test.mocks.dart';

@GenerateMocks([TvSearchProvider])
void main() {
  late MockTvSearchProvider mockProvider;

  setUp(() => mockProvider = MockTvSearchProvider());

  Widget makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<TvSearchProvider>.value(
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
    await widgetTester.pumpWidget(makeTestableWidget(const TvSearchView()));
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
    await widgetTester.pumpWidget(makeTestableWidget(const TvSearchView()));
    // Assert
    expect(progressBarFinder, findsOneWidget);
    expect(errorFinder, findsNothing);
    expect(emptyFinder, findsNothing);
    expect(listViewFinder, findsNothing);
  });

  testWidgets('Should display ListView when state is success',
      (WidgetTester tester) async {
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
    // Arrange
    when(mockProvider.state).thenReturn(RequestState.success);
    when(mockProvider.data).thenReturn(tTvList);
    // Act
    final listViewFinder = find.byType(ListView);
    final progressBarFinder = find.byKey(const Key('loading_indicator_state'));
    final errorFinder = find.byKey(const Key('error_message'));
    final emptyFinder = find.byKey(const Key('empty_message'));
    await tester.pumpWidget(makeTestableWidget(const TvSearchView()));
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
    when(mockProvider.data).thenReturn(<Tv>[]);
    when(mockProvider.message).thenReturn('Empty message');
    // Act
    final listViewFinder = find.byType(ListView);
    final progressBarFinder = find.byKey(const Key('loading_indicator_state'));
    final errorFinder = find.byKey(const Key('error_message'));
    final emptyFinder = find.byKey(const Key('empty_message'));
    await tester.pumpWidget(makeTestableWidget(const TvSearchView()));
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
    await tester.pumpWidget(makeTestableWidget(const TvSearchView()));
    // Assert
    expect(progressBarFinder, findsNothing);
    expect(errorFinder, findsOneWidget);
    expect(emptyFinder, findsNothing);
    expect(listViewFinder, findsNothing);
  });
}
