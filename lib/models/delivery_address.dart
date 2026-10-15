/// A saved delivery address used on the Checkout screen.
class DeliveryAddress {
  final String id;
  final String fullName;
  final String phone;
  final String address;

  const DeliveryAddress({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.address,
  });

  DeliveryAddress copyWith({String? fullName, String? phone, String? address}) {
    return DeliveryAddress(
      id: id,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      address: address ?? this.address,
    );
  }
}