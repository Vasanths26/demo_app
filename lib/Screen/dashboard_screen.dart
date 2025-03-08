import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/stock_model.dart';
import '../Service/stock_services.dart';
import 'stock_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final TextEditingController _symbolController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadStocks();
  }

  // Load saved stocks from SharedPreferences
  Future<void> _loadStocks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? stocksJson = prefs.getString('saved_stocks');

    if (stocksJson != null) {
      final List<dynamic> decodedList = json.decode(stocksJson);
      final List<StockModelClass> stocksData =
          decodedList.map((data) => StockModelClass.fromJson(data)).toList();

      Provider.of<StockProvider>(context, listen: false).setStocks(stocksData);
    }
  }

  // Save stocks to SharedPreferences
  Future<void> _saveStocks() async {
    final prefs = await SharedPreferences.getInstance();
    final stockProvider = Provider.of<StockProvider>(context, listen: false);

    final List<Map<String, dynamic>> stocksJson =
        stockProvider.stocks.map((stock) => stock.toJson()).toList();
    prefs.setString('saved_stocks', json.encode(stocksJson));
  }

  void _showAddStockSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Add Stock",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _symbolController,
                decoration: const InputDecoration(labelText: "Stock Symbol"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _addStock,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text("Add Stock"),
              ),
            ],
          ),
        );
      },
    );
  }

  void _addStock() async {
    String symbol = _symbolController.text.trim().toUpperCase();

    if (symbol.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      final stockData = await ApiService.fetchStockData([symbol]);
      if (stockData.isNotEmpty) {
        final stock = stockData.first;

        Provider.of<StockProvider>(context, listen: false).addStock(stock);
        await _saveStocks(); // Save stocks locally
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Invalid stock symbol"),
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error: $e"),
        backgroundColor: Colors.red,
      ));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final stockProvider = Provider.of<StockProvider>(context);

    double totalPortfolioValue = stockProvider.getTotalPortfolioValue();
    double totalCO2Impact = stockProvider.getTotalCO2Impact();
    double greenScore = stockProvider.getGreenScore(); // 0-100 scale

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sustainability Dashboard"),
        actions: [InkWell(onTap: () {}, child: Icon(Icons.add))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCard("Green Score", "${greenScore.toStringAsFixed(1)} / 100"),
            _buildCard("Portfolio Value",
                "\$${totalPortfolioValue.toStringAsFixed(2)}"),
            _buildCard(
                "CO₂ Impact", "${totalCO2Impact.toStringAsFixed(2)} kg CO₂"),
            const SizedBox(height: 20),
            Expanded(
              child: stockProvider.stocks.isEmpty
                  ? const Center(child: Text("No stocks added"))
                  : ListView.builder(
                      itemCount: stockProvider.stocks.length,
                      itemBuilder: (context, index) {
                        final stock = stockProvider.stocks[index];
                        return Card(
                          child: ListTile(
                            title: Text(stock.name ?? "Unknown"),
                            subtitle: Text(
                                "Price: \$${double.tryParse(stock.close ?? '0')?.toStringAsFixed(2) ?? 'N/A'}"),
                            trailing: Text(
                              "${double.tryParse(stock.percentChange?.toString() ?? '0')?.toStringAsFixed(2) ?? '0'}%",
                              style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddStockSheet,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCard(String title, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: Text(value,
            style: const TextStyle(fontSize: 18, color: Colors.green)),
      ),
    );
  }
}
