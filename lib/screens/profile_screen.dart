import 'package:flutter/material.dart';
import '../services/commission.dart';
import '../state/app_state.dart';
import 'offer_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        final mine = appState.myOffers;
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const ListTile(
              leading: CircleAvatar(child: Icon(Icons.person)),
              title: Text('Du (Demo-Nutzer)'),
              subtitle: Text('Kein Login in dieser Version'),
            ),
            ListTile(
              leading: const Icon(Icons.percent),
              title: const Text('Commission'),
              subtitle: Text('${(Commission.rate * 100).toStringAsFixed(0)} % pro Trade'),
            ),
            const Divider(),
            Text('Meine Angebote', style: Theme.of(context).textTheme.titleMedium),
            if (mine.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text('Du hast noch kein Angebot veröffentlicht.'),
              ),
            for (final o in mine)
              Column(children: [
                OfferCard(offer: o),
                Row(children: [
                  const SizedBox(width: 8),
                  const Text('Aktiv'),
                  Switch(value: o.active, onChanged: (_) => appState.toggleOffer(o)),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () => appState.deleteOffer(o),
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Löschen'),
                  ),
                ]),
              ]),
          ],
        );
      },
    );
  }
}
