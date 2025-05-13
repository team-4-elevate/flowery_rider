enum OrderStatusEnum {
  rejected,
  pending,
  accepted,
  pickedUp,
  outForDelivery,
  arrived,
  delivered,
}

extension OrderStatusExtension on OrderStatusEnum {
  String get name {
    switch (this) {
      case OrderStatusEnum.rejected:
        return 'rejected';
      case OrderStatusEnum.pending:
        return 'pending';
      case OrderStatusEnum.accepted:
        return 'accepted';
      case OrderStatusEnum.pickedUp:
        return 'picked_up';
      case OrderStatusEnum.outForDelivery:
        return 'out_for_delivery';
      case OrderStatusEnum.delivered:
        return 'delivered';
      case OrderStatusEnum.arrived:
        return 'arrived';
    }
  }
}

extension ToEnum on String {
  OrderStatusEnum toOrderStatusEnum() {
    switch (this) {
      case 'pending':
        return OrderStatusEnum.pending;
      case 'accepted':
        return OrderStatusEnum.accepted;
      case 'picked_up':
        return OrderStatusEnum.pickedUp;
      case 'delivered':
        return OrderStatusEnum.delivered;
      case 'out_for_delivery':
        return OrderStatusEnum.outForDelivery;
      case 'rejected':
        return OrderStatusEnum.rejected;
      case 'arrived':
        return OrderStatusEnum.arrived;
      default:
        return OrderStatusEnum.pending;
    }
  }
}
