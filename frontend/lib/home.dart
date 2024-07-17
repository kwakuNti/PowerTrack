import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

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
              // Add profile navigation functionality here
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Add new item functionality here
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

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
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

  void _addMeter(MeterDetails meterDetails) {
    setState(() {
      _meters.add(meterDetails);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Padding(
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.insert_drive_file,
                    size: 80,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Add a meter to see details here',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
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
        width: MediaQuery.of(context).size.width * 0.6, // Make card wider
        height: 150,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.withOpacity(0.7),
              Colors.blue.withOpacity(0.4),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              spreadRadius: 1,
            ),
          ],
        ),
        child: const Column(
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
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMeterCard(MeterDetails meterDetails) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6, // Make card wider
      height: 150,
      margin: const EdgeInsets.only(left: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.purple.withOpacity(0.7),
            Colors.purple.withOpacity(0.4),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            meterDetails.meterName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            'Meter Number: ${meterDetails.meterNumber}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            'Customer Name: ${meterDetails.customerName}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            'Customer Number: ${meterDetails.customerNumber}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            'Address: ${meterDetails.address}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
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
          child: Column(
            children: [
              TextFormField(
                controller: _meterNameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Meter Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter meter name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _meterNumberController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Meter Number',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter meter number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _customerNameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Customer Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter customer name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _customerNumberController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Customer Number',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter customer number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Address',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter address';
                  }
                  return null;
                },
              ),
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
}

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
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
      body: Padding(
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
            const ListTile(
              leading: Icon(Icons.credit_card),
              title: Text('Manage Cards'),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            const Divider(),
            const ListTile(
              leading: Icon(Icons.flash_on),
              title: Text('Usage'),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            const Divider(),
            const ListTile(
              leading: Icon(Icons.person),
              title: Text('Manage Account'),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            const Divider(),
            SwitchListTile(
              title: const Text('Enable Biometrics'),
              value: _biometricsEnabled,
              onChanged: _toggleBiometrics,
            ),
            const Divider(),
            const ListTile(
              leading: Icon(Icons.logout),
              title: Text('Log out'),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
          ],
        ),
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
