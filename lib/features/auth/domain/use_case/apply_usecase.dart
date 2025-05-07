// features/auth/domain/use_case/apply_usecase.dart
import 'package:either_dart/either.dart';
import 'package:flowery_rider/features/auth/domain/entities/apply_entity.dart';
import '../repo/auth_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class ApplyUseCase {
  final AuthRepo _authRepo;

  ApplyUseCase(this._authRepo);

  Future<Either<Exception, bool>> call(ApplyEntity entity) async {
    return await _authRepo.apply(entity);
  }
}
