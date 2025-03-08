class StockModelClass {
  String? symbol;
  String? name;
  String? exchange;
  String? micCode;
  String? currency;
  String? datetime;
  int? timestamp;
  String? open;
  String? high;
  String? low;
  String? close;
  String? volume;
  String? previousClose;
  String? change;
  String? percentChange;
  String? averageVolume;
  bool? isMarketOpen;
  FiftyTwoWeek? fiftyTwoWeek;

  StockModelClass(
      {this.symbol,
      this.name,
      this.exchange,
      this.micCode,
      this.currency,
      this.datetime,
      this.timestamp,
      this.open,
      this.high,
      this.low,
      this.close,
      this.volume,
      this.previousClose,
      this.change,
      this.percentChange,
      this.averageVolume,
      this.isMarketOpen,
      this.fiftyTwoWeek});

  StockModelClass.fromJson(Map<String, dynamic> json) {
    symbol = json['symbol'];
    name = json['name'];
    exchange = json['exchange'];
    micCode = json['mic_code'];
    currency = json['currency'];
    datetime = json['datetime'];
    timestamp = json['timestamp'];
    open = json['open'];
    high = json['high'];
    low = json['low'];
    close = json['close'];
    volume = json['volume'];
    previousClose = json['previous_close'];
    change = json['change'];
    percentChange = json['percent_change'];
    averageVolume = json['average_volume'];
    isMarketOpen = json['is_market_open'];
    fiftyTwoWeek = json['fifty_two_week'] != null
        ? FiftyTwoWeek.fromJson(json['fifty_two_week'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['symbol'] = symbol;
    data['name'] = name;
    data['exchange'] = exchange;
    data['mic_code'] = micCode;
    data['currency'] = currency;
    data['datetime'] = datetime;
    data['timestamp'] = timestamp;
    data['open'] = open;
    data['high'] = high;
    data['low'] = low;
    data['close'] = close;
    data['volume'] = volume;
    data['previous_close'] = previousClose;
    data['change'] = change;
    data['percent_change'] = percentChange;
    data['average_volume'] = averageVolume;
    data['is_market_open'] = isMarketOpen;
    if (fiftyTwoWeek != null) {
      data['fifty_two_week'] = fiftyTwoWeek!.toJson();
    }
    return data;
  }
}

class FiftyTwoWeek {
  String? low;
  String? high;
  String? lowChange;
  String? highChange;
  String? lowChangePercent;
  String? highChangePercent;
  String? range;

  FiftyTwoWeek(
      {this.low,
      this.high,
      this.lowChange,
      this.highChange,
      this.lowChangePercent,
      this.highChangePercent,
      this.range});

  FiftyTwoWeek.fromJson(Map<String, dynamic> json) {
    low = json['low'];
    high = json['high'];
    lowChange = json['low_change'];
    highChange = json['high_change'];
    lowChangePercent = json['low_change_percent'];
    highChangePercent = json['high_change_percent'];
    range = json['range'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['low'] = low;
    data['high'] = high;
    data['low_change'] = lowChange;
    data['high_change'] = highChange;
    data['low_change_percent'] = lowChangePercent;
    data['high_change_percent'] = highChangePercent;
    data['range'] = range;
    return data;
  }
}