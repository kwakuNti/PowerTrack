import 'package:flutter/material.dart';

class ManageCardPage extends StatefulWidget {
  const ManageCardPage({super.key});

  @override
  State<ManageCardPage> createState() => _ManageCardPageState();
}

class _ManageCardPageState extends State<ManageCardPage> {
  List<String> cards = ['Card 1', 'Card 2', 'Card 3']; // Example cards

  void deleteCard(int index) {
    setState(() {
      cards.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Cards'),
      ),
      body: ListView.builder(
        itemCount: cards.length,
        itemBuilder: (context, index) {
          return CardItem(
            cardName: cards[index],
            onDelete: () => deleteCard(index),
          );
        },
      ),
    );
  }
}

class CardItem extends StatelessWidget {
  final String cardName;
  final VoidCallback onDelete;

  const CardItem({required this.cardName, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      elevation: 5,
      child: ListTile(
        contentPadding: const EdgeInsets.all(15.0),
        title: Text(
          cardName,
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
