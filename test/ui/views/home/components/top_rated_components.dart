import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:submission/domain/entities/movie.dart';
import 'package:submission/ui/views/home/components/top_rated_components.dart';
import 'package:submission/ui/views/top_rated/bloc/top_rated_bloc.dart';

class MockTopRatedBloc extends MockBloc<TopRatedEvent, TopRatedState>
    implements TopRatedBloc {}

void main() {
  late MockTopRatedBloc mockBloc;

  setUp(() => mockBloc = MockTopRatedBloc());

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedBloc>(
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
    when(() => mockBloc.state).thenReturn(TopRatedLoading());
    // Act
    final progressBarFinder =
        find.byKey(const Key('top_rated_component_loading'));
    await widgetTester
        .pumpWidget(makeTestableWidget(const TopRatedComponents()));
    // Assert
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('''Should display Text with error message when error state''',
      (WidgetTester tester) async {
    // Arrange
    when(() => mockBloc.state).thenReturn(const TopRatedError('Error message'));
    // Act
    final textFinder = find.byKey(const Key('top_rated_component_error'));
    await tester.pumpWidget(makeTestableWidget(const TopRatedComponents()));
    // Assert
    expect(textFinder, findsOneWidget);
  });

  testWidgets('Should display ListView when state is success',
      (WidgetTester tester) async {
    // Arrange
    when(() => mockBloc.state).thenReturn(TopRatedHasData(tMovieList));
    // ActNowPlayingComponents
    final listViewFinder = find.byType(ListView);
    await tester.pumpWidget(makeTestableWidget(const TopRatedComponents()));
    // Assert
    expect(listViewFinder, findsOneWidget);
  });
}
