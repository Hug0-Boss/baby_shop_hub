import 'package:flutter/material.dart';
import '../utils/browse_colors.dart';

/// Shows the product picture. If the picture file is missing, shows a grey placeholder.
class ProductImage extends StatelessWidget {
  final String? imagePath;
  final double? height;

  const ProductImage({super.key, this.imagePath, this.height});

  static const _placeholder = Icon(Icons.image_outlined, color: BrowseColors.mutedText, size: 36);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      alignment: Alignment.center,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: BrowseColors.grey,
        borderRadius: BorderRadius.circular(8),
      ),
      child: imagePath == null
          ? _placeholder
          : Image.asset(
              imagePath!,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _placeholder,
            ),
    );
  }
}
