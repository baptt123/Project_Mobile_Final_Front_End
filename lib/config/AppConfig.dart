class AppConfig {
  // ====== Base URLs ======
  static const String baseUrl = "http://192.168.54.153:8080";
  static const String baseWebSocketURL = "ws://192.168.54.153:8080";
  static const String wsUrl = "ws://192.168.54.153:8080"; // Có thể bỏ nếu dư

  static const String friendbaseUrl = baseUrl;
  static const String commentUrl = baseUrl;

  // ====== API Paths ======
  static const String notificationURL = "/api/notification/get-notification";
  static const String storyURL = "/api/story/getstories";
  static const String postURL = "/api/post/getpost";
  static const String uploadPostURL = "/api/uploadfile/uploadfile";
  static const String uploadStoryURL = "/api/uploadfile/uploadfilestory";
  static const String userURL = "/api/user/getusermanagement";
  static const String messageURL = "/api/messages/getmessages";
  static const String likeURL = "/api/post/get/takeLike";
  static const String searchURL = "/api/user/search";

  // ====== WebSocket Paths ======
  static const String webSocketChatURL = "$baseWebSocketURL/chat?username=";
  // ======SSE Paths ======
  static const String sseUrl = 'http://192.168.5.248:8080/api/uploadfile/sse';
  static const Map<String, String> sseHeaders = {
    "Accept": "text/event-stream",
    "Cache-Control": "no-cache",
  };
}
