import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:knownow/data_model.dart';
import 'package:knownow/separate_details_page.dart';

class SearchResultPage extends StatelessWidget {
  final String query;
  final List<NewsArticle> articles;

  const SearchResultPage({
    super.key,
    required this.query,
    required this.articles,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Results for "$query"', overflow: TextOverflow.ellipsis),
        centerTitle: true,
      ),
      body:
          articles.isEmpty
              ? const Center(child: Text('No results found.'))
              : ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: articles.length,
                itemBuilder: (context, index) {
                  final article = articles[index];
                  final publishedAt = DateFormat.yMMMd().add_jm().format(
                    article.publishedAt,
                  );

                  return GestureDetector(
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => NewsDetailPage(article: article),
                          ),
                        ),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      height: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image:
                            article.imageUrl.isNotEmpty
                                ? DecorationImage(
                                  image: NetworkImage(article.imageUrl),
                                  fit: BoxFit.cover,
                                )
                                : null,
                        color: Colors.grey[300],
                      ),
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Colors.black.withOpacity(0.7),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 20,
                            left: 20,
                            right: 20,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  article.title,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  article.description,
                                  style: const TextStyle(color: Colors.white70),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Source: ${article.source}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.white54,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Text(
                                      publishedAt,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.white54,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
