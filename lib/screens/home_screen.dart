import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/format.dart';
import '../state/app_state.dart';
import 'buy_order_screen.dart';
import 'offer_card.dart';

class HomeScreen extends StatelessWidget {
  final void Function(int) onNavigate;
  const HomeScreen({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        final offers = appState.activeOffers.take(3).toList();
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(children: [
              const Icon(Icons.currency_exchange, color: Color(0xFF00C853), size: 32),
              const SizedBox(width: 8),
              Text('P2P Demo', style: Theme.of(context).textTheme.headlineSmall),
              const Spacer(),
              appState.loading
                  ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                  : IconButton(onPressed: appState.loadPrices, icon: const Icon(Icons.refresh)),
            ]),
            const SizedBox(height: 8),
            if (appState.error != null)
              Card(
                color: Theme.of(context).colorScheme.errorContainer,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(appState.error!),
                ),
              ),
            Text('Marktpreise', style: Theme.of(context).textTheme.titleMedium),
            for (final c in CryptoType.values)
              Card(
                child: ListTile(
                  title: Text(c.symbol),
                  trailing: Text(fmtMad(appState.marketPrices[c]!),
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            Text(
              appState.usingDemoPrices
                  ? 'Quelle: Demo-Preise'
                  : 'Quelle: CoinGecko, Stand ${fmtDate(appState.lastUpdate!)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            Row(children: [
              Expanded(
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
                  onPressed: () => onNavigate(1),
                  icon: const Icon(Icons.shopping_cart),
                  label: const Text('Crypto kaufen'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.tonalIcon(
                  style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
                  onPressed: () => onNavigate(2),
                  icon: const Icon(Icons.sell),
                  label: const Text('Crypto verkaufen'),
                ),
              ),
            ]),
            const SizedBox(height: 16),
            Text('Aktuelle P2P-Angebote', style: Theme.of(context).textTheme.titleMedium),
            for (final o in offers)
              OfferCard(
                offer: o,
                onBuy: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => BuyOrderScreen(offer: o)),
                ),
              ),
          ],
        );
      },
    );
  }
}
