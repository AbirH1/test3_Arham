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
        .push(MaterialPageRoute(builder: (context) => AddGroceryItemPage()))
        .then((value) {
      // Handle any data returned from AddGroceryItemPage if needed
    });
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

class AddGroceryItemPage extends StatefulWidget {
  @override
  _AddGroceryItemPageState createState() => _AddGroceryItemPageState();
}

class _AddGroceryItemPageState extends State<AddGroceryItemPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime _expiryDate = DateTime.now();
  int _quantity = 0;

  void _selectExpiryDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _expiryDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _expiryDate) {
      setState(() {
        _expiryDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Grocery Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Text('Expiry Date: '),
                Text(
                  '${_expiryDate.month}/${_expiryDate.day}/${_expiryDate.year}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _selectExpiryDate(context),
                  child: Text('Select Date'),
                ),
              ],
            ),
            SizedBox(height: 16),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Quantity',
              ),
              onChanged: (value) {
                setState(() {
                  _quantity = int.tryParse(value) ?? 0;
                });
              },
            ),
            SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Logic to save the grocery item
                  Map<String, dynamic> newGroceryItem = {
                    'name': _nameController.text,
                    'description': _descriptionController.text,
                    'expiryDate': _expiryDate,
                    'quantity': _quantity,
                  };
                  // Add the new item to the list
                  Navigator.of(context).pop(newGroceryItem);
                },
                child: Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
