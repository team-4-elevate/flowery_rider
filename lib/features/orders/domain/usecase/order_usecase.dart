// features/orders/domain/usecase/order_usecase.dart

import 'package:flowery_rider/features/auth/data/datasources/auth_local_data_source/auth_local_data_source.dart';
import 'package:injectable/injectable.dart';

@injectable
class OdersUsecase {
  final AuthLocalDataSource _localDataSource;

  OdersUsecase(this._localDataSource);

  Future<String?> execute() async {
    return await _localDataSource.getDriverId();
  }
}
