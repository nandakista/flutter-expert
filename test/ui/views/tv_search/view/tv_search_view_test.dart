import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:submission/domain/entities/tv.dart';
import 'package:submission/ui/views/tv_search/bloc/tv_search_bloc.dart';
import 'package:submission/ui/views/tv_search/tv_search_view.dart';

class MockTvSearchBloc extends MockBloc<TvSearchEvent, TvSearchState>
    implements TvSearchBloc {}

void main() {
  late MockTvSearchBloc mockBloc;

  setUp(() {
    mockBloc = MockTvSearchBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<TvSearchBloc>(
      create: (_) => mockBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets(
      '''Initial state should not display loading, error text, empty text, and list''',
      (widgetTester) async {
    // Arrange
    when(()=> mockBloc.state).thenReturn(TvSearchInitial());
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
    when(()=> mockBloc.state).thenReturn(TvSearchLoading());
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
    when(()=> mockBloc.state).thenReturn(TvSearchHasData(tTvList));
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
    when(()=> mockBloc.state).thenReturn(const TvSearchEmpty('Empty message'));
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
    when(()=> mockBloc.state).thenReturn(const TvSearchError('Error message'));
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
