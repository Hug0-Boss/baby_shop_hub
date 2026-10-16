import 'package:flutter/material.dart';
import '../models/admin_models.dart';
import '../services/admin_service.dart';
import '../utils/format.dart';
import '../utils/order_status.dart';

class AdminOrdersPanel extends StatefulWidget {
  const AdminOrdersPanel({super.key});

  @override
  State<AdminOrdersPanel> createState() => _AdminOrdersPanelState();
}

class _AdminOrdersPanelState extends State<AdminOrdersPanel> {
  final _service = AdminService();

  List<AdminOrderSummary> _orders = [];
  String? _filter; // null means "All"
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final orders = await _service.fetchOrders(status: _filter);
      if (!mounted) return;
      setState(() {
        _orders = orders;
        _loading = false;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.message;
        _loading = false;
      });
    }
  }

  Future<void> _openDetails(AdminOrderSummary order) async {
    final changed = await showDialog<bool>(
      context: context,
      builder: (_) => _OrderDetailsDialog(orderId: order.id, service: _service),
    );
    if (!mounted) return;
    if (changed == true) _load(); // status was updated, so refresh the list
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Orders',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            IconButton(
              tooltip: 'Refresh',
              onPressed: _loading ? null : _load,
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _filterChip('All', null),
              for (final status in OrderStatus.all)
                _filterChip(OrderStatus.label(status), status),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Expanded(child: _buildBody()),
      ],
    );
  }

  Widget _filterChip(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: _filter == value,
        onSelected: (_) {
          setState(() => _filter = value);
          _load();
        },
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_error!, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            OutlinedButton(onPressed: _load, child: const Text('Retry')),
          ],
        ),
      );
    }
    if (_orders.isEmpty) {
      return Center(
        child: Text(_filter == null
            ? 'No orders yet.'
            : 'No ${OrderStatus.label(_filter!).toLowerCase()} orders.'),
      );
    }
    return ListView.separated(
      itemCount: _orders.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) => _orderTile(_orders[index]),
    );
  }

  Widget _orderTile(AdminOrderSummary order) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => _openDetails(order),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.orderNumber,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${order.customerName} · ${formatDate(order.createdAt)}',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formatNaira(order.total),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                _StatusChip(status: order.status),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = OrderStatus.color(status);
    return Container(
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        OrderStatus.label(status),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

/// Shows one order in full and lets the admin change its status.
class _OrderDetailsDialog extends StatefulWidget {
  final int orderId;
  final AdminService service;

  const _OrderDetailsDialog({required this.orderId, required this.service});

  @override
  State<_OrderDetailsDialog> createState() => _OrderDetailsDialogState();
}

class _OrderDetailsDialogState extends State<_OrderDetailsDialog> {
  AdminOrderDetail? _order;
  String? _selectedStatus;
  String? _error;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final order = await widget.service.fetchOrder(widget.orderId);
      if (!mounted) return;
      setState(() {
        _order = order;
        _selectedStatus = order.status;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _error = e.message);
    }
  }

  Future<void> _saveStatus() async {
    final order = _order!;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await widget.service.updateOrderStatus(order.id, _selectedStatus!);
      if (!mounted) return;
      Navigator.pop(context, true); // tells the list to refresh
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _error = e.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final order = _order;
    return AlertDialog(
      title: Text(order?.orderNumber ?? 'Order'),
      content: SizedBox(
        width: double.maxFinite,
        child: _buildContent(order),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.pop(context, false),
          child: const Text('Close'),
        ),
        if (order != null)
          ElevatedButton(
            onPressed: (_saving || _selectedStatus == order.status)
                ? null
                : _saveStatus,
            child: Text(_saving ? 'Saving...' : 'Update status'),
          ),
      ],
    );
  }

  Widget _buildContent(AdminOrderDetail? order) {
    if (order == null) {
      if (_error != null) return Text(_error!);
      return const SizedBox(
        height: 120,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _section('Customer', [
            order.customerName,
            order.customerEmail,
            if (order.customerPhone != null) order.customerPhone!,
          ]),
          _section('Deliver to', [
            order.deliveryAddress,
            if (order.deliveryPhone != null) order.deliveryPhone!,
          ]),
          _section('Payment', [order.payment ?? 'Not specified']),
          _section('Placed on', [formatDate(order.createdAt)]),
          Text('Items',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
          const SizedBox(height: 4),
          for (final item in order.items)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  Expanded(child: Text(_itemLine(item))),
                  const SizedBox(width: 8),
                  Text(formatNaira(item.lineTotal)),
                ],
              ),
            ),
          const Divider(),
          _totalRow('Subtotal', order.subtotal),
          _totalRow('Delivery', order.deliveryFee),
          _totalRow('Total', order.total, bold: true),
          const SizedBox(height: 16),
          Text('Status',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
          DropdownButton<String>(
            value: _selectedStatus,
            isExpanded: true,
            items: OrderStatus.all
                .map((s) => DropdownMenuItem(
              value: s,
              child: Text(OrderStatus.label(s)),
            ))
                .toList(),
            onChanged: _saving
                ? null
                : (value) => setState(() => _selectedStatus = value),
          ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(_error!, style: const TextStyle(color: Colors.red)),
            ),
        ],
      ),
    );
  }

  String _itemLine(AdminOrderItem item) {
    final size = item.size != null ? ' (${item.size})' : '';
    return '${item.quantity} × ${item.productName}$size';
  }

  Widget _section(String title, List<String> lines) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
          const SizedBox(height: 2),
          for (final line in lines) Text(line),
        ],
      ),
    );
  }

  Widget _totalRow(String label, double amount, {bool bold = false}) {
    final style = TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(formatNaira(amount), style: style),
        ],
      ),
    );
  }
}