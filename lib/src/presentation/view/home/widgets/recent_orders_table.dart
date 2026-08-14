import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurant_app/src/core/const/app_color.dart';
import 'package:restaurant_app/src/core/utils/helper/texthelper.dart';
import 'package:restaurant_app/src/presentation/view/orders/order_detail_screen.dart';

class RecentOrdersTable extends StatelessWidget {
  const RecentOrdersTable({super.key});

  static const _rows = [
    ('1', '#1001', 'Chicken\nBiriyani', '2'),
    ('1', '#1001', 'Chicken\nBiriyani', '2'),
    ('1', '#1001', 'Chicken\nBiriyani', '2'),
    ('1', '#1001', 'Chicken\nBiriyani', '2'),
  ];

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x13000000),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const _OrderTableRow(
              values: ['Sno', 'Order ID', 'Product', 'Qty', 'View', 'Status'],
              isHeader: true,
            ),
            for (final row in _rows)
              _OrderTableRow(
                values: [row.$1, row.$2, row.$3, row.$4, 'View', 'Pending'],
              ),
          ],
        ),
      ),
    );
  }
}

class _OrderTableRow extends StatelessWidget {
  const _OrderTableRow({required this.values, this.isHeader = false});

  final List<String> values;
  final bool isHeader;

  @override
  Widget build(BuildContext context) {
    const flexes = [7, 14, 20, 8, 11, 14];

    return Container(
      constraints: const BoxConstraints(minHeight: 42),
      decoration: BoxDecoration(
        color: isHeader ? const Color(0xFFFFFAF7) : Colors.transparent,
        border: const Border(
          bottom: BorderSide(color: Color(0xFFF4ECE7), width: 0.7),
        ),
      ),
      child: Row(
        children: [
          for (var index = 0; index < values.length; index++)
            Expanded(
              flex: flexes[index],
              child: Center(child: _buildCell(index)),
            ),
        ],
      ),
    );
  }

  Widget _buildCell(int index) {
    final value = values[index];
    if (!isHeader && value == 'Pending') {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(3),
        ),
        child: Text(
          'Pending',
          style:TextHelper.button.copyWith(
            fontSize:11,
            color:AppColors.white,
          )
        ),
      );
    }

    Widget content = Text(
      value,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
      style: GoogleFonts.poppins(
        color: !isHeader && value == 'View'
            ? AppColors.green
            : const Color(0xFF5D6470),
        fontSize: isHeader
            ? 11
            : index == 2
            ? 10
            : index == 4
            ? 11
            : 10,
        fontWeight: FontWeight.w500,
        height: 1.15,
        decoration: !isHeader && value == 'View'
            ? TextDecoration.underline
            : null,
      ),
    );

    if (!isHeader && value == 'View') {
      return GestureDetector(
        onTap: () {
          Get.to(() => OrderDetailScreen());
        },
        child: content,
      );
    }

    return content;
  }
}
