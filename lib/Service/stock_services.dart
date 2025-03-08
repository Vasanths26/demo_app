import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/stock_model.dart'; // Import your Data model

class ApiService {
  static const String _apiKey = "662f6f006f6640eb9bd56e13ec5419e1";
  static const String _token = "cv5uv7hr01qn84a2d9i0cv5uv7hr01qn84a2d9ig";
  static const String _symbolUrl = "https://finnhub.io/api/v1/stock";
  static const String _stockUrl = "https://api.twelvedata.com/quote";

  /// Fetches stock symbols dynamically
  static Future<List<String>> fetchStockSymbols(String exchange) async {
    final Uri url = Uri.parse("$_symbolUrl/symbol?exchange=US&token=$_token");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final decodedResponse = json.decode(response.body);

      if (decodedResponse is List) {
        return decodedResponse
            .map((stock) => stock["symbol"].toString()) // Extract symbols
            .toList();
      } else if (decodedResponse is Map<String, dynamic> &&
          decodedResponse.containsKey("data")) {
        return (decodedResponse["data"] as List)
            .map((stock) => stock["symbol"].toString())
            .take(10)
            .toList();
      }
    }
    throw Exception("Failed to fetch stock symbols");
  }

  /// Fetches stock data for the given symbols
  static Future<List<StockModelClass>> fetchStockData(
      List<String> symbols) async {
    List<StockModelClass> stockList = [];

    final List<String> limitedSymbols =
        symbols.take(7).toList(); // Get only first 10 symbols

    for (String symbol in limitedSymbols) {
      try {
        final Uri url = Uri.parse("$_stockUrl?symbol=$symbol&apikey=$_apiKey");
        print("Fetching data for: $symbol");
        print("API URL: $url");

        final response = await http.get(url);
        await Future.delayed(Duration(seconds: 5));
        print("Response Status for $symbol: ${response.statusCode}");
        print("Response Body for $symbol: ${response.body}");

        if (response.statusCode == 200) {
          final Map<String, dynamic> jsonResponse = json.decode(response.body);

          if (jsonResponse.isNotEmpty) {
            final stock = StockModelClass.fromJson(jsonResponse);
          if (stock.name != null && stock.name!.isNotEmpty && stock.name != "Unknown") {
            stockList.add(stock); //Only add valid stocks
          } else {
            print("Skipping stock with 'Unknown' name: $symbol");
          }
          } else {
            print("Empty response for: $symbol (Skipping)");
          }
        } else {
          print(
              "API request failed for $symbol with status: ${response.statusCode}");
        }
      } catch (e) {
        print("Error fetching data for $symbol: $e");
      }
    }

    return stockList;
  }
}
