import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/format.dart';
import '../state/app_state.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        final orders = appState.orders;
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Meine Orders', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            if (orders.isEmpty) const Text('Noch keine Orders. Erstelle eine im Tab Kaufen.'),
            for (final o in orders) _OrderCard(order: o),
          ],
        );
      },
    );
  }
}

class _OrderCard extends StatelessWidget {
  final Order order;
  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final o = order;
    final sym = o.crypto.symbol;
    final isBuy = o.buyer == AppState.me.name;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Text(o.id, style: Theme.of(context).textTheme.titleMedium),
              const Spacer(),
              Chip(label: Text(isBuy ? 'Kauf' : 'Verkauf')),
            ]),
            Text('Käufer: ${o.buyer}  ·  Verkäufer: ${o.seller}'),
            Text('${fmtQty(o.amount)} $sym'),
            Text('P2P-Preis: ${fmtMad(o.p2pPrice)}  ·  Markt: ${fmtMad(o.marketPrice)}'),
            Text('Subtotal: ${fmtMad(o.subtotal)}'),
            Text('Commission: ${fmtMad(o.commission)}'),
            Text('Total: ${fmtMad(o.total)}', style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('Datum: ${fmtDate(o.date)}'),
            const SizedBox(height: 8),
            Row(children: [
              const Text('Status: '),
              DropdownButton<OrderStatus>(
                value: o.status,
                items: [
                  for (final s in OrderStatus.values)
                    DropdownMenuItem(value: s, child: Text(s.label)),
                ],
                onChanged: (s) => appState.setStatus(o, s!),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
