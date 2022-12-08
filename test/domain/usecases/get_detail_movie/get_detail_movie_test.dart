import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:submission/domain/entities/movie_detail.dart';
import 'package:submission/domain/repositories/movie_repository.dart';
import 'package:submission/domain/usecases/get_detail_movie.dart';

import '../get_detail_movie/get_detail_movie_test.mocks.dart';

@GenerateMocks([MovieRepository])
void main() {
  late GetDetailMovie usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = GetDetailMovie(repository: mockMovieRepository);
  });

  test('''Should get MovieList from the repository''', () async {
    const tMovieId = 1;
    const tMovie = MovieDetail();
    // Arrange
    when(mockMovieRepository.getDetailMovie(tMovieId)).thenAnswer(
          (_) async => const Right(tMovie),
    );
    // Act
    final result = await usecase(tMovieId);
    // Assert
    verify(mockMovieRepository.getDetailMovie(tMovieId));
    expect(result, const Right(tMovie));
    verifyNoMoreInteractions(mockMovieRepository);
  });
}