import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:submission/core/constant/network_state.dart';
import 'package:submission/domain/entities/genre.dart';
import 'package:submission/domain/entities/movie.dart';
import 'package:submission/domain/entities/movie_detail.dart';
import 'package:submission/ui/views/detail/components/detail_content_view.dart';
import 'package:submission/ui/views/detail/components/recommended_component.dart';
import 'package:submission/ui/views/detail/detail_provider.dart';
import 'package:submission/ui/views/detail/detail_view.dart';

import 'detail_view_test.mocks.dart';

@GenerateMocks([DetailProvider])
void main() {
  late MockDetailProvider mockProvider;

  setUp(() => mockProvider = MockDetailProvider());

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
    return ChangeNotifierProvider<DetailProvider>.value(
      value: mockProvider,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('''Should display loading indicator when loading state''',
      (widgetTester) async {
    // Arrange
    when(mockProvider.detailState).thenReturn(RequestState.loading);
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
    when(mockProvider.detailState).thenReturn(RequestState.error);
    when(mockProvider.message).thenReturn('Error message');
    // Act
    final textFinder = find.byKey(const Key('error_message'));
    await tester.pumpWidget(makeTestableWidget(const DetailView(id: tMovieId)));
    // Assert
    expect(textFinder, findsOneWidget);
  });

  testWidgets(
      '''Should display Text with error message when recommended state is error''',
      (WidgetTester tester) async {
    // Arrange
    when(mockProvider.recommendationState).thenReturn(RequestState.error);
    when(mockProvider.message).thenReturn('Error message');
    // Act
    final textFinder = find.byKey(const Key('error_recommend_message'));
    await tester.pumpWidget(makeTestableWidget(const RecommendedComponent()));
    // Assert
    expect(textFinder, findsOneWidget);
  });

  testWidgets(
      'Should display Detail Content and Recommended Movie when '
      'detail state is loaded and recommendation state is loaded',
      (WidgetTester tester) async {
    // Arrange
    when(mockProvider.detailState).thenReturn(RequestState.success);
    when(mockProvider.detailMovie).thenReturn(tMovieDetail);
    when(mockProvider.recommendationState).thenReturn(RequestState.success);
    when(mockProvider.recommendedMovies).thenReturn(tMovieList);
    when(mockProvider.hasAddedToWatchlist).thenReturn(false);
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
      'when detail state is loaded and recommendation state is empty',
      (WidgetTester tester) async {
    // Arrange
    when(mockProvider.detailState).thenReturn(RequestState.success);
    when(mockProvider.detailMovie).thenReturn(tMovieDetail);
    when(mockProvider.recommendationState).thenReturn(RequestState.empty);
    when(mockProvider.recommendedMovies).thenReturn(List<Movie>.empty());
    when(mockProvider.hasAddedToWatchlist).thenReturn(false);
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
