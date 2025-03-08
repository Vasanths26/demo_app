import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Service/stock_services.dart';
import '../model/stock_model.dart'; // Ensure lowercase folder

class StockProvider extends ChangeNotifier {
  List<StockModelClass> _stocks = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<StockModelClass> get stocks => _stocks;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchStockData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      print("Fetching stock symbols...");
      List<String> symbolList = await ApiService.fetchStockSymbols("NSE");

      if (symbolList.isEmpty) {
        _errorMessage = "No symbols found.";
        print("No symbols retrieved from API.");
        _isLoading = false;
        notifyListeners();
        return;
      }

      print("Fetching stock data...");
      _stocks = await ApiService.fetchStockData(symbolList);

      if (_stocks.isEmpty) {
        _errorMessage = "No stock data available.";
        print("No stock data retrieved from API.");
      } else {
        print("Stock data fetched: $_stocks");
      }
    } catch (e) {
      _errorMessage = "Error fetching stock data: $e";
      print("Error fetching data: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void addStock(StockModelClass stock) {
    _stocks.add(stock);
    notifyListeners();
  }

  void removeStock(String symbol) {
    _stocks.removeWhere((stock) => stock.symbol == symbol);
    notifyListeners();
  }

  void setStocks(List<StockModelClass> stocks) {
    _stocks = stocks;
    notifyListeners();
  }

  double getTotalPortfolioValue() {
    return _stocks.fold(
        0, (sum, stock) => sum + double.parse((stock.close ?? 0).toString()));
  }

  double getTotalCO2Impact() {
    return _stocks.fold(
        0,
        (sum, stock) =>
            sum + double.parse((10).toString()) * double.parse(('1')));
  }

  double getGreenScore() {
    if (_stocks.isEmpty) return 0;
    double totalScore = _stocks.fold(0, (sum, stock) => sum + (50));
    return totalScore / _stocks.length;
  }
}

class StockScreen extends StatefulWidget {
  const StockScreen({super.key});

  @override
  State<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StockProvider()..fetchStockData(),
      child: Scaffold(
        appBar: AppBar(title: const Text("Stock Tracker")),
        body: Consumer<StockProvider>(
          builder: (context, stockProvider, child) {
            if (stockProvider.isLoading) {
              print('object');
              return const Center(child: CircularProgressIndicator());
            } else if (stockProvider.errorMessage != null) {
              return Center(child: Text(stockProvider.errorMessage!));
            } else if (stockProvider.stocks.isEmpty) {
              return const Center(child: Text("No data available"));
            }

            return ListView.builder(
              itemCount: stockProvider.stocks.length,
              itemBuilder: (context, index) {
                StockModelClass stock = stockProvider.stocks[index];

                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(stock.name ?? "Unknown",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    subtitle: Text(
                        "Price: \$${double.tryParse(stock.close ?? '0')?.toStringAsFixed(2) ?? 'N/A'}"),
                    trailing: Text(
                      "${double.tryParse(stock.percentChange?.toString() ?? '0')?.toStringAsFixed(2) ?? '0'}%",
                      style: TextStyle(
                        color: (double.tryParse(stock.change ?? '0') ?? 0) >= 0
                            ? Colors.green
                            : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
