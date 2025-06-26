import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:knownow/data_model.dart';
import 'package:knownow/news_api_service.dart';
import 'package:knownow/separate_details_page.dart';
import 'package:knownow/query_result_page.dart';
import 'package:shimmer/shimmer.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final NewsApiService _newsService = NewsApiService();
  late Future<List<NewsArticle>> _newsFuture;
  String selectedCategory = 'general';
  final TextEditingController _searchController = TextEditingController();

  final List<String> categories = [
    'general',
    'technology',
    'sports',
    'business',
    'entertainment',
    'science',
    'health',
  ];

  @override
  void initState() {
    super.initState();
    _newsFuture = _newsService.fetchNews(category: selectedCategory);
  }

  void _onCategoryChanged(String? newCategory) {
    if (newCategory != null) {
      setState(() {
        selectedCategory = newCategory;
        _newsFuture = _newsService.fetchNews(category: selectedCategory);
      });
    }
  }

  void _onSearchSubmitted(String value) async {
    final trimmedValue = value.trim();
    if (trimmedValue.isEmpty) return;

    try {
      final results = await _newsService.fetchNews(query: trimmedValue);
      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (_) => SearchResultPage(query: trimmedValue, articles: results),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error fetching search results.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Column(
        children: [
          // 🔼 App title and search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 50, 16, 10),
            child: Row(
              children: [
                Text(
                  'NewsKN',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onSubmitted: _onSearchSubmitted,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      hintText: 'Search news...',
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      isDense: true,
                      prefixIcon: const Icon(
                        Icons.search,
                        size: 20,
                        color: Colors.red,
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear, size: 20),
                        onPressed: () {
                          _searchController.clear();
                        },
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 🔽 News Content with Refresh Indicator
          Expanded(
            child: FutureBuilder<List<NewsArticle>>(
              future: _newsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return ListView.builder(
                    itemCount: 6,
                    padding: const EdgeInsets.all(10),
                    itemBuilder:
                        (context, index) => Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          height: 250,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey[300],
                          ),
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.grey.shade100,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Something went wrong.',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              _newsFuture = _newsService.fetchNews(
                                category: selectedCategory,
                              );
                            });
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retry'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final articles = snapshot.data!..shuffle();
                if (articles.isEmpty) {
                  return const Center(child: Text('No news found.'));
                }

                return RefreshIndicator(
                  color: Colors.red,
                  onRefresh: () async {
                    setState(() {
                      _newsFuture = _newsService.fetchNews(
                        category: selectedCategory,
                      );
                    });
                  },
                  child: ListView.builder(
                    itemCount: articles.length,
                    padding: const EdgeInsets.all(10),
                    itemBuilder: (context, index) {
                      final article = articles[index];

                      // ❌ Skip if no image
                      if (article.imageUrl.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      final publishedAt = DateFormat.yMMMd().add_jm().format(
                        article.publishedAt,
                      );

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => NewsDetailPage(article: article),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          height: 250,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: NetworkImage(article.imageUrl),
                              fit: BoxFit.cover,
                            ),
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
                                      style: const TextStyle(
                                        color: Colors.white70,
                                      ),
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
              },
            ),
          ),

          // 🔽 Category Selector
          Container(
            color: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children:
                    categories.map((category) {
                      final isSelected = selectedCategory == category;

                      return GestureDetector(
                        onTap: () => _onCategoryChanged(category),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              height: 3,
                              width: 30,
                              margin: const EdgeInsets.only(bottom: 4),
                              decoration: BoxDecoration(
                                color:
                                    isSelected
                                        ? Colors.red
                                        : Colors.transparent,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              child: Text(
                                category.toUpperCase(),
                                style: TextStyle(
                                  color:
                                      isSelected ? Colors.red : Colors.white70,
                                  fontWeight:
                                      isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
