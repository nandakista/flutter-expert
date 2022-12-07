import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:submission/domain/entities/genre.dart';
import 'package:submission/domain/entities/movie.dart';
import 'package:submission/domain/entities/movie_detail.dart';
import 'package:submission/ui/views/detail/bloc/detail_bloc.dart';
import 'package:submission/ui/views/detail/components/detail_content_view.dart';
import 'package:submission/ui/views/detail/detail_view.dart';

class MockDetailBloc extends MockBloc<DetailEvent, DetailState>
    implements DetailBloc {}

void main() {
  late MockDetailBloc mockDetailBloc;

  setUp(() => mockDetailBloc = MockDetailBloc());

  const tMovieId = 1;
  const tMovieDetail = MovieDetail(
    adult: false,
    backdropPath: '/bQXAqRx2Fgc46uCVWgoPz5L5Dtr.jpg',
    genres: [
      Genre(id: 28, name: 'Action'),
    ],
    homepage: 'https://www.dc.com/BlackAdam',
    id: 436270,
    originalTitle: 'Black Adam',
    overview: 'Some Overview',
    posterPath: '/pFlaoHTZeyNkG83vxsAJiGzfSsa.jpg',
    releaseDate: '2022-10-19',
    runtime: 125,
    title: 'Black Adam',
    voteAverage: 6.8,
    voteCount: 1284,
    budget: 200000000,
    imdbId: 'tt6443346',
    originalLanguage: '',
    popularity: 23828.993,
    revenue: 351000000,
    status: 'Released',
    tagline: 'The world needed a hero. It got Black Adam.',
    video: false,
  );
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
    return BlocProvider<DetailBloc>(
      create: (_) => mockDetailBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('''Should display loading indicator when loading state''',
      (widgetTester) async {
    // Arrange
    when(() => mockDetailBloc.state).thenReturn(DetailLoading());
    // Act
    final progressBarFinder = find.byType(CircularProgressIndicator);
    await widgetTester
        .pumpWidget(makeTestableWidget(const DetailView(id: tMovieId)));
    // Assert
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets(
      '''Should display Text with error message when detail state is error''',
      (WidgetTester tester) async {
    // Arrange
    when(() => mockDetailBloc.state)
        .thenReturn(const DetailError('Error message'));
    // Act
    final textFinder = find.byKey(const Key('error_message'));
    await tester.pumpWidget(makeTestableWidget(const DetailView(id: tMovieId)));
    // Assert
    expect(textFinder, findsOneWidget);
  });

  testWidgets(
      'Should display Detail Content and Recommended Movie when '
      'detail state is [HasData] and recommendation state is not empty',
      (WidgetTester tester) async {
    // Arrange
    when(() => mockDetailBloc.state).thenReturn(DetailHasData(
      detail: tMovieDetail,
      recommendedMovie: tMovieList,
      hasAddedToWatchList: false,
    ));
    // Act
    final detailContentFinder = find.byType(DetailContent);
    final recommendedListViewFinder = find.byType(ListView);
    await tester.pumpWidget(makeTestableWidget(const DetailView(id: tMovieId)));
    // Assert
    expect(detailContentFinder, findsOneWidget);
    expect(recommendedListViewFinder, findsOneWidget);
  });

  testWidgets(
      'Should display Detail Content and Empty Message in Recommend Movie '
      'when state is [HasData] and recommendation movie is empty',
      (WidgetTester tester) async {
    // Arrange
    when(() => mockDetailBloc.state).thenReturn(const DetailHasData(
        detail: tMovieDetail,
        recommendedMovie: [],
        hasAddedToWatchList: false));
    // Act
    final detailContentFinder = find.byType(DetailContent);
    final recommendedEmptyMsgKeyFinder = find.byKey(
      const Key('empty_recommend_message'),
    );
    final recommendedEmptyMsgFinder = find.text('No Recommendations');
    await tester.pumpWidget(makeTestableWidget(const DetailView(id: tMovieId)));
    // Assert
    expect(detailContentFinder, findsOneWidget);
    expect(recommendedEmptyMsgFinder, findsOneWidget);
    expect(recommendedEmptyMsgKeyFinder, findsOneWidget);
  });
}
