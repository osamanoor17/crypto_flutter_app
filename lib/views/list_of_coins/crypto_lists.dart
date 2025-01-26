import 'package:flutter/material.dart';
import '../../controllers/api_service.dart';
import '../coin_details/coin_details_screen.dart';

class CryptoListScreen extends StatefulWidget {
  @override
  _CryptoListScreenState createState() => _CryptoListScreenState();
}

class _CryptoListScreenState extends State<CryptoListScreen> {
  late ScrollController _scrollController;
  bool _isLoading = false;
  int _page = 1;
  final int _pageSize = 20;
  List<dynamic> _coins = [];
  List<dynamic> _filteredCoins = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _loadCoins();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !_isLoading) {
        _loadMoreCoins();
      }
    });
  }

  Future<void> _loadCoins() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final coins =
          await ApiService.fetchCoins(page: _page, pageSize: _pageSize);
      setState(() {
        _coins = coins;
        _filteredCoins = coins;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadMoreCoins() async {
    setState(() {
      _isLoading = true;
    });

    _page++;
    try {
      final newCoins =
          await ApiService.fetchCoins(page: _page, pageSize: _pageSize);
      setState(() {
        _coins.addAll(newCoins);
        _filteredCoins.addAll(newCoins);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _searchCoins(String query) {
    final filteredList = _coins.where((coin) {
      final coinName = coin['name'].toLowerCase();
      final queryLower = query.toLowerCase();
      return coinName.contains(queryLower);
    }).toList();

    setState(() {
      _filteredCoins = filteredList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.greenAccent,
          title: const Text(
            'Markets Overview',
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red),
          ),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(55), // Adjusted height
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Material(
                elevation: 8.0,
                borderRadius: BorderRadius.circular(30),
                child: TextField(
                  controller: _searchController,
                  onChanged: _searchCoins,
                  decoration: InputDecoration(
                    hintText: 'Search for a coin...',
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    prefixIcon:
                        const Icon(Icons.search, color: Colors.greenAccent),
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.greenAccent, width: 2),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.greenAccent, width: 1),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        body: _isLoading && _coins.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(12),
                itemCount: _filteredCoins.length + (_isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _filteredCoins.length) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final coin = _filteredCoins[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CoinDetailsScreen(coinId: coin['id']),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 8,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: coin['price_change_percentage_24h'] > 0
                                ? [Colors.greenAccent, Colors.amberAccent]
                                : [
                                    Colors.lightGreenAccent,
                                    Colors.lightGreenAccent
                                  ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          leading: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            backgroundImage: NetworkImage(coin['image']),
                            radius: 25,
                            onBackgroundImageError: (_, __) =>
                                const Icon(Icons.error, size: 25),
                          ),
                          title: Text(
                            coin['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                          subtitle: Row(
                            children: [
                              Text(
                                '\$${coin['current_price'].toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          trailing: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: coin['price_change_percentage_24h'] > 0
                                    ? [Colors.green, Colors.greenAccent]
                                    : [Colors.redAccent, Colors.red],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 15,
                            ),
                            child: Text(
                              '${coin['price_change_percentage_24h'].toStringAsFixed(2)}%',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
