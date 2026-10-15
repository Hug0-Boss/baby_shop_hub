import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

const Color _navy = Color(0xFF1E2A5E);
const Color _pink = Color(0xFFEC4899);

// Delivery location (sample: Lekki Phase 1, Lagos).
// Replace with the real coordinates of the customer's address later.
const LatLng _deliveryLocation = LatLng(6.4474, 3.4723);

// The map itself. Used in the small preview and the full-screen page.
Widget _buildMap({required bool interactive}) {
  return FlutterMap(
    options: MapOptions(
      initialCenter: _deliveryLocation,
      initialZoom: 15,
      interactionOptions: InteractionOptions(
        flags: interactive ? InteractiveFlag.all : InteractiveFlag.none,
      ),
    ),
    children: [
      TileLayer(
        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        userAgentPackageName: 'com.example.baby_shop_hub',
      ),
      const MarkerLayer(
        markers: [
          Marker(
            point: _deliveryLocation,
            width: 44,
            height: 44,
            alignment: Alignment.topCenter,
            child: Icon(Icons.location_pin, color: _pink, size: 44),
          ),
        ],
      ),
    ],
  );
}

// Full-screen map that opens when "View on Map" is tapped
class _FullMapScreen extends StatelessWidget {
  const _FullMapScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: _navy,
        title: const Text(
          'Delivery Location',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: _buildMap(interactive: true),
    );
  }
}

class TrackOrderScreen extends StatelessWidget {
  final String orderId;
  final String date;

  // 0 = Confirmed, 1 = Shipped, 2 = Out for Delivery, 3 = Delivered
  final int currentStep;

  const TrackOrderScreen({
    super.key,
    this.orderId = '#BSH123456',
    this.date = 'May 10, 2025',
    this.currentStep = 2,
  });

  static const List<String> _labels = [
    'Confirmed',
    'Shipped',
    'Out for Delivery',
    'Delivered',
  ];

  static const List<String> _dates = [
    'May 10',
    'May 11',
    'May 12',
    'May 13',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: _navy,
        title: const Text(
          'Track Order',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Order number and date
          Text(
            'Order $orderId',
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: _navy),
          ),
          const SizedBox(height: 4),
          Text(
            'Placed on $date',
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 20),

          // Progress steps
          _card(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(_labels.length, (i) => _step(i)),
            ),
          ),
          const SizedBox(height: 16),

          // Delivery partner
          _card(
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0E7FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.local_shipping, color: _navy),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Delivery Partner',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const Text(
                        'Swift Logistics',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: _navy),
                      ),
                      Text(
                        'Tracking Number: SL123456789',
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    // Add a phone call here later
                  },
                  icon: const Icon(Icons.call, size: 16),
                  label: const Text('Call'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _navy,
                    side: const BorderSide(color: _navy),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Delivery address
          _card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Delivery Address',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.location_on, color: _pink),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nifemi Shetealu',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: _navy),
                          ),
                          SizedBox(height: 2),
                          Text('12 Freedom Street, Lekki Phase 1, Lagos'),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Small map preview (tap "View on Map" for the full map)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    height: 160,
                    width: double.infinity,
                    child: Stack(
                      children: [
                        _buildMap(interactive: false),
                        Positioned(
                          bottom: 10,
                          right: 10,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const _FullMapScreen(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _navy,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text('View on Map'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // White rounded box used for each section
  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: child,
    );
  }

  // One step: circle, lines on each side, label and date
  Widget _step(int i) {
    final done = i <= currentStep;
    final isFirst = i == 0;
    final isLast = i == _labels.length - 1;

    return Expanded(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 3,
                  color: isFirst
                      ? Colors.transparent
                      : (done ? _navy : Colors.grey.shade300),
                ),
              ),
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: done ? _navy : Colors.white,
                  border: Border.all(
                    color: done ? _navy : Colors.grey.shade300,
                    width: 2,
                  ),
                ),
                child: done
                    ? const Icon(Icons.check, size: 16, color: Colors.white)
                    : null,
              ),
              Expanded(
                child: Container(
                  height: 3,
                  color: isLast
                      ? Colors.transparent
                      : (i < currentStep ? _navy : Colors.grey.shade300),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _labels[i],
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: done ? _navy : Colors.grey,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            _dates[i],
            style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}
