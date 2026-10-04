import 'package:flutter/material.dart';
import '../widgets/admin_products_panel.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _selectedIndex = 0;

  // Below this width (phones), swap the fixed sidebar for a Drawer
  static const double _wideLayoutBreakpoint = 700;

  static const List<_NavItem> _navItems = [
    _NavItem('Dashboard', Icons.dashboard),
    _NavItem('Products', Icons.inventory_2),
    _NavItem('Users', Icons.people),
    _NavItem('Orders', Icons.receipt_long),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWide = constraints.maxWidth >= _wideLayoutBreakpoint;

        if (isWide) {
          return Scaffold(
            body: Row(
              children: [
                _buildSidebar(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: _buildContent(),
                  ),
                ),
              ],
            ),
          );
        }

        // Phone layout: AppBar + hamburger Drawer instead of a persistent sidebar
        return Scaffold(
          appBar: AppBar(
            title: const Text('BabyShopHub Admin'),
            backgroundColor: const Color(0xFF1B2559),
          ),
          drawer: Drawer(child: _buildSidebar()),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: _buildContent(),
          ),
        );
      },
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 220,
      color: const Color(0xFF1B2559),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 28),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'BabyShopHub\nAdmin',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 32),
            for (int i = 0; i < _navItems.length; i++)
              _sidebarTile(_navItems[i], i),
            const Spacer(),
            _sidebarTile(const _NavItem('Logout', Icons.logout), -1),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _sidebarTile(_NavItem item, int index) {
    final bool selected = index == _selectedIndex;
    return InkWell(
      onTap: () {
        if (index == -1) {
          // TODO: wire up to real logout once auth is in
          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        } else {
          setState(() => _selectedIndex = index);
        }
      },
      child: Container(
        color: selected ? Colors.white.withOpacity(0.1) : Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Icon(item.icon, color: Colors.white70, size: 20),
            const SizedBox(width: 12),
            Text(
              item.label,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (_selectedIndex) {
      case 0:
        return _buildOverview();
      case 1:
        return const AdminProductsPanel();
      case 2:
        return const _ComingSoon(title: 'User management');
      case 3:
        return const _ComingSoon(title: 'Order management');
      default:
        return _buildOverview();
    }
  }

  Widget _buildOverview() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Dashboard',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // Placeholder numbers — wire these to real queries once the DB is ready
          const Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _StatCard(label: 'Total Products', value: '124'),
              _StatCard(label: 'Total Users', value: '342'),
              _StatCard(label: 'Total Orders', value: '278'),
              _StatCard(label: 'Low Stock', value: '8'),
            ],
          ),
          const SizedBox(height: 32),

          const Text(
            'Top Products',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          const _SimpleListTile(title: 'Pampers Diapers', subtitle: '₦12,500 · 48 sold'),
          const _SimpleListTile(title: 'Baby Carrier', subtitle: '₦18,000 · 31 sold'),
          const _SimpleListTile(title: 'Feeding Bottle', subtitle: '₦3,500 · 27 sold'),
          const SizedBox(height: 32),

          const Text(
            'Recent Orders',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          const _SimpleListTile(title: '#BSH123456', subtitle: 'Nifemi Shotelu · Delivered'),
          const _SimpleListTile(title: '#BSH123455', subtitle: 'Tunde A. · Processing'),
          const _SimpleListTile(title: '#BSH123454', subtitle: 'Chioma K. · Shipped'),
        ],
      ),
    );
  }
}

class _NavItem {
  final String label;
  final IconData icon;
  const _NavItem(this.label, this.icon);
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;

  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}

class _SimpleListTile extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SimpleListTile({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: Text(
              subtitle,
              textAlign: TextAlign.end,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _ComingSoon extends StatelessWidget {
  final String title;
  const _ComingSoon({required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '$title — coming next',
        style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
      ),
    );
  }
}