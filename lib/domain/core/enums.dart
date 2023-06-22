enum EMessageRole { system, user, assistant, imageAssistant, searchAssistant }

enum EGenerationType {
  textToImage,
  imageToImage,
}

// Usage
EGenerationType type = EGenerationType.textToImage;

// Convert enum to string
String typeString = type.toString().split('.').last.replaceAll('To', '-to-');

// Convert string to enum
EGenerationType fromString(String type) {
  return EGenerationType.values.firstWhere(
      (e) => e.toString().split('.').last.replaceAll('To', '-to-') == type);
}
