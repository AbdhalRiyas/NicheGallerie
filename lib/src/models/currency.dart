class Currency {
  Currency({
    required this.code,
    required this.symbol,
    required this.decimals,
    required this.pos,
    required this.rate,
    required this.exchangeFeeType,
    required this.exchangeFee,
  });

  final String code, symbol, pos, exchangeFeeType;
  final int decimals;
  final double rate, exchangeFee;

  factory Currency.fromJson(Map<dynamic, dynamic> json) => Currency(
      code: json["code"],
      symbol: json["symbol"],
      decimals: json["decimals"] ?? 0,
      pos: json["pos"],
      rate: double.tryParse(json["rate"]) ?? 1.0,
      exchangeFeeType: json["exchange_fee_type"],
      exchangeFee: double.tryParse(json["exchange_fee"]) ?? 0.00);

  Map<String, dynamic> toJson() => {
        "code": code,
        "symbol": symbol,
        "decimals": decimals,
        "pos": pos,
        "rate": rate,
        "exchange_fee_type": exchangeFeeType,
        "exchange_fee": exchangeFee,
      };

  Currency copyWith({
    String? code,
    String? symbol,
    int? decimals,
    String? pos,
    double? rate,
    String? exchangeFeeType,
    double? exchangeFee,
  }) {
    return Currency(
      code: code ?? this.code,
      symbol: symbol ?? this.symbol,
      decimals: decimals ?? this.decimals,
      pos: pos ?? this.pos,
      rate: rate ?? this.rate,
      exchangeFeeType: exchangeFeeType ?? this.exchangeFeeType,
      exchangeFee: exchangeFee ?? this.exchangeFee,
    );
  }
}
