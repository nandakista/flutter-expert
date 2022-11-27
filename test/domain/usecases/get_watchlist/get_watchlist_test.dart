import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:submission/domain/entities/movie.dart';
import 'package:submission/domain/repositories/movie_repository.dart';
import 'package:submission/domain/usecases/get_watchlist.dart';

import 'get_watchlist_test.mocks.dart';

@GenerateMocks([MovieRepository])
void main() {
  late GetWatchlist usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = GetWatchlist(repository: mockMovieRepository);
  });

  test('''Should get Watchlist Movie then
  return MovieList from the repository''', () async {
    final tMovieList = <Movie>[];

    // Arrange
    when(mockMovieRepository.getAllWatchlist()).thenAnswer(
          (_) async => Right(tMovieList),
    );
    // Act
    final result = await usecase();
    // Assert
    verify(mockMovieRepository.getAllWatchlist());
    expect(result, Right(tMovieList));
    verifyNoMoreInteractions(mockMovieRepository);
  });
}