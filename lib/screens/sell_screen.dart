import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/format.dart';
import '../state/app_state.dart';

class SellScreen extends StatefulWidget {
  const SellScreen({super.key});

  @override
  State<SellScreen> createState() => _SellScreenState();
}

class _SellScreenState extends State<SellScreen> {
  final _formKey = GlobalKey<FormState>();
  CryptoType _crypto = CryptoType.usdt;
  final _amount = TextEditingController();
  final _price = TextEditingController();
  final _min = TextEditingController();
  final _max = TextEditingController();
  String _method = 'Banküberweisung';
  static const _methods = ['Banküberweisung', 'CIH Bank', 'Cash Plus', 'Wafacash'];

  @override
  void dispose() {
    for (final c in [_amount, _price, _min, _max]) {
      c.dispose();
    }
    super.dispose();
  }

  String? _positive(String? v) {
    final n = parseNum(v ?? '');
    return (n == null || n <= 0) ? 'Bitte eine Zahl > 0 eingeben' : null;
  }

  void _publish() {
    if (!_formKey.currentState!.validate()) return;
    final min = parseNum(_min.text)!;
    final max = parseNum(_max.text)!;
    if (min > max) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mindestbetrag darf nicht größer als Höchstbetrag sein')),
      );
      return;
    }
    appState.createOffer(
      crypto: _crypto,
      amount: parseNum(_amount.text)!,
      price: parseNum(_price.text)!,
      paymentMethod: _method,
      minMad: min,
      maxMad: max,
    );
    _formKey.currentState!.reset();
    for (final c in [_amount, _price, _min, _max]) {
      c.clear();
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Angebot veröffentlicht (siehe Tab Kaufen)')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        final market = appState.marketPrices[_crypto]!;
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Angebot erstellen', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(children: [
                DropdownButtonFormField<CryptoType>(
                  value: _crypto,
                  decoration: const InputDecoration(labelText: 'Crypto', border: OutlineInputBorder()),
                  items: [
                    for (final c in CryptoType.values)
                      DropdownMenuItem(value: c, child: Text(c.symbol)),
                  ],
                  onChanged: (v) => setState(() => _crypto = v!),
                ),
                const SizedBox(height: 12),
                _field(_amount, 'Menge in ${_crypto.symbol}'),
                _field(_price, 'Dein Preis in MAD pro ${_crypto.symbol}',
                    helper: 'Marktpreis (Referenz): ${fmtMad(market)}'),
                DropdownButtonFormField<String>(
                  value: _method,
                  decoration: const InputDecoration(labelText: 'Zahlungsmethode', border: OutlineInputBorder()),
                  items: [for (final m in _methods) DropdownMenuItem(value: m, child: Text(m))],
                  onChanged: (v) => setState(() => _method = v!),
                ),
                const SizedBox(height: 12),
                _field(_min, 'Mindestbetrag (MAD)'),
                _field(_max, 'Höchstbetrag (MAD)'),
                FilledButton(
                  style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
                  onPressed: _publish,
                  child: const Text('Angebot veröffentlichen'),
                ),
              ]),
            ),
          ],
        );
      },
    );
  }

  Widget _field(TextEditingController c, String label, {String? helper}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: c,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: label,
          helperText: helper,
          border: const OutlineInputBorder(),
        ),
        validator: _positive,
      ),
    );
  }
}
