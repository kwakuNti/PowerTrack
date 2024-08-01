import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:provider/provider.dart';
import 'meterpage.dart';
import 'profile.dart';
import 'settings.dart';
import 'transaction.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/services/auth_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static const List<String> _titles = <String>[
    'Home',
    'Meters',
    'Transactions',
    'Settings',
  ];

  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    MetersPage(),
    TransactionsScreen(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ManageAccountPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.notification_add_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            },
          ),
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.electric_meter),
            label: 'Meters',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Transactions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  late AuthService _authService;
  List<dynamic> _newsArticles = [];
  List<Map<String, dynamic>> _transactions = [];
  bool _loading = true;
  bool _loadingTransactions = true;

  @override
  void initState() {
    super.initState();
    _authService = AuthService();
    _fetchNews();
    _fetchTransactions();
  }

  Future<void> _fetchNews() async {
    const String apiKey = 'pub_498370ca570c42d16d01c9f8f66aa765b2897';
    const String keywords = 'energy';
    const String url =
        'https://newsdata.io/api/1/latest?country=gh&apikey=$apiKey&q=$keywords';

    try {
      print('Fetching news from: $url');
      final response = await http.get(Uri.parse(url));
      print('Response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Response data: $data');
        setState(() {
          _newsArticles = data['results'];
          _loading = false;
          print('Number of articles fetched: ${_newsArticles.length}');
        });
      } else {
        throw Exception('Failed to load news');
      }
    } catch (e) {
      setState(() {
        _loading = false;
      });
      print('Error fetching news: $e');
    }
  }

  Future<void> _fetchTransactions() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userId = authProvider.user?.user_id;

    if (userId == null) {
      print('User ID is not available');
      setState(() {
        _loadingTransactions = false;
      });
      return;
    }

    print('Fetching transactions for user ID: $userId');

    try {
      final transactions = await _authService.fetchTransactions(userId);
      print('Transactions fetched successfully: $transactions');
      setState(() {
        _transactions = transactions;
        _loadingTransactions = false;
        print('Number of transactions fetched: ${_transactions.length}');
      });
    } catch (e) {
      print('Error fetching transactions: $e');
      setState(() {
        _loadingTransactions = false;
      });
    }
  }

  void _onRefresh() async {
    await _fetchNews();
    await _fetchTransactions();
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    final recentTransactions =
        _transactions.isNotEmpty ? _transactions.take(2).toList() : [];

    return SmartRefresher(
      controller: _refreshController,
      onRefresh: _onRefresh,
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          if (_loading)
            const Center(child: CircularProgressIndicator())
          else if (_newsArticles.isEmpty)
            const Center(child: Text('No news found'))
          else ...[
            ..._newsArticles.map((article) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (article['image_url'] != null)
                      Image.network(
                        article['image_url'],
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    const SizedBox(height: 8),
                    Text(
                      article['title'] ?? 'No Title',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      article['pubDate'] ?? 'No Date',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(article['description'] ?? 'No Description'),
                    const SizedBox(height: 20),
                  ],
                )),
            const SizedBox(height: 20),
            const Text(
              'Recent Transactions',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (_loadingTransactions)
              const Center(child: CircularProgressIndicator())
            else if (recentTransactions.isEmpty)
              const Center(child: Text('No transactions found'))
            else ...[
              ...recentTransactions.map((transaction) => Container(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          transaction['created_at'] ?? 'No Date',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Amount: \$${transaction['amount']?.toString() ?? '0.00'}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 4),
                      ],
                    ),
                  )),
            ],
            const SizedBox(height: 20),
            _buildQuickActions(),
          ],
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              // Navigate to Meters page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MetersPage()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text('Buy Credit'),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              // Navigate to Transactions page
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const TransactionsScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text('View Invoice'),
          ),
        ),
      ],
    );
  }
}
