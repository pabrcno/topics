// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:topics/app/chat/chat_provider.dart';

// import 'mocks.dart';

// T anyArg<T extends Object>() => any as dynamic;
// void main() {
//   late ChatProvider chatProvider;
//   late MockChatApi mockChatApi;
//   late MockChatRepository mockChatRepository;
//   late MockErrorCommander mockErrorCommander;

//   setUp(() async {
//     TestWidgetsFlutterBinding.ensureInitialized();

//     // ... other setup code

//     // Instantiate the mocks
//     mockChatApi = MockChatApi();
//     mockChatRepository = MockChatRepository();
//     mockErrorCommander = MockErrorCommander();
//     // Instantiate the ChatProvider
//     chatProvider = ChatProvider(
//       chatApi: mockChatApi,
//       chatRepository: mockChatRepository,
//       errorCommander: mockErrorCommander,
//     );
//   });

//   tearDown(() {
//     // Reset mockito state to avoid mock interactions and verifications
//     // from leaking between test cases.
//     resetMockitoState();
//   });

//   test('ChatProvider initializes with correct values', () {
//     expect(chatProvider.apiKey, isNull);
//     expect(chatProvider.messageBuffer, equals(''));
//     expect(chatProvider.messages, equals([]));
//     expect(chatProvider.isApiKeySet, isFalse);
//     expect(chatProvider.currentChat, isNull);
//     expect(chatProvider.currentTopic, isNull);
//   });
//   test('loadApiKey fetches apiKey from SharedPreferences and sets it correctly',
//       () async {
//     final mockSharedPreferences = MockSharedPreferences();

//     SharedPreferences.setMockInitialValues(
//         {'apiKey': 'test_api_key'}); // Set the mock initial values

//     when(mockSharedPreferences.getString('apiKey')).thenReturn('test_api_key');

//     await chatProvider.loadApiKey();

//     expect(chatProvider.apiKey, equals('test_api_key'));
//   });
//   test('fetchMessages function runs when setting a chat', () async {
//     await chatProvider.setCurrentChat(mockChat);

//     verify(mockChatRepository.getMessages(mockChat.id)).called(1);
//     expect(chatProvider.messages, equals(mockMessages));
//     expect(chatProvider.isLoading, equals(false));
//   });

//   test('fetchTopics function works as expected', () async {
//     await chatProvider.fetchTopics('user1');

//     verify(mockChatRepository.getTopics('user1')).called(1);
//     expect(chatProvider.topics, equals(mockTopics));
//     expect(chatProvider.isLoading, equals(false));
//   });

//   test('fetchChatsForTopic function works as expected', () async {
//     when(mockChatRepository.getChats('topic1'))
//         .thenAnswer((_) async => mockChats);

//     await chatProvider.fetchChatsForTopic('topic1');

//     verify(mockChatRepository.getChats('topic1')).called(1);
//     expect(chatProvider.currentTopicChats, equals(mockChats));
//     expect(chatProvider.isLoading, equals(false));
//   });

//   test('setCurrentChat function works as expected', () async {
//     await chatProvider.setCurrentChat(mockChat);

//     verify(mockChatRepository.getMessages(mockChat.id)).called(1);
//     expect(chatProvider.messages, equals(mockMessages));
//     expect(chatProvider.isLoading, equals(false));
//   });
// }
