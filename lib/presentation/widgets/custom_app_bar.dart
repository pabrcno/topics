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
  Size get preferredSize => Size.fromHeight(title.length * 0.5 + 80);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: preferredSize.height,
      title: Column(
        mainAxisSize: MainAxisSize
            .min, // This ensures the column doesn't try to expand in the vertical direction.
        children: [
          Flexible(
            fit: FlexFit
                .loose, // This allows the text to take as much space as it needs but no more.
            child: Text(
              title,
              softWrap: true,
              overflow: TextOverflow.visible,
            ),
          ),
          const SizedBox(height: 10),
          chipsRow,
          const SizedBox(height: 10),
        ],
      ),
      elevation: 0.8,
      shadowColor: Colors.grey[700],
    );
  }
}
