import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:submission/domain/entities/movie.dart';
import 'package:submission/ui/views/search/bloc/search_bloc.dart';
import 'package:submission/ui/views/search/search_view.dart';

class MockSearchBloc extends MockBloc<SearchEvent, SearchState>
    implements SearchBloc {}

void main() {
  late MockSearchBloc mockBloc;

  setUp(() {
    mockBloc = MockSearchBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<SearchBloc>(
      create: (_) => mockBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets(
      '''Initial state should not display loading, error text, empty text, and list''',
      (widgetTester) async {
    // Arrange
    when(() => mockBloc.state).thenReturn(SearchInitial());
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
    when(() => mockBloc.state).thenReturn(SearchLoading());
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
    when(() => mockBloc.state).thenReturn(SearchHasData(tMovieList));
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
    when(() => mockBloc.state).thenReturn(const SearchEmpty('Empty Message'));
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
    when(() => mockBloc.state).thenReturn(const SearchError('Error message'));
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
