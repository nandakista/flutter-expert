import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:submission/domain/entities/movie.dart';
import 'package:submission/ui/views/home/components/popular_components.dart';
import 'package:submission/ui/views/popular/bloc/popular_bloc.dart';

class MockPopularBloc extends MockBloc<PopularEvent, PopularState>
    implements PopularBloc {}

void main() {
  late MockPopularBloc mockBloc;

  setUp(() => mockBloc = MockPopularBloc());

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<PopularBloc>(
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
    when(() => mockBloc.state).thenReturn(PopularLoading());
    // Act
    final progressBarFinder =
        find.byKey(const Key('popular_component_loading'));
    await widgetTester
        .pumpWidget(makeTestableWidget(const PopularComponents()));
    // Assert
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('''Should display Text with error message when error state''',
      (WidgetTester tester) async {
    // Arrange
    when(() => mockBloc.state).thenReturn(const PopularError('Error message'));
    // Act
    final textFinder = find.byKey(const Key('popular_component_error'));
    final centerFinder = find.byType(Center);
    await tester.pumpWidget(makeTestableWidget(const PopularComponents()));
    // Assert
    expect(textFinder, findsOneWidget);
    expect(centerFinder, findsOneWidget);
  });

  testWidgets('Should display ListView when state is success',
      (WidgetTester tester) async {
    // Arrange
    when(() => mockBloc.state).thenReturn(PopularHasData(tMovieList));
    // Act
    final listViewFinder = find.byType(ListView);
    final listKeyFinder = find.byKey(const Key('list_popular_component'));
    await tester.pumpWidget(makeTestableWidget(const PopularComponents()));
    // Assert
    expect(listKeyFinder, findsOneWidget);
    expect(listViewFinder, findsOneWidget);
  });
}
