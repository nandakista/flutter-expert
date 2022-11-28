import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:submission/domain/entities/tv.dart';
import 'package:submission/domain/repositories/tv_repository.dart';
import 'package:submission/domain/usecases/get_popular_tv.dart';

import 'get_popular_tv_test.mocks.dart';

@GenerateMocks([TvRepository])
void main() {
  late GetPopularTv usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = GetPopularTv(repository: mockTvRepository);
  });

  test('''Should get Popular and then 
  return TvList from the repository''', () async {
    final tTvList = <Tv>[];
    // Arrange
    when(mockTvRepository.getPopularTv()).thenAnswer(
      (_) async => Right(tTvList),
    );
    // Act
    final result = await usecase();
    // Assert
    verify(mockTvRepository.getPopularTv());
    expect(result, Right(tTvList));
    verifyNoMoreInteractions(mockTvRepository);
  });
}
