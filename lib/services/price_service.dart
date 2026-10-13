import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/models.dart';

/// Kapselt den API-Aufruf. Kein API-Key nötig (CoinGecko, kostenlos).
class PriceService {
  static final Map<CryptoType, double> demoPrices = {
    CryptoType.btc: 1000000,
    CryptoType.eth: 35000,
    CryptoType.usdt: 10,
  };

  Future<Map<CryptoType, double>> fetchPrices() async {
    final ids = CryptoType.values.map((c) => c.geckoId).join(',');
    final uri = Uri.parse(
        'https://api.coingecko.com/api/v3/simple/price?ids=$ids&vs_currencies=mad');
    final response = await http.get(uri).timeout(const Duration(seconds: 10));
    if (response.statusCode != 200) {
      throw Exception('API Status ${response.statusCode}');
    }
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final result = <CryptoType, double>{};
    for (final c in CryptoType.values) {
      final value = (data[c.geckoId] as Map<String, dynamic>?)?['mad'];
      if (value == null) throw Exception('Preis für ${c.symbol} fehlt');
      result[c] = (value as num).toDouble();
    }
    return result;
  }
}
