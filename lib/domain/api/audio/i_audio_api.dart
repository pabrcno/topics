abstract class IAudioApi {
  Future<List<String>> processAndUploadFile(String path);
  Future<List<String>> processAndUploadYoutubeUrl(String youtubeUrl);
}
