import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../services/commission.dart';
import '../services/price_service.dart';

/// Einfacher globaler Zustand. Später durch Backend/Datenbank ersetzbar.
final AppState appState = AppState();

class AppState extends ChangeNotifier {
  static const User me = User('Du');

  final PriceService _priceService = PriceService();
  Timer? _timer;
  int _idCounter = 1;

  Map<CryptoType, double> marketPrices = Map.of(PriceService.demoPrices);
  bool loading = false;
  bool usingDemoPrices = true;
  String? error;
  DateTime? lastUpdate;

  final List<Offer> offers = [
    Offer(id: 'o1', seller: 'Ahmed', crypto: CryptoType.usdt, amount: 1000, price: 10.00, paymentMethod: 'Banküberweisung', minMad: 100, maxMad: 5000),
    Offer(id: 'o2', seller: 'Youssef', crypto: CryptoType.usdt, amount: 500, price: 10.10, paymentMethod: 'CIH Bank', minMad: 100, maxMad: 3000),
    Offer(id: 'o3', seller: 'Sara', crypto: CryptoType.btc, amount: 0.05, price: 1020000, paymentMethod: 'Banküberweisung', minMad: 1000, maxMad: 50000),
  ];
  final List<Order> orders = [];

  void start() {
    loadPrices();
    _timer ??= Timer.periodic(const Duration(seconds: 60), (_) => loadPrices());
  }

  Future<void> loadPrices() async {
    if (loading) return;
    loading = true;
    notifyListeners();
    try {
      marketPrices = await _priceService.fetchPrices();
      usingDemoPrices = false;
      error = null;
      lastUpdate = DateTime.now();
    } catch (e) {
      // Fallback: letzte bekannte Preise bzw. Demo-Preise bleiben erhalten
      error = 'Live-Preise nicht erreichbar. ${usingDemoPrices ? 'Demo-Preise' : 'Letzte bekannte Preise'} werden angezeigt.';
    }
    loading = false;
    notifyListeners();
  }

  List<Offer> get activeOffers =>
      offers.where((o) => o.active && o.amount > 0).toList();
  List<Offer> get myOffers =>
      offers.where((o) => o.seller == me.name).toList();

  void createOffer({
    required CryptoType crypto,
    required double amount,
    required double price,
    required String paymentMethod,
    required double minMad,
    required double maxMad,
  }) {
    offers.insert(
      0,
      Offer(
        id: 'o${_idCounter++}_${DateTime.now().millisecondsSinceEpoch}',
        seller: me.name,
        crypto: crypto,
        amount: amount,
        price: price,
        paymentMethod: paymentMethod,
        minMad: minMad,
        maxMad: maxMad,
      ),
    );
    notifyListeners();
  }

  void toggleOffer(Offer o) {
    o.active = !o.active;
    notifyListeners();
  }

  void deleteOffer(Offer o) {
    offers.remove(o);
    notifyListeners();
  }

  void createOrder(Offer offer, double qty) {
    final subtotal = qty * offer.price;
    final commission = Commission.of(subtotal);
    offer.amount -= qty;
    orders.insert(
      0,
      Order(
        id: 'ORD-${1000 + _idCounter++}',
        buyer: me.name,
        seller: offer.seller,
        crypto: offer.crypto,
        amount: qty,
        p2pPrice: offer.price,
        marketPrice: marketPrices[offer.crypto]!,
        subtotal: subtotal,
        commission: commission,
        total: subtotal + commission,
        date: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  void setStatus(Order o, OrderStatus s) {
    o.status = s;
    notifyListeners();
  }
}
