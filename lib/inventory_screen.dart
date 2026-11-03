
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'inventory_service.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final InventoryService _inventoryService = InventoryService();

  final TextEditingController _searchController =
  TextEditingController();

  final FocusNode _searchFocusNode = FocusNode();

  late final Stream<QuerySnapshot<Map<String, dynamic>>> _itemsStream;

  String _searchQuery = '';
  String _selectedCategory = 'All';
  String _stockFilter = 'All Stock';
  String _sortOrder = 'None';

  final List<String> _categories = [
    'All',
    'Electronics',
    'Stationery',
    'Hardware',
    'Grocery',
  ];

  @override
  void initState() {
    super.initState();

    // Create the Firestore stream only once.
    _itemsStream = _inventoryService.getItems();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  // Filter and sort inventory records.
  List<QueryDocumentSnapshot<Map<String, dynamic>>> _filterItems(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> documents,
      ) {
    List<QueryDocumentSnapshot<Map<String, dynamic>>> results =
    List.from(documents);

    final keyword = _searchQuery.trim().toLowerCase();

    // Search by SKU or item name only after submitting.
    if (keyword.isNotEmpty) {
      results = results.where((document) {
        final data = document.data();

        final sku = (data['sku'] ?? '').toString().toLowerCase();

        final itemName =
        (data['itemName'] ?? '').toString().toLowerCase();

        return sku.contains(keyword) ||
            itemName.contains(keyword);
      }).toList();
    }

    // Category filter.
    if (_selectedCategory != 'All') {
      results = results.where((document) {
        return document.data()['category'] == _selectedCategory;
      }).toList();
    }

    // Low-stock filter.
    if (_stockFilter == 'Low Stock') {
      results = results.where((document) {
        final data = document.data();

        final quantity =
            (data['quantity'] as num?)?.toInt() ?? 0;

        final reorderLevel =
            (data['reorderLevel'] as num?)?.toInt() ?? 0;

        return quantity <= reorderLevel;
      }).toList();
    }

    // Quantity sorting.
    if (_sortOrder == 'Ascending') {
      results.sort((a, b) {
        final quantityA =
            (a.data()['quantity'] as num?)?.toInt() ?? 0;

        final quantityB =
            (b.data()['quantity'] as num?)?.toInt() ?? 0;

        return quantityA.compareTo(quantityB);
      });
    } else if (_sortOrder == 'Descending') {
      results.sort((a, b) {
        final quantityA =
            (a.data()['quantity'] as num?)?.toInt() ?? 0;

        final quantityB =
            (b.data()['quantity'] as num?)?.toInt() ?? 0;

        return quantityB.compareTo(quantityA);
      });
    }

    return results;
  }

  // Submit keyword search.
  void _performSearch() {
    setState(() {
      _searchQuery = _searchController.text.trim();
    });

    _searchFocusNode.unfocus();
  }

  // Reset all search and filter settings.
  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _searchQuery = '';
      _selectedCategory = 'All';
      _stockFilter = 'All Stock';
      _sortOrder = 'None';
    });
  }

  // Reusable dropdown widget.
  Widget _buildFilterDropdown({
    required String label,
    required String value,
    required List<String> options,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xFFF1C6D5),
          ),
        ),
      ),
      items: options.map((option) {
        return DropdownMenuItem(
          value: option,
          child: Text(
            option,
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  // Display an individual inventory record.
  Widget _buildInventoryCard(
      QueryDocumentSnapshot<Map<String, dynamic>> document,
      ) {
    final data = document.data();

    final sku = (data['sku'] ?? '').toString();

    final itemName = (data['itemName'] ?? '').toString();

    final category = (data['category'] ?? '').toString();

    final quantity =
        (data['quantity'] as num?)?.toInt() ?? 0;

    final unitPrice =
        (data['unitPrice'] as num?)?.toDouble() ?? 0.0;

    final reorderLevel =
        (data['reorderLevel'] as num?)?.toInt() ?? 0;

    final isLowStock = quantity <= reorderLevel;

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(
          color: Color(0xFFF1C6D5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.inventory_2_outlined,
                  color: Color(0xFFC65F87),
                  size: 28,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    itemName,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: isLowStock
                        ? const Color(0xFFFFE0E0)
                        : const Color(0xFFE1F5E7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isLowStock ? 'Low Stock' : 'In Stock',
                    style: TextStyle(
                      color: isLowStock
                          ? Colors.red.shade800
                          : Colors.green.shade800,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Text('SKU: $sku'),
            const SizedBox(height: 5),
            Text('Category: $category'),
            const SizedBox(height: 5),
            Text('Quantity: $quantity'),
            const SizedBox(height: 5),
            Text('Unit Price: RM ${unitPrice.toStringAsFixed(2)}'),
            const SizedBox(height: 5),
            Text('Reorder Level: $reorderLevel'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _itemsStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Unable to retrieve inventory.\n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFC65F87),
              ),
            );
          }

          final documents = snapshot.data?.docs ?? [];

          final filteredItems = _filterItems(documents);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Saved Stock Items',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFC65F87),
                  ),
                ),
                const SizedBox(height: 15),

                // Search field.
                TextField(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.search,
                  onSubmitted: (_) {
                    _performSearch();
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter SKU or item name',
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Color(0xFFC65F87),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(
                        Icons.search,
                        color: Color(0xFFC65F87),
                      ),
                      onPressed: _performSearch,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Color(0xFFF1C6D5),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Color(0xFFC65F87),
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Category filter.
                _buildFilterDropdown(
                  label: 'Category',
                  value: _selectedCategory,
                  options: _categories,
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value ?? 'All';
                    });
                  },
                ),
                const SizedBox(height: 12),

                // Stock status filter.
                _buildFilterDropdown(
                  label: 'Stock Status',
                  value: _stockFilter,
                  options: const [
                    'All Stock',
                    'Low Stock',
                  ],
                  onChanged: (value) {
                    setState(() {
                      _stockFilter = value ?? 'All Stock';
                    });
                  },
                ),
                const SizedBox(height: 12),

                // Quantity sorting.
                _buildFilterDropdown(
                  label: 'Sort by Quantity',
                  value: _sortOrder,
                  options: const [
                    'None',
                    'Ascending',
                    'Descending',
                  ],
                  onChanged: (value) {
                    setState(() {
                      _sortOrder = value ?? 'None';
                    });
                  },
                ),
                const SizedBox(height: 12),

                // Clear filters button.
                OutlinedButton.icon(
                  onPressed: _clearFilters,
                  icon: const Icon(Icons.filter_alt_off),
                  label: const Text('Clear Filters'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFC65F87),
                    side: const BorderSide(
                      color: Color(0xFFC65F87),
                    ),
                    minimumSize: const Size(
                      double.infinity,
                      45,
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                Text(
                  'Showing ${filteredItems.length} of ${documents.length} items',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 12),

                if (documents.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(30),
                    child: Text(
                      'No stock items have been saved yet.',
                      textAlign: TextAlign.center,
                    ),
                  )
                else if (filteredItems.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(30),
                    child: Text(
                      'No matching stock items found.',
                      textAlign: TextAlign.center,
                    ),
                  )
                else
                  ...filteredItems.map(_buildInventoryCard),
              ],
            ),
          );
        },
      ),
    );
  }
}
