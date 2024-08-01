import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:provider/provider.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/services/auth_services.dart';
import 'package:frontend/main.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  late AuthService _authService;
  List<Map<String, dynamic>> _transactions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _authService = AuthService();
    _fetchTransactions();
  }

  Future<void> showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'channel_id', // Change this to your own channel ID
      'channel_name', // Change this to your own channel name
      channelDescription:
          'channel_description', // Change this to your own description
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      title,
      body,
      platformChannelSpecifics,
      payload: 'item x', // Optional payload data
    );
  }

  Future<void> _fetchTransactions() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userId = authProvider.user?.user_id;

    if (userId == null) {
      print('User ID is not available');
      setState(() {
        _isLoading = false;
      });
      return;
    }

    print('Fetching transactions for user ID: $userId');

    try {
      final transactions = await _authService.fetchTransactions(userId);
      print('Transactions fetched successfully: $transactions');
      setState(() {
        _transactions = transactions;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching transactions: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onRefresh() async {
    await _fetchTransactions();
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SmartRefresher(
              controller: _refreshController,
              onRefresh: _onRefresh,
              child: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: _transactions.length,
                itemBuilder: (context, index) {
                  final transaction = _transactions[index];
                  return TransactionTile(
                    date: transaction['created_at'],
                    amount: transaction['amount'].toString(),
                    description: 'Credit Purchase', // Modify if needed
                  );
                },
              ),
            ),
    );
  }
}

class TransactionTile extends StatelessWidget {
  final String date;
  final String amount;
  final String description;

  const TransactionTile({
    super.key,
    required this.date,
    required this.amount,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.receipt),
      title: Text('$date - $description'),
      subtitle: Text('Amount: \$$amount'),
      trailing: const Icon(Icons.arrow_forward_ios),
    );
  }
}
