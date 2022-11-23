import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:submission/domain/entities/movie.dart';
import 'package:submission/domain/repositories/movie_repository.dart';
import 'package:submission/domain/usecases/get_recommended_movies.dart';

import '../get_recommended_movies/get_recommended_movies_test.mocks.dart';

@GenerateMocks([MovieRepository])
void main() {
  late GetRecommendedMovies usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = GetRecommendedMovies(repository: mockMovieRepository);
  });

  test('''Should get Recommended Movie and then 
  return MovieList from the repository''', () async {
    const tMovieId = 1;
    final tMovieList = <Movie>[];

    // Arrange
    when(mockMovieRepository.getRecommendedMovies(tMovieId)).thenAnswer(
      (_) async => Right(tMovieList),
    );
    // Act
    final result = await usecase(tMovieId);
    // Assert
    verify(mockMovieRepository.getRecommendedMovies(tMovieId));
    expect(result, Right(tMovieList));
    verifyNoMoreInteractions(mockMovieRepository);
  });
}
