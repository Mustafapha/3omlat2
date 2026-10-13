enum CryptoType { btc, eth, usdt }

extension CryptoInfo on CryptoType {
  String get symbol => name.toUpperCase();

  // ID bei CoinGecko (öffentliche Price-API)
  String get geckoId {
    switch (this) {
      case CryptoType.btc:
        return 'bitcoin';
      case CryptoType.eth:
        return 'ethereum';
      case CryptoType.usdt:
        return 'tether';
    }
  }
}

class User {
  final String name;
  const User(this.name);
}

/// Angebot eines Verkäufers. Der Preis (MAD pro Coin) ist der P2P-Preis.
class Offer {
  final String id;
  final String seller;
  final CryptoType crypto;
  double amount; // verfügbare Menge
  double price; // Seller Price in MAD
  String paymentMethod;
  double minMad;
  double maxMad;
  bool active;

  Offer({
    required this.id,
    required this.seller,
    required this.crypto,
    required this.amount,
    required this.price,
    required this.paymentMethod,
    required this.minMad,
    required this.maxMad,
    this.active = true,
  });
}

enum OrderStatus { pending, paymentPending, processing, completed, cancelled }

extension OrderStatusLabel on OrderStatus {
  String get label {
    switch (this) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.paymentPending:
        return 'Payment Pending';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.completed:
        return 'Completed';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }
}

class Order {
  final String id;
  final String buyer;
  final String seller;
  final CryptoType crypto;
  final double amount;
  final double p2pPrice;
  final double marketPrice; // Snapshot zum Zeitpunkt der Order
  final double subtotal;
  final double commission;
  final double total;
  final DateTime date;
  OrderStatus status;

  Order({
    required this.id,
    required this.buyer,
    required this.seller,
    required this.crypto,
    required this.amount,
    required this.p2pPrice,
    required this.marketPrice,
    required this.subtotal,
    required this.commission,
    required this.total,
    required this.date,
    this.status = OrderStatus.pending,
  });
}
