const List<String> _months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

/// 12 Oct 2026
String formatDate(DateTime date) =>
    '${date.day} ${_months[date.month - 1]} ${date.year}';

/// 12500 -> ₦12,500
String formatNaira(double amount) {
  final digits = amount.round().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(',');
    buffer.write(digits[i]);
  }
  return '₦$buffer';
}