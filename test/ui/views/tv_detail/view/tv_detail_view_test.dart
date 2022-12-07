import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:submission/domain/entities/genre.dart';
import 'package:submission/domain/entities/season.dart';
import 'package:submission/domain/entities/tv.dart';
import 'package:submission/domain/entities/tv_detail.dart';
import 'package:submission/ui/views/detail/components/detail_content_view.dart';
import 'package:submission/ui/views/tv_detail/bloc/tv_detail_bloc.dart';
import 'package:submission/ui/views/tv_detail/tv_detail_view.dart';

class MockTvDetailBloc extends MockBloc<TvDetailEvent, TvDetailState>
    implements TvDetailBloc {}

void main() {
  late MockTvDetailBloc mockBloc;

  setUp(() => mockBloc = MockTvDetailBloc());

  const tTvId = 1;
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

  const tTvDetail = TvDetail(
    adult: false,
    backdropPath: "/url.jpg",
    episodeRunTime: [39],
    firstAirDate: "2021-11-06",
    genres: [
      Genre(id: 16, name: "Animation"),
      Genre(id: 10765, name: "Sci-Fi & Fantasy"),
    ],
    homepage: "https://arcane.com",
    id: 94605,
    inProduction: true,
    languages: ["am", "ar", "en", "hz"],
    lastAirDate: "2021-11-20",
    name: "Arcane",
    nextEpisodeToAir: null,
    numberOfEpisodes: 9,
    numberOfSeasons: 2,
    originCountry: ["US"],
    originalLanguage: "en",
    originalName: "Arcane",
    overview: "overview",
    popularity: 95.866,
    posterPath: "/url.jpg",
    seasons: [
      Season(
          airDate: "2021-11-06",
          episodeCount: 9,
          id: 134187,
          name: "Season 1",
          overview: "",
          posterPath: "/url.jpg",
          seasonNumber: 1)
    ],
    status: "Returning Series",
    tagline: "",
    type: "Scripted",
    voteAverage: 8.746,
    voteCount: 2704,
  );

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<TvDetailBloc>(
      create: (_) => mockBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('''Should display loading indicator when loading state''',
      (widgetTester) async {
    // Arrange
    when(() => mockBloc.state).thenReturn(TvDetailLoading());
    // Act
    final progressBarFinder = find.byType(CircularProgressIndicator);
    await widgetTester
        .pumpWidget(makeTestableWidget(const TvDetailView(id: tTvId)));
    // Assert
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets(
      '''Should display Text with error message when detail state is error''',
      (WidgetTester tester) async {
    // Arrange
    when(() => mockBloc.state).thenReturn(const TvDetailError('Error message'));
    // Act
    final textFinder = find.byKey(const Key('error_message'));
    await tester.pumpWidget(makeTestableWidget(const TvDetailView(id: tTvId)));
    // Assert
    expect(textFinder, findsOneWidget);
  });

  // testWidgets(
  //     '''Should display Text with error message when recommended state is error''',
  //     (WidgetTester tester) async {
  //   // Arrange
  //   when(mockProvider.recommendationState).thenReturn(RequestState.error);
  //   when(mockProvider.message).thenReturn('Error message');
  //   // Act
  //   final textFinder = find.byKey(const Key('error_recommend_message'));
  //   await tester.pumpWidget(makeTestableWidget(const RecommendedTvComponent()));
  //   // Assert
  //   expect(textFinder, findsOneWidget);
  // });

  testWidgets(
      'Should display Detail Content and Recommended Tv when '
      'detail state is loaded and recommendation state is success',
      (WidgetTester tester) async {
    // Arrange
    when(() => mockBloc.state).thenReturn(TvDetailHasData(
        detail: tTvDetail, recommendedTv: tTvList, hasAddedToWatchList: false));
    // Act
    final detailContentFinder = find.byType(DetailContent);
    final recommendedListViewFinder = find.byType(ListView);
    await tester.pumpWidget(makeTestableWidget(const TvDetailView(id: tTvId)));
    // Assert
    expect(detailContentFinder, findsOneWidget);
    expect(recommendedListViewFinder, findsOneWidget);
  });

  testWidgets(
      'Should display Detail Content and Empty Message in Recommend Tv '
      'when detail state is loaded and recommendation state is empty',
      (WidgetTester tester) async {
    // Arrange
    when(() => mockBloc.state).thenReturn(const TvDetailHasData(
      detail: tTvDetail,
      recommendedTv: [],
      hasAddedToWatchList: false,
    ));
    // Act
    final detailContentFinder = find.byType(DetailContent);
    final recommendedEmptyMsgKeyFinder = find.byKey(
      const Key('empty_recommend_message'),
    );
    final recommendedEmptyMsgFinder = find.text('No Recommendations');
    await tester.pumpWidget(makeTestableWidget(const TvDetailView(id: tTvId)));
    // Assert
    expect(detailContentFinder, findsOneWidget);
    expect(recommendedEmptyMsgFinder, findsOneWidget);
    expect(recommendedEmptyMsgKeyFinder, findsOneWidget);
  });
}
