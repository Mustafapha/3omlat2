/// Zentrale Commission-Berechnung. Rate später einfach änderbar.
class Commission {
  static double rate = 0.02; // 2 %

  static double of(double subtotal) => subtotal * rate;
  static double total(double subtotal) => subtotal + of(subtotal);
}
