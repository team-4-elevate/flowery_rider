import 'package:flowery_rider/features/order_details/domain/entities/order_status_enum.dart';
import 'package:flowery_rider/features/order_details/presentation/cubit/order_details_cubit.dart';
import 'package:flowery_rider/features/order_details/presentation/cubit/order_details_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderDetailsPage extends StatefulWidget {
  const OrderDetailsPage({super.key});

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Order Details')),
      // body: Padding(
      //     padding: const EdgeInsets.all(16.0),
      //   child: Column(
      //     children: [
      //       Expanded(
      //         child: SingleChildScrollView(
      //           child: Column(
      //             children: [
      //               OrderDetailsStepsWidget(index: ),
      //               OrderDetailsStatusWidget(
      //                 status:
      //                 orderId:
      //                 createdAt:
      //               ),
      //               OrderDetailsAddressWidget(title: ,address :),
      //               OrderDetailsAddressWidget(title: ,address:),
      //               OrderDetailsFullOrderWidget(order: ),
      //             ],
      //           ),
      //         ),
      //       ),
      //       BlocListener<OrderDetailsCubit,OrderDetailsState>(
      //         listener: (context, state) =>
      //          ElevatedButton(onPressed: () {
      //         }, child: Text(_setButtonTitle(state.status))),
      //       )
      //     ],
      //   ),
      // )
    );
  }
}
