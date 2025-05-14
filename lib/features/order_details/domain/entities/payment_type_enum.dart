enum PaymentTypeEnum {
  cash,
  card,
}

extension PaymentTypeExtension on PaymentTypeEnum {
  String get name {
    switch (this) {
      case PaymentTypeEnum.cash:
        return 'cash';
      case PaymentTypeEnum.card:
        return 'card';
    }
  }
}

extension ToEnum on String {
  PaymentTypeEnum? toPaymentEnum() {
    switch (this) {
      case 'cash':
        return PaymentTypeEnum.cash;
      case 'card':
        return PaymentTypeEnum.card;
    }
    return null;
  }
}
