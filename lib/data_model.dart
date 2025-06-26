// models/news_article_model.dart
class NewsArticle {
  final String title;
  final String description;
  final String url;
  final String imageUrl;
  final DateTime publishedAt;
  final String source;

  NewsArticle({
    required this.title,
    required this.description,
    required this.url,
    required this.imageUrl,
    required this.publishedAt,
    required this.source,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      url: json['url'] ?? '',
      imageUrl: json['urlToImage'] ?? '', // ✅ Changed from 'image' to 'urlToImage'
      publishedAt: DateTime.tryParse(json['publishedAt'] ?? '') ?? DateTime.now(),
      source: json['source'] != null ? json['source']['name'] ?? '' : '',
    );
  }
}
