import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget chipsRow;
  final TextStyle? textStyle;

  const CustomAppBar({
    super.key,
    required this.title,
    required this.chipsRow,
    this.textStyle,
  });

  @override
  Size get preferredSize => const Size.fromHeight(100);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: preferredSize.height,
      title: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize
            .min, // This ensures the column doesn't try to expand in the vertical direction.
        children: [
          const SizedBox(height: 10),
          Flexible(
            fit: FlexFit
                .loose, // This allows the text to take as much space as it needs but no more.
            child: Text(
              title,
              softWrap: true,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 20),
          chipsRow,
          const SizedBox(height: 10),
        ],
      ),
      elevation: 0.8,
      shadowColor: Colors.grey[700],
    );
  }
}
