import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../models/meter_details.dart'; // Import the model

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
        children: [
          const Text(
            'Scheduled Maintenance',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Mon, 13th July 2022 7:45 PM',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'There will be scheduled maintenance at Achimota Bulk Supply Point. Your power will be off from 8am to 2pm.',
          ),
          const SizedBox(height: 20),
          const Text(
            'ECG releases 8-day ‘dumsor’ timetable for Accra',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Mon, 13th July 2022 7:45 PM',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Lorem ipsum dolor sit amet, consectetur sadipscing elitr, sed diam nonumy eirmodtempor invidunt ut labore et dolore magn.',
          ),
          const SizedBox(height: 8),
          Image.network(
            'https://via.placeholder.com/150',
            height: 150,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 20),
          const Text(
            'Invoice for New Meter Connection',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '12/12/2022',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'An invoice has been sent to you by Franklina Amoah to pay for new meter connection at Achimota Pillar 2.',
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              // Add view invoice functionality here
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text('View Invoice'),
          ),
          const SizedBox(height: 20),
          const Text(
            'Usage History',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 200,
            color: Colors.grey[200],
            child: const Center(child: Text('Graph Placeholder')),
          ),
          const SizedBox(height: 20),
          const Text(
            'Recent Transactions',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const ListTile(
            leading: Icon(Icons.add, color: Colors.green),
            title: Text('Bought Credit'),
            subtitle: Text('Mon, 12th July 2022 10:00 AM'),
            trailing: Text('₵50.00'),
          ),
          const ListTile(
            leading: Icon(Icons.add, color: Colors.green),
            title: Text('Bought Credit'),
            subtitle: Text('Sun, 11th July 2022 4:30 PM'),
            trailing: Text('₵30.00'),
          ),
          const SizedBox(height: 20),
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              // Add buy credit functionality here
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text('Buy Credit'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              // Add set reminder functionality here
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text('Set Reminder'),
          ),
        ],
      ),
    );
  }
}

class MetersPage extends StatefulWidget {
  const MetersPage({super.key});

  @override
  State<MetersPage> createState() => _MetersPageState();
}

class _MetersPageState extends State<MetersPage> {
  final List<MeterDetails> _meters = [];
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _addMeter(MeterDetails meterDetails) {
    setState(() {
      _meters.add(meterDetails);
    });
  }

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
    return Scaffold(
      body: SmartRefresher(
        controller: _refreshController,
        onRefresh: _onRefresh,
        // appBar: AppBar(
        //   automaticallyImplyLeading: false,
        // ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildAddMeterCard(context),
                    ..._meters.map((meter) => _buildMeterCard(meter)),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Expanded(
                child: _meters.isNotEmpty
                    ? ListView.builder(
                        itemCount: _meters.length,
                        itemBuilder: (context, index) {
                          final meter = _meters[index];
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Meter Name: ${meter.meterName}',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'Meter Number: ${meter.meterNumber}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'Customer Name: ${meter.customerName}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'Customer Number: ${meter.customerNumber}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'Address: ${meter.address}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.insert_drive_file,
                            size: 80,
                            color: Colors.grey[300],
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'No meters found',
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.grey[300],
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddMeterCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EnterMeterNumberPage(onAddMeter: _addMeter),
          ),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8, // Make card wider
        height: 200,
        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        decoration: BoxDecoration(
          color: Colors.teal[700],
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              spreadRadius: 1,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add,
                size: 50,
                color: Colors.white,
              ),
              SizedBox(height: 10),
              Text(
                'Add Meter',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMeterCard(MeterDetails meterDetails) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8, // Make card wider
      height: 220, // Adjust height to accommodate the button
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      decoration: BoxDecoration(
        color: Colors.blueGrey[800],
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            spreadRadius: 1,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meterDetails.meterName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Meter Number: ${meterDetails.meterNumber}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const Align(
              alignment: Alignment.bottomRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.electric_meter, color: Colors.white70, size: 18),
                  SizedBox(width: 5),
                  Text(
                    'Meter Details',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
                height: 10), // Add spacing between details and button
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            PaymentPage(meterId: meterDetails.meterNumber)),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.teal, // Text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                child: const Text('Buy Credit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentPage extends StatefulWidget {
  final String meterId;

  PaymentPage({required this.meterId});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String _paymentMethod = 'momo';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment for Meter ${widget.meterId}'),
      ),
      body: Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Payment Method',
              style: TextStyle(fontSize: 18.0),
            ),
            ListTile(
              title: const Text('Mobile Money'),
              leading: Radio<String>(
                value: 'momo',
                groupValue: _paymentMethod,
                onChanged: (String? value) {
                  setState(() {
                    _paymentMethod = value!;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Card (Visa)'),
              leading: Radio<String>(
                value: 'card',
                groupValue: _paymentMethod,
                onChanged: (String? value) {
                  setState(() {
                    _paymentMethod = value!;
                  });
                },
              ),
            ),
            if (_paymentMethod == 'momo') MobileMoneyForm(),
            if (_paymentMethod == 'card') CardPaymentForm(),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Handle payment submission logic here
              },
              child: Text('Submit Payment'),
            ),
          ],
        ),
      ),
    );
  }
}

class MobileMoneyForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(labelText: 'MoMo Number'),
        ),
      ],
    );
  }
}

class CardPaymentForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(labelText: 'Card Number'),
        ),
        TextField(
          decoration: InputDecoration(labelText: 'Expiry Date'),
        ),
        TextField(
          decoration: InputDecoration(labelText: 'CVV'),
        ),
      ],
    );
  }
}

class EnterMeterNumberPage extends StatefulWidget {
  final Function(MeterDetails) onAddMeter;

  const EnterMeterNumberPage({super.key, required this.onAddMeter});

  @override
  State<EnterMeterNumberPage> createState() => _EnterMeterNumberPageState();
}

class _EnterMeterNumberPageState extends State<EnterMeterNumberPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _meterNameController = TextEditingController();
  final TextEditingController _meterNumberController = TextEditingController();
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _customerNumberController =
      TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Meter Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildRoundedTextField(_meterNameController, 'Meter Name'),
              const SizedBox(height: 20),
              _buildRoundedTextField(_meterNumberController, 'Meter Number'),
              const SizedBox(height: 20),
              _buildRoundedTextField(_customerNameController, 'Customer Name'),
              const SizedBox(height: 20),
              _buildRoundedTextField(
                  _customerNumberController, 'Customer Number'),
              const SizedBox(height: 20),
              _buildRoundedTextField(_addressController, 'Address'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newMeter = MeterDetails(
                      meterName: _meterNameController.text,
                      meterNumber: _meterNumberController.text,
                      customerName: _customerNameController.text,
                      customerNumber: _customerNumberController.text,
                      address: _addressController.text,
                    );
                    widget.onAddMeter(newMeter);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Add Meter'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoundedTextField(
      TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        labelText: label,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }
}

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

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _biometricsEnabled = false;
  final LocalAuthentication auth = LocalAuthentication();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // Simulate fetching new data
    await Future.delayed(const Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                // Add your logout logic here
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  void _toggleBiometrics(bool value) async {
    bool canCheckBiometrics = await auth.canCheckBiometrics;
    if (canCheckBiometrics) {
      setState(() {
        _biometricsEnabled = value;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Biometric authentication is not available')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: SmartRefresher(
        controller: _refreshController,
        onRefresh: _onRefresh,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              const Center(
                child: CircleAvatar(
                  radius: 80,
                  backgroundImage: AssetImage(
                      'assets/profile_picture.png'), // Update this with your image path
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.credit_card),
                title: const Text('Manage Cards'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ManageCardPage()),
                  );
                },
              ),
              const Divider(),
              const ListTile(
                leading: Icon(Icons.flash_on),
                title: Text('Usage'),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Manage Account'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ManageAccountPage()),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.lock),
                title: const Text('Enable Biometrics'),
                trailing: Switch(
                  value: _biometricsEnabled,
                  onChanged: _toggleBiometrics,
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: _showLogoutDialog,
              ),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }
}

class ManageAccountPage extends StatelessWidget {
  const ManageAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Info'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 70,
              backgroundImage: NetworkImage(
                  'https://via.placeholder.com/150'), // Replace with your image
            ),
            const SizedBox(height: 24),
            _buildInfoRow('Name', 'Warren Buffet', false),
            const Divider(thickness: 1.5),
            _buildInfoRow('Birthdate', '05 November 1993', false),
            const Divider(thickness: 1.5),
            _buildInfoRow('Gender', 'Male', false),
            const Divider(thickness: 1.5),
            _buildInfoRow('Email', 'warren.buff@invest.ai', false),
            const Divider(thickness: 1.5),
            _buildInfoRow('Phone Number', '0557725781', true),
            const Divider(thickness: 1.5),
            _buildInfoRow('Address', 'greater accra', false),
            const Divider(thickness: 1.5),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value, bool isEditable) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          if (isEditable)
            TextButton(
              onPressed: () {
                // Handle change action
              },
              child: const Text(
                'Change',
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

void main() => runApp(MaterialApp(
      home: const HomePage(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    ));

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
