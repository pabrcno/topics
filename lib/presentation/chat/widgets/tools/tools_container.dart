import 'package:flutter/material.dart';

class ToolsContainer extends StatelessWidget {
  final List<Widget> widgetList;

  const ToolsContainer({super.key, required this.widgetList});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 5, bottom: 16),
        child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 25,
            child: ListView.separated(
              separatorBuilder: (context, index) => const VerticalDivider(
                color: Colors.transparent,
                width: 12,
              ),
              scrollDirection: Axis.horizontal,
              itemCount: widgetList.length,
              itemBuilder: (context, index) {
                return widgetList[index];
              },
            )));
  }
}
