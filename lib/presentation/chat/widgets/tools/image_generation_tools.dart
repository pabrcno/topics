import 'package:flutter/material.dart';

class ImageGenerationTools extends StatefulWidget {
  final TextEditingController textController;

  ImageGenerationTools({required this.textController});

  @override
  _ImageGenerationToolsState createState() => _ImageGenerationToolsState();
}

class _ImageGenerationToolsState extends State<ImageGenerationTools> {
  final Map<String, List<String>> data = {
    "Famous Artists": [
      "Vincent Van Gogh",
      "Pablo Picasso",
      "Leonardo Da Vinci",
      "Michelangelo",
      "Claude Monet",
      "Salvador Dali",
      "Georgia O'Keeffe",
      "Andy Warhol",
      "Frida Kahlo",
      "Jackson Pollock",
      "Gustav Klimt",
      "Edvard Munch",
      "Mark Rothko",
      "Caravaggio",
      "Rembrandt"
    ],
    "Famous Photographers": [
      "Ansel Adams",
      "Richard Avedon",
      "Henri Cartier-Bresson",
      "Robert Capa",
      "Dorothea Lange",
      "Steve McCurry",
      "Diane Arbus",
      "Cindy Sherman",
      "Vivian Maier",
      "Sebastião Salgado"
    ],
    "Art Styles": [
      "Impressionism",
      "Cubism",
      "Surrealism",
      "Expressionism",
      "Pop Art",
      "Fauvism",
      "Abstract Expressionism",
      "Art Nouveau",
      "Renaissance",
      "Baroque",
      "Hyperrealism",
      "Romanticism"
    ],
    "General Art Keywords": [
      "Landscape",
      "Portrait",
      "Still Life",
      "Abstract",
      "Nature",
      "Urban",
      "Macro",
      "Black and White",
      "Color",
      "Texture",
      "Epic",
      "Minimalistic"
    ],
    "Stable Diffusion Prompts": [
      "HD",
      "High Resolution",
      "4K",
      "Colorful",
      "Vivid",
      "Realistic",
      "Fantasy",
      "Surreal",
      "Detailed",
      "Bright",
      "Dark",
      "Ethereal",
      "Dreamlike"
    ]
  };
  bool _isVisible = false;

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

  @override
  Widget build(BuildContext context) {
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
              return ListTile(
                title: Text(
                  "Image Generation Tools",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              );
            },
            body: SizedBox(
                height: 280,
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
                                padding: EdgeInsets.only(left: 12),
                                child: Text(
                                  entry.key,
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
                                )),
                            const SizedBox(height: 8),
                            SizedBox(
                              height:
                                  35, // Increase the height to accommodate buttons
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
                                              horizontal: 12)),
                                      onPressed: () {
                                        widget.textController.text +=
                                            " " + entry.value[i];
                                      },
                                      child: Text(entry.value[i],
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12)),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ));
                  },
                )),
            isExpanded: _isVisible,
          ),
        ],
      ),
    );
  }
}
