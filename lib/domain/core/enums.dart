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

enum EModel { gpt4, gpt3 }

extension EModelExtension on EModel {
  String get stringValue {
    switch (this) {
      case EModel.gpt4:
        return "gpt-4";
      case EModel.gpt3:
        return "gpt-3.5-turbo";
      default:
        return '';
    }
  }
}
