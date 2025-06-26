import 'package:flutter/material.dart';
import 'package:knownow/data_model.dart';
import 'package:intl/intl.dart';
import 'package:knownow/webview.dart';

class NewsDetailPage extends StatelessWidget {
  final NewsArticle article;

  const NewsDetailPage({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final publishedAt = DateFormat.yMMMd().add_jm().format(article.publishedAt);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
        children: [
          // 🔼 Image with back button (inside Stack)
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
                child: Image.network(
                  article.imageUrl,
                  width: size.width,
                  height: size.height * 0.35,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: size.width,
                      height: size.height * 0.35,
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(
                          Icons.broken_image,
                          color: Colors.grey,
                          size: 50,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).padding.top + 8,
                left: 16,
                child: CircleAvatar(
                  backgroundColor: Colors.black54,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
            ],
          ),

          // 🔽 Article Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    article.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Meta info
                  Text(
                    'Source: ${article.source} • $publishedAt',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),

                  // Description
                  Text(
                    article.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 24),

                  // Read more as RichText
                  Center(
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                        children: [
                          const TextSpan(text: 'To read the full article, '),
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => WebViewPage(url: article.url),
                                  ),
                                );
                              },
                              child: Text(
                                'click here',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                          const TextSpan(text: '.'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
