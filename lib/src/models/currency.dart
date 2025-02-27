class Currency {
  Currency({
    required this.code,
    required this.symbol,
    required this.decimals,
    required this.pos,
  });

  final String code;
  final String symbol;
  final int decimals;
  final String pos;

  factory Currency.fromJson(Map<dynamic, dynamic> json) => Currency(
        code: json["code"],
        symbol: json["symbol"],
        decimals: json["decimals"],
        pos: json["pos"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "symbol": symbol,
        "decimals": decimals,
        "pos": pos,
      };

  Currency copyWith({
    String? code,
    String? symbol,
    int? decimals,
    String? pos,
  }) {
    return Currency(
      code: code ?? this.code,
      symbol: symbol ?? this.symbol,
      decimals: decimals ?? this.decimals,
      pos: pos ?? this.pos,
    );
  }
}
