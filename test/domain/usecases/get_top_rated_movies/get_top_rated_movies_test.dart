import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:submission/domain/entities/movie.dart';
import 'package:submission/domain/repositories/movie_repository.dart';
import 'package:submission/domain/usecases/get_top_rated_movies.dart';

import '../get_top_rated_movies/get_top_rated_movies_test.mocks.dart';

@GenerateMocks([MovieRepository])
void main() {
  late GetTopRatedMovies usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = GetTopRatedMovies(repository: mockMovieRepository);
  });

  test('''Should get Top Rated Movie then
  return MovieList from the repository''', () async {
    final tMovieList = <Movie>[];

    // Arrange
    when(mockMovieRepository.getTopRatedMovies()).thenAnswer(
      (_) async => Right(tMovieList),
    );
    // Act
    final result = await usecase();
    // Assert
    verify(mockMovieRepository.getTopRatedMovies());
    expect(result, Right(tMovieList));
    verifyNoMoreInteractions(mockMovieRepository);
  });
}
