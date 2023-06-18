import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:topics/app/chat/chat_provider.dart';

class PromptBuilderTools extends StatefulWidget {
  PromptBuilderTools({Key? key}) : super(key: key);

  @override
  _PromptBuilderToolsState createState() => _PromptBuilderToolsState();
}

class _PromptBuilderToolsState extends State<PromptBuilderTools> {
  bool _isVisible = false;
  late Future<Map<String, dynamic>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = _loadLocaleData();
  }

  Color getColor(int index) {
    switch (index % 3) {
      case 0:
        return Theme.of(context).colorScheme.secondary;
      case 1:
        return Theme.of(context).colorScheme.tertiary;
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  Future<Map<String, dynamic>> _loadLocaleData() async {
    final locale = getCurrentLocale();
    String jsonString = await (locale == null
        ? rootBundle.loadString('assets/i18n/prompts_en.json')
        : rootBundle
            .loadString('assets/i18n/prompts_${locale.languageCode}.json'));
    return jsonDecode(jsonString);
  }

  @override
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
        future: futureData,
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox(); // show loading spinner while waiting for data
          } else if (snapshot.hasError) {
            return Text(
                'Error: ${snapshot.error}'); // show error message if error occurred
          } else {
            Map<String, dynamic> data = snapshot.data!;

            return SingleChildScrollView(
              child: ExpansionPanelList(
                expansionCallback: (int index, bool isExpanded) {
                  setState(() {
                    _isVisible = !isExpanded;
                  });
                },
                children: [
                  ExpansionPanel(
                    canTapOnHeader: true,
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 0),
                          child: ListTile(
                            title: Text(
                              translate('prompt_builder'),
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ));
                    },
                    body: SizedBox(
                      height: 180,
                      child: ListView.builder(
                        itemCount: data.entries.length,
                        itemBuilder: (BuildContext context, int index) {
                          var entry = data.entries.elementAt(index);
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 12),
                                  child: Text(
                                    translate(entry.key),
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                SizedBox(
                                  height: 35,
                                  width: MediaQuery.of(context).size.width,
                                  child: ListView.separated(
                                    separatorBuilder:
                                        (BuildContext context, int i) {
                                      return const SizedBox(width: 12);
                                    },
                                    scrollDirection: Axis.horizontal,
                                    itemCount: entry.value.length,
                                    itemBuilder: (BuildContext context, int i) {
                                      return Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: getColor(index),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                            ),
                                          ),
                                          onPressed: () {
                                            Provider.of<ChatProvider>(context,
                                                    listen: false)
                                                .sendMessage(entry.value[i]
                                                    ["instructions"]);
                                          },
                                          child: Text(
                                            translate(
                                                entry.value[i]["title"] ?? ''),
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .surface,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    isExpanded: _isVisible,
                  ),
                ],
              ),
            );
          }
        });
  }
}
