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
        return Theme.of(context).colorScheme.primary;
      case 1:
        return Theme.of(context).colorScheme.secondary;
      default:
        return Theme.of(context).colorScheme.tertiary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Align(
            alignment: Alignment.topLeft,
            child: TextButton.icon(
              label: Text(
                "Image Generation Tools",
                style: Theme.of(context).textTheme.labelMedium,
              ),
              icon: Icon(
                  _isVisible ? Icons.arrow_drop_down : Icons.arrow_drop_up),
              onPressed: () {
                setState(() {
                  _isVisible = !_isVisible;
                });
              },
            )),
        if (_isVisible)
          ...data.entries.map((entry) {
            var index = data.keys.toList().indexOf(entry.key);
            return Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.key,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 25,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: entry.value.length,
                          itemBuilder: (BuildContext context, int i) {
                            return Padding(
                                padding: const EdgeInsets.all(2),
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(color: getColor(index)),
                                  ),
                                  onPressed: () {
                                    widget.textController.text +=
                                        " " + entry.value[i];
                                  },
                                  child: Text(entry.value[i],
                                      style: TextStyle(
                                          color: getColor(index),
                                          fontSize: 10)),
                                ));
                          },
                        )),
                  ],
                ));
          }).toList(),
      ],
    );
  }
}
