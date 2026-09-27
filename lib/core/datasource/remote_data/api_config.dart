class ApiConfig {
  static const baseUrl = "newsapi.org";

  /// Your own NewsAPI key, passed at build time (it is never stored in the repo):
  /// flutter run --dart-define-from-file=env.json
  /// or: flutter run --dart-define=NEWS_API_KEY=<your_key>
  static const String apiKey = String.fromEnvironment('NEWS_API_KEY');

  /// Endpoints
  static const String topHeadlines = "top-headlines";
  static const String everything = "everything";
}
