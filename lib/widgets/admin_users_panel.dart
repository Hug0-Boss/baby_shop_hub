import 'package:flutter/material.dart';
import '../models/admin_models.dart';
import '../services/admin_service.dart';
import '../utils/format.dart';

class AdminUsersPanel extends StatefulWidget {
  const AdminUsersPanel({super.key});

  @override
  State<AdminUsersPanel> createState() => _AdminUsersPanelState();
}

class _AdminUsersPanelState extends State<AdminUsersPanel> {
  final _service = AdminService();

  List<AdminUser> _users = [];
  String _search = '';
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
      final users = await _service.fetchUsers();
      if (!mounted) return;
      setState(() {
        _users = users;
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

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
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
              'Users',
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
        TextField(
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search),
            hintText: 'Search by name or email',
            border: OutlineInputBorder(),
            isDense: true,
          ),
          onChanged: (value) =>
              setState(() => _search = value.trim().toLowerCase()),
        ),
        const SizedBox(height: 16),
        Expanded(child: _buildBody()),
      ],
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

    final visible = _users
        .where((u) =>
    u.name.toLowerCase().contains(_search) ||
        u.email.toLowerCase().contains(_search))
        .toList();

    if (visible.isEmpty) {
      return Center(
        child: Text(_search.isEmpty ? 'No users yet.' : 'No users match your search.'),
      );
    }
    return ListView.separated(
      itemCount: visible.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) => _userTile(visible[index]),
    );
  }

  Widget _userTile(AdminUser user) {
    final initial = user.name.isNotEmpty ? user.name[0].toUpperCase() : '?';
    final orders = '${user.orderCount} ${user.orderCount == 1 ? 'order' : 'orders'}';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFF1B2559),
            foregroundColor: Colors.white,
            child: Text(initial),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        user.name,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    if (user.isAdmin)
                      Container(
                        margin: const EdgeInsets.only(left: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1B2559),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'Admin',
                          style: TextStyle(color: Colors.white, fontSize: 11),
                        ),
                      ),
                  ],
                ),
                Text(
                  user.email,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                Text(
                  '$orders · joined ${formatDate(user.createdAt)}',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: user.isAdmin ? "Admin accounts can't be deleted" : 'Delete user',
            icon: Icon(
              Icons.delete,
              size: 20,
              color: user.isAdmin ? Colors.grey : Colors.red,
            ),
            onPressed: user.isAdmin ? null : () => _confirmDelete(user),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(AdminUser user) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete user?'),
        content: Text(
          'Remove ${user.name} (${user.email})? Their cart, saved addresses '
              'and payment methods will be deleted too.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              try {
                await _service.deleteUser(user.id);
                if (!mounted) return;
                setState(() => _users.removeWhere((u) => u.id == user.id));
              } on ApiException catch (e) {
                // e.g. "This customer has placed orders..."
                _showMessage(e.message);
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}