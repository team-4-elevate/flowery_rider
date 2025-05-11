import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'order_details_state.dart';

@injectable
class OrderDetailsCubit extends Cubit<OrderDetailsState>{
  OrderDetailsCubit() : super(OrderDetailsState());

}