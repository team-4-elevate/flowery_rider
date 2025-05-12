// features/Home_layout/domain/use_case/home_usecase.dart

import 'package:either_dart/either.dart';
import 'package:flowery_rider/core/error_handling/exceptions/api_exception.dart';
import 'package:flowery_rider/features/Home_layout/domain/entities/order_entity.dart';
import 'package:flowery_rider/features/Home_layout/domain/repo/home_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class HomeUseCase {
  final HomeRepository _homeRepository;

  HomeUseCase(this._homeRepository);

  Future<Either<ApiException, List<OrderEntity>>> call() async {
    return await _homeRepository.getPendingOrders();
  }
}
