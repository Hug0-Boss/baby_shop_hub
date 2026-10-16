class AdminOrderSummary {
  final int id;
  final String orderNumber;
  final String status;
  final double total;
  final int itemCount;
  final DateTime createdAt;
  final String customerName;
  final String customerEmail;

  const AdminOrderSummary({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.total,
    required this.itemCount,
    required this.createdAt,
    required this.customerName,
    required this.customerEmail,
  });

  factory AdminOrderSummary.fromJson(Map<String, dynamic> json) {
    return AdminOrderSummary(
      id: json['id'] as int,
      orderNumber: json['orderNumber'] as String,
      status: json['status'] as String,
      total: (json['total'] as num).toDouble(),
      itemCount: json['itemCount'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      customerName: json['customerName'] as String,
      customerEmail: json['customerEmail'] as String,
    );
  }
}

class AdminOrderItem {
  final String productName;
  final String? size;
  final int quantity;
  final double unitPrice;
  final double lineTotal;

  const AdminOrderItem({
    required this.productName,
    this.size,
    required this.quantity,
    required this.unitPrice,
    required this.lineTotal,
  });

  factory AdminOrderItem.fromJson(Map<String, dynamic> json) {
    return AdminOrderItem(
      productName: json['productName'] as String,
      size: json['size'] as String?,
      quantity: json['quantity'] as int,
      unitPrice: (json['unitPrice'] as num).toDouble(),
      lineTotal: (json['lineTotal'] as num).toDouble(),
    );
  }
}

class AdminOrderDetail {
  final int id;
  final String orderNumber;
  final String status;
  final double subtotal;
  final double deliveryFee;
  final double total;
  final DateTime createdAt;
  final String customerName;
  final String customerEmail;
  final String? customerPhone;
  final String deliveryAddress;
  final String? deliveryPhone;
  final String? payment;
  final List<AdminOrderItem> items;

  const AdminOrderDetail({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
    required this.createdAt,
    required this.customerName,
    required this.customerEmail,
    this.customerPhone,
    required this.deliveryAddress,
    this.deliveryPhone,
    this.payment,
    required this.items,
  });

  factory AdminOrderDetail.fromJson(Map<String, dynamic> json) {
    return AdminOrderDetail(
      id: json['id'] as int,
      orderNumber: json['orderNumber'] as String,
      status: json['status'] as String,
      subtotal: (json['subtotal'] as num).toDouble(),
      deliveryFee: (json['deliveryFee'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      customerName: json['customerName'] as String,
      customerEmail: json['customerEmail'] as String,
      customerPhone: json['customerPhone'] as String?,
      deliveryAddress: json['deliveryAddress'] as String,
      deliveryPhone: json['deliveryPhone'] as String?,
      payment: json['payment'] as String?,
      items: (json['items'] as List<dynamic>)
          .map((j) => AdminOrderItem.fromJson(j as Map<String, dynamic>))
          .toList(),
    );
  }
}

class AdminUser {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String role;
  final DateTime createdAt;
  final int orderCount;

  const AdminUser({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    required this.role,
    required this.createdAt,
    required this.orderCount,
  });

  bool get isAdmin => role == 'Admin';

  factory AdminUser.fromJson(Map<String, dynamic> json) {
    return AdminUser(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      role: json['role'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      orderCount: json['orderCount'] as int,
    );
  }
}