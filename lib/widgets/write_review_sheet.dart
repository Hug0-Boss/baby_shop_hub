import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import '../utils/browse_colors.dart';

/// Opens the "write a review" pop-up. Returns true if a review was saved.
/// Anyone (e.g. Zizi's Profile) can call it:
///   showWriteReviewSheet(context, product: someProduct);
Future<bool?> showWriteReviewSheet(
  BuildContext context, {
  required Product product,
  String? userId,
  String? userName,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => _WriteReviewSheet(
      product: product,
      userId: userId ?? ProductService.currentUserId,
      userName: userName ?? ProductService.currentUserName,
    ),
  );
}

class _WriteReviewSheet extends StatefulWidget {
  final Product product;
  final String userId;
  final String userName;

  const _WriteReviewSheet({
    required this.product,
    required this.userId,
    required this.userName,
  });

  @override
  State<_WriteReviewSheet> createState() => _WriteReviewSheetState();
}

class _WriteReviewSheetState extends State<_WriteReviewSheet> {
  int _rating = 0;
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    ProductService.addReview(
      Review(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        productId: widget.product.id,
        userId: widget.userId,
        userName: widget.userName,
        rating: _rating,
        comment: _controller.text.trim(),
      ),
    );
    Navigator.pop(context, true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Thanks for your review!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Review ${widget.product.name}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Row(
            children: List.generate(
              5,
              (i) => IconButton(
                padding: EdgeInsets.zero,
                onPressed: () => setState(() => _rating = i + 1),
                icon: Icon(
                  i < _rating ? Icons.star : Icons.star_border,
                  color: BrowseColors.amber,
                  size: 36,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _controller,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Share what you liked or did not like (optional)',
              filled: true,
              fillColor: BrowseColors.grey,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: BrowseColors.blue,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _rating == 0 ? null : _submit,
              child: const Text('Submit review'),
            ),
          ),
        ],
      ),
    );
  }
}
