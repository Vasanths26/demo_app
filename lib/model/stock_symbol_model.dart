class StockSymbolModel {
  // String? currency;
  // String? description;
  // String? displaySymbol;
  // String? figi;
  // Null? isin;
  // String? mic;
  // String? shareClassFIGI;
  String? symbol;
  // String? symbol2;
  // String? type;

  StockSymbolModel(
      {
      // this.currency,
      // this.description,
      // this.displaySymbol,
      // this.figi,
      // this.isin,
      // this.mic,
      // this.shareClassFIGI,
      this.symbol,
      // this.symbol2,
      // this.type
      });

  StockSymbolModel.fromJson(Map<String, dynamic> json) {
    // currency = json['currency'];
    // description = json['description'];
    // displaySymbol = json['displaySymbol'];
    // figi = json['figi'];
    // isin = json['isin'];
    // mic = json['mic'];
    // shareClassFIGI = json['shareClassFIGI'];
    symbol = json['symbol'];
    // symbol2 = json['symbol2'];
    // type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    // data['currency'] = this.currency;
    // data['description'] = this.description;
    // data['displaySymbol'] = this.displaySymbol;
    // data['figi'] = this.figi;
    // data['isin'] = this.isin;
    // data['mic'] = this.mic;
    // data['shareClassFIGI'] = this.shareClassFIGI;
    data['symbol'] = symbol;
    // data['symbol2'] = this.symbol2;
    // data['type'] = this.type;
    return data;
  }
}