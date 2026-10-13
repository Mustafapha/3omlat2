import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/format.dart';
import '../state/app_state.dart';

/// Wiederverwendbare Karte: zeigt Seller Price vs. Market Price.
class OfferCard extends StatelessWidget {
  final Offer offer;
  final VoidCallback? onBuy;
  const OfferCard({super.key, required this.offer, this.onBuy});

  @override
  Widget build(BuildContext context) {
    final market = appState.marketPrices[offer.crypto]!;
    final diff = (offer.price - market) / market * 100;
    final sym = offer.crypto.symbol;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Text(offer.seller, style: Theme.of(context).textTheme.titleMedium),
              const Spacer(),
              Chip(label: Text(sym)),
            ]),
            Text('${fmtQty(offer.amount)} $sym verfügbar'),
            const SizedBox(height: 8),
            Text('Seller Price: ${fmtMad(offer.price)} / $sym',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(
              'Market Price: ${fmtMad(market)} (${diff >= 0 ? '+' : ''}${diff.toStringAsFixed(1)} %)',
              style: TextStyle(color: Theme.of(context).hintColor),
            ),
            const SizedBox(height: 8),
            Text('Zahlung: ${offer.paymentMethod}'),
            Text('Min: ${fmtMad(offer.minMad)}  ·  Max: ${fmtMad(offer.maxMad)}'),
            if (onBuy != null) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton(onPressed: onBuy, child: const Text('Kaufen')),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
