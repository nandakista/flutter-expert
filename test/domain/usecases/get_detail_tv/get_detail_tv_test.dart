import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:submission/domain/entities/tv_detail.dart';
import 'package:submission/domain/repositories/tv_repository.dart';
import 'package:submission/domain/usecases/get_detail_tv.dart';

import 'get_detail_tv_test.mocks.dart';

@GenerateMocks([TvRepository])
void main() {
  late GetDetailTv usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = GetDetailTv(repository: mockTvRepository);
  });

  test('''Should get Detail Tv and then 
  return TvDetail from the repository''', () async {
    const tTvId = 1;
    const tTvDetail = TvDetail();
    // Arrange
    when(mockTvRepository.getDetailTv(tTvId)).thenAnswer(
      (_) async => const Right(tTvDetail),
    );
    // Act
    final result = await usecase(tTvId);
    // Assert
    verify(mockTvRepository.getDetailTv(tTvId));
    expect(result, const Right(tTvDetail));
    verifyNoMoreInteractions(mockTvRepository);
  });
}
