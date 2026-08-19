import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_text_style.dart';
import '../../../../core/theme/color.dart';

/// The "₦10,000 / escrow" and "14 days / borrow period" pairs.
///
/// **Escrow amount and borrow period are not in the schema.** `Book` carries
/// `id, ownerId, title, author, isbn, coverImageUrls, condition, status,
/// aiSummary, genre, whyRead, tags, createdAt, owner` and nothing else. Until
/// that is resolved — new columns, platform-wide constants, or something
/// derived — call sites pass [placeholder]. A blank that looks blank is better
/// than a hardcoded ₦10,000 copied from the mockup, which looks like real data.
class EscrowStat extends StatelessWidget {
  const EscrowStat({
    super.key,
    required this.value,
    required this.label,
    this.accent = false,
  });

  final String value;
  final String label;

  /// In the mockup only "borrow period" is accented.
  final bool accent;

  /// What to render until the fields exist.
  static const String placeholder = '—';

  /// The mockup writes `N10,000` with a plain capital N; `₦` is the correct
  /// glyph and Poppins has it. Formatting goes through `intl`, never string
  /// interpolation — thousands separators are locale data, not a `,` you type.
  static String formatNaira(num amount) => NumberFormat.currency(
    locale: 'en_NG',
    symbol: '₦',
    decimalDigits: 0,
  ).format(amount);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyle.statValue.copyWith(color: AppColors.ink),
        ),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyle.statLabel.copyWith(
            color: accent ? AppColors.brandGreen : AppColors.inkMuted,
          ),
        ),
      ],
    );
  }
}
