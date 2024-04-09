import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show FilteringTextInputFormatter;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grocery List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: GroceryListPage(),
    );
  }
}

class GroceryListPage extends StatefulWidget {
  @override
  _GroceryListPageState createState() => _GroceryListPageState();
}

class _GroceryListPageState extends State<GroceryListPage> {
  final List<Map<String, dynamic>> _groceryItems = [
    {
      'name': 'FANJUICE',
      'description': 'Jus d\'Orange Nature',
      'expiryDate': DateTime.parse('2024-02-12'),
      'quantity': 2,
    },
    {
      'name': 'BPL',
      'description': 'Lait écrémé',
      'expiryDate': DateTime.parse('2024-02-12'),
      'quantity': 1,
    },
    {
      'name': 'TOUCH\'AM',
      'description': 'Lotion Aloe Vera',
      'expiryDate': DateTime.parse('2024-02-12'),
      'quantity': 0,
    },
  ];

  final List<TextEditingController> _controllers = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < _groceryItems.length; i++) {
      _controllers.add(
          TextEditingController(text: _groceryItems[i]['quantity'].toString()));
    }
  }

  void _incrementQuantity(int index) {
    setState(() {
      _groceryItems[index]['quantity']++;
      _controllers[index].text = _groceryItems[index]['quantity'].toString();
    });
  }

  void _decrementQuantity(int index) {
    setState(() {
      if (_groceryItems[index]['quantity'] > 0) {
        _groceryItems[index]['quantity']--;
        _controllers[index].text = _groceryItems[index]['quantity'].toString();
      }
    });
  }

  void _navigateToAddItemPage() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => AddGroceryItemPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Grocery Item List'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _navigateToAddItemPage,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _groceryItems.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Text(
                  _groceryItems[index]['name'][0].toUpperCase(),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              title: Text(
                _groceryItems[index]['name'],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_groceryItems[index]['description']),
                  Text(
                    'Expiry Date: ${_groceryItems[index]['expiryDate'].month}/${_groceryItems[index]['expiryDate'].day}/${_groceryItems[index]['expiryDate'].year}',
                    style: TextStyle(fontSize: 12, color: Colors.red),
                  ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () {
                      _decrementQuantity(index);
                    },
                  ),
                  SizedBox(width: 8),
                  SizedBox(
                    width: 40,
                    child: TextField(
                      controller: _controllers[index],
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(width: 8),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      _incrementQuantity(index);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }
}

class AddGroceryItemPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Grocery Item'),
      ),
      body: Center(
        child: Text('Add Grocery Item Page'),
      ),
    );
  }
}
