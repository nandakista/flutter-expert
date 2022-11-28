import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:submission/domain/entities/tv.dart';
import 'package:submission/domain/repositories/tv_repository.dart';
import 'package:submission/domain/usecases/get_recommended_tv.dart';

import 'get_recommended_tv_test.mocks.dart';

@GenerateMocks([TvRepository])
void main() {
  late GetRecommendedTv usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = GetRecommendedTv(repository: mockTvRepository);
  });

  test('''Should get Recommended Tv and then 
  return TvList from the repository''', () async {
    const tTvId = 1;
    final tTvList = <Tv>[];
    // Arrange
    when(mockTvRepository.getRecommendedTv(tTvId)).thenAnswer(
      (_) async => Right(tTvList),
    );
    // Act
    final result = await usecase(tTvId);
    // Assert
    verify(mockTvRepository.getRecommendedTv(tTvId));
    expect(result, Right(tTvList));
    verifyNoMoreInteractions(mockTvRepository);
  });
}
