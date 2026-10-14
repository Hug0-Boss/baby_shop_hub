import 'package:flutter/material.dart';
import 'track_order_screen.dart';

const Color _navy = Color(0xFF1E2A5E);
const Color _pink = Color(0xFFEC4899);

// One order (sample data - replace with real data later)
class Order {
  final String id;
  final String date;
  final String price;
  final String status; // Processing, Shipped or Delivered
  final IconData icon;

  const Order({
    required this.id,
    required this.date,
    required this.price,
    required this.status,
    required this.icon,
  });
}

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  final List<String> _filters = ['All', 'Processing', 'Shipped', 'Delivered'];
  String _selected = 'All';

  final List<Order> _orders = const [
    Order(
        id: '#BSH123456',
        date: 'May 10, 2025',
        price: '₦36,000',
        status: 'Delivered',
        icon: Icons.child_care),
    Order(
        id: '#BSH123455',
        date: 'May 8, 2025',
        price: '₦16,000',
        status: 'Shipped',
        icon: Icons.checkroom),
    Order(
        id: '#BSH123454',
        date: 'May 5, 2025',
        price: '₦12,000',
        status: 'Processing',
        icon: Icons.local_drink),
    Order(
        id: '#BSH123453',
        date: 'May 2, 2025',
        price: '₦20,000',
        status: 'Delivered',
        icon: Icons.toys),
  ];

  // Colors for each status badge
  Color _statusColor(String status) {
    switch (status) {
      case 'Delivered':
        return const Color(0xFF16A34A);
      case 'Shipped':
        return const Color(0xFF2563EB);
      default:
        return const Color(0xFFF59E0B);
    }
  }

  Color _statusBg(String status) {
    switch (status) {
      case 'Delivered':
        return const Color(0xFFDCFCE7);
      case 'Shipped':
        return const Color(0xFFDBEAFE);
      default:
        return const Color(0xFFFEF3C7);
    }
  }

  // Which step of the tracker is active for each status
  int _stepFor(String status) {
    switch (status) {
      case 'Delivered':
        return 3;
      case 'Shipped':
        return 1;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final shown = _selected == 'All'
        ? _orders
        : _orders.where((o) => o.status == _selected).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: _navy,
        title: const Text(
          'My Orders',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Filter chips
          SizedBox(
            height: 56,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              children: _filters.map((f) {
                final active = f == _selected;
                return GestureDetector(
                  onTap: () => setState(() => _selected = f),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                    decoration: BoxDecoration(
                      color: active ? _pink : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: active ? _pink : Colors.grey.shade300),
                    ),
                    child: Text(
                      f,
                      style: TextStyle(
                        color: active ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // List of orders
          Expanded(
            child: shown.isEmpty
                ? const Center(child: Text('No orders here yet'))
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: shown.length,
              itemBuilder: (context, index) => _orderCard(shown[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _orderCard(Order order) {
    return GestureDetector(
      onTap: () {
        // Open the Track Order screen for this order
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TrackOrderScreen(
              orderId: order.id,
              date: order.date,
              currentStep: _stepFor(order.status),
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            // Product picture (icon for now - swap for Image.asset later)
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFFCE7F3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(order.icon, color: _pink, size: 28),
            ),
            const SizedBox(width: 12),

            // Order number and date
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order ${order.id}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: _navy),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    order.date,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                ],
              ),
            ),

            // Price and status badge
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  order.price,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: _navy),
                ),
                const SizedBox(height: 6),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: _statusBg(order.status),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    order.status,
                    style: TextStyle(
                      color: _statusColor(order.status),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
