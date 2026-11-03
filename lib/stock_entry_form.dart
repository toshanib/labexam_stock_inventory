import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'inventory_service.dart';
import 'inventory_screen.dart';

class StockEntryForm extends StatefulWidget {
  const StockEntryForm({super.key});

  @override
  State<StockEntryForm> createState() => _StockEntryFormState();
}

class _StockEntryFormState extends State<StockEntryForm> {
  final _formKey = GlobalKey<FormState>();

  final _skuController = TextEditingController();
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();
  final _reorderController = TextEditingController();

  final InventoryService _inventoryService = InventoryService();

  final List<String> _categories = [
    'Electronics',
    'Stationery',
    'Hardware',
    'Grocery',
  ];

  String? _selectedCategory;
  bool _isSaving = false;

  @override
  void dispose() {
    _skuController.dispose();
    _nameController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    _reorderController.dispose();
    super.dispose();
  }

  String? _validateSku(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter the SKU';
    }

    if (!RegExp(r'^STK-\d{3}$').hasMatch(value.trim())) {
      return 'Use the format STK-101';
    }

    return null;
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter the item name';
    }

    if (value.trim().length < 3) {
      return 'Item name must contain at least 3 characters';
    }

    return null;
  }

  String? _validateCategory(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select a category';
    }

    return null;
  }

  String? _validateQuantity(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter the quantity';
    }

    final quantity = int.tryParse(value.trim());

    if (quantity == null || quantity < 0) {
      return 'Enter a valid whole number (0 or above)';
    }

    return null;
  }

  String? _validatePrice(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter the unit price';
    }

    final price = double.tryParse(value.trim());

    if (price == null || price <= 0) {
      return 'Enter a valid price greater than 0';
    }

    return null;
  }

  String? _validateReorderLevel(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter the reorder level';
    }

    final level = int.tryParse(value.trim());

    if (level == null || level < 0) {
      return 'Enter a valid whole number (0 or above)';
    }

    return null;
  }

  Future<void> _saveItem() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      await _inventoryService.saveItem(
        sku: _skuController.text.trim().toUpperCase(),
        itemName: _nameController.text.trim(),
        category: _selectedCategory!,
        quantity: int.parse(_quantityController.text.trim()),
        unitPrice: double.parse(_priceController.text.trim()),
        reorderLevel: int.parse(_reorderController.text.trim()),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Stock item saved successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      _formKey.currentState!.reset();

      _skuController.clear();
      _nameController.clear();
      _quantityController.clear();
      _priceController.clear();
      _reorderController.clear();

      setState(() {
        _selectedCategory = null;
      });
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save item: $error'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: const Color(0xFFC65F87)),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFF1C6D5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Color(0xFFC65F87),
          width: 2,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Inventory Manager'),
        actions: [
          IconButton(
            tooltip: 'View Inventory',
            icon: const Icon(Icons.inventory_2_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const InventoryScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Card(
              color: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Icon(
                        Icons.add_box_outlined,
                        size: 45,
                        color: Color(0xFFC65F87),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Add Stock Item',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFC65F87),
                        ),
                      ),
                      const SizedBox(height: 25),

                      TextFormField(
                        controller: _skuController,
                        decoration: _inputDecoration(
                          'SKU (e.g. STK-101)',
                          Icons.qr_code,
                        ),
                        textCapitalization: TextCapitalization.characters,
                        inputFormatters: [
                          UpperCaseTextFormatter(),
                        ],
                        validator: _validateSku,
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _nameController,
                        decoration: _inputDecoration(
                          'Item Name',
                          Icons.inventory,
                        ),
                        validator: _validateName,
                      ),
                      const SizedBox(height: 16),

                      DropdownButtonFormField<String>(
                        initialValue: _selectedCategory,
                        decoration: _inputDecoration(
                          'Category',
                          Icons.category,
                        ),
                        items: _categories.map((category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value;
                          });
                        },
                        validator: _validateCategory,
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _quantityController,
                        decoration: _inputDecoration(
                          'Quantity',
                          Icons.numbers,
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: _validateQuantity,
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _priceController,
                        decoration: _inputDecoration(
                          'Unit Price (RM)',
                          Icons.attach_money,
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        validator: _validatePrice,
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _reorderController,
                        decoration: _inputDecoration(
                          'Reorder Level',
                          Icons.warning_amber,
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: _validateReorderLevel,
                      ),
                      const SizedBox(height: 25),

                      ElevatedButton.icon(
                        onPressed: _isSaving ? null : _saveItem,
                        icon: _isSaving
                            ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                            : const Icon(Icons.save),
                        label: Text(
                          _isSaving ? 'Saving...' : 'Save Item',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    return newValue.copyWith(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}