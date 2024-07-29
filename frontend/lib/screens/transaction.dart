import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'home.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // Simulate a network call
    await Future.delayed(const Duration(seconds: 2));
    _refreshController.refreshCompleted();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: _refreshController,
      onRefresh: _onRefresh,
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          TransactionTile(
            date: '2024-07-15',
            amount: '50.00',
            description: 'Credit Purchase',
          ),
          Divider(),
          TransactionTile(
            date: '2024-07-10',
            amount: '30.00',
            description: 'Credit Purchase',
          ),
          Divider(),
          TransactionTile(
            date: '2024-07-05',
            amount: '20.00',
            description: 'Credit Purchase',
          ),
          // Add more transactions here
        ],
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
