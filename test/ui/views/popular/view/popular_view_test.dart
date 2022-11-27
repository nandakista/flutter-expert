import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:submission/core/constant/network_state.dart';
import 'package:submission/domain/entities/movie.dart';
import 'package:submission/ui/views/popular/popular_provider.dart';
import 'package:submission/ui/views/popular/popular_view.dart';

import 'popular_view_test.mocks.dart';

@GenerateMocks([PopularProvider])
void main() {
  late MockPopularProvider mockProvider;

  setUp(() => mockProvider = MockPopularProvider());

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
    return ChangeNotifierProvider<PopularProvider>.value(
      value: mockProvider,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('''Should display loading indicator when loading state''',
      (widgetTester) async {
    // Arrange
    when(mockProvider.state).thenReturn(RequestState.loading);
    // Act
    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);
    await widgetTester.pumpWidget(makeTestableWidget(const PopularView()));
    // Assert
    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('''Should display Text with error message when error state''',
      (WidgetTester tester) async {
    // Arrange
    when(mockProvider.state).thenReturn(RequestState.error);
    when(mockProvider.message).thenReturn('Error message');
    // Act
    final textFinder = find.byKey(const Key('error_message'));
    final centerFinder = find.byType(Center);
    await tester.pumpWidget(makeTestableWidget(const PopularView()));
    // Assert
    expect(textFinder, findsOneWidget);
    expect(centerFinder, findsOneWidget);
  });

  testWidgets('''Should display Text with empty message when empty state''',
      (WidgetTester tester) async {
    // Arrange
    when(mockProvider.state).thenReturn(RequestState.empty);
    when(mockProvider.data).thenReturn(<Movie>[]);
    when(mockProvider.message).thenReturn('Empty message');
    // Act
    final textFinder = find.byKey(const Key('empty_message'));
    final centerFinder = find.byType(Center);
    await tester.pumpWidget(makeTestableWidget(const PopularView()));
    // Assert
    expect(textFinder, findsOneWidget);
    expect(centerFinder, findsOneWidget);
  });

  testWidgets('Should display ListView when state is success',
      (WidgetTester tester) async {
    // Arrange
    when(mockProvider.state).thenReturn(RequestState.success);
    when(mockProvider.data).thenReturn(tMovieList);
    // Act
    final listViewFinder = find.byType(ListView);
    await tester.pumpWidget(makeTestableWidget(const PopularView()));
    // Assert
    expect(listViewFinder, findsOneWidget);
  });
}
