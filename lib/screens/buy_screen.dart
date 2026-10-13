import 'package:flutter/material.dart';
import '../state/app_state.dart';
import 'buy_order_screen.dart';
import 'offer_card.dart';

class BuyScreen extends StatelessWidget {
  const BuyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        final offers = appState.activeOffers;
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Crypto kaufen', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            if (offers.isEmpty) const Text('Keine Angebote verfügbar.'),
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
