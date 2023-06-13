import 'package:flutter/material.dart';

class ToolsContainer extends StatelessWidget {
  final List<Widget> widgetList;

  const ToolsContainer({super.key, required this.widgetList});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 50,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: widgetList.length,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                border: Border.all(width: .5, color: Colors.grey.shade900),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: widgetList[index],
            );
          },
        ));
  }
}
