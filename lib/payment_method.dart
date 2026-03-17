enum PaymentMethod { cod, momo }

extension PaymentMethodX on PaymentMethod {
  String get label {
    switch (this) {
      case PaymentMethod.cod:
        return 'COD (Thanh toán khi nhận hàng)';
      case PaymentMethod.momo:
        return 'Momo';
    }
  }
}
