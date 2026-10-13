import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/commission.dart';
import '../services/format.dart';
import '../state/app_state.dart';

class BuyOrderScreen extends StatefulWidget {
  final Offer offer;
  const BuyOrderScreen({super.key, required this.offer});

  @override
  State<BuyOrderScreen> createState() => _BuyOrderScreenState();
}

class _BuyOrderScreenState extends State<BuyOrderScreen> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  double get _qty => parseNum(_ctrl.text) ?? 0;

  String? get _error {
    final o = widget.offer;
    if (_ctrl.text.isEmpty) return null;
    if (_qty <= 0) return 'Bitte eine gültige Menge eingeben';
    if (_qty > o.amount) return 'Mehr als verfügbar (${fmtQty(o.amount)})';
    final sub = _qty * o.price;
    if (sub < o.minMad) return 'Mindestbetrag: ${fmtMad(o.minMad)}';
    if (sub > o.maxMad) return 'Höchstbetrag: ${fmtMad(o.maxMad)}';
    return null;
  }

  bool get _valid => _qty > 0 && _error == null;

  @override
  Widget build(BuildContext context) {
    final o = widget.offer;
    final sym = o.crypto.symbol;
    final subtotal = _qty * o.price;
    return Scaffold(
      appBar: AppBar(title: const Text('Order erstellen')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Verkäufer: ${o.seller}'),
          Text('Crypto: $sym'),
          Text('Verfügbar: ${fmtQty(o.amount)} $sym'),
          Text('P2P-Preis: ${fmtMad(o.price)} / $sym'),
          Text('Marktpreis: ${fmtMad(appState.marketPrices[o.crypto]!)} / $sym'),
          const SizedBox(height: 16),
          TextField(
            controller: _ctrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: 'Menge in $sym',
              border: const OutlineInputBorder(),
              errorText: _error,
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                _row('Subtotal', fmtMad(subtotal)),
                _row('Commission (${(Commission.rate * 100).toStringAsFixed(0)} %)',
                    fmtMad(Commission.of(subtotal))),
                const Divider(),
                _row('Total', fmtMad(Commission.total(subtotal)), bold: true),
              ]),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
            onPressed: _valid
                ? () {
                    appState.createOrder(o, _qty);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Demo-Order erstellt (siehe Tab Orders)')),
                    );
                  }
                : null,
            child: const Text('Order erstellen'),
          ),
          const SizedBox(height: 8),
          Text('Demo: Es findet keine echte Zahlung statt.',
              style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }

  Widget _row(String l, String r, {bool bold = false}) {
    final style = TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(children: [
        Text(l, style: style),
        const Spacer(),
        Text(r, style: style),
      ]),
    );
  }
}
