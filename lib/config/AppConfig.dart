class AppConfig {
  // pull về thì vô đây đổi ip lại là chạy ngon lành
  static const String baseUrl = "http://192.168.67.103:8080";
  static const String notificationURL='/api/notification/get-notification';
  static const String storyURL='/api/story/getstories';
  static const String postURL='/api/post/getpost';
  static const String uploadPostURL='/api/uploadfile/uploadfile';
  static const String uploadStoryURL='/api/uploadfile/uploadfilestory';
  static const String userURL='/api/user/getusermanagement';
}
