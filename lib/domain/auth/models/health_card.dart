class HealthCard {
  String _cardNumber;
  String? _cardPassword;

  HealthCard(this._cardNumber, [this._cardPassword]);

  String get cardNumber => _cardNumber;
  String get cardPassword => _cardPassword!;

  // Because Firebase only let us login user with email and password
  // We fake card number as email to login user
  String get cardNumberAsEmail => _cardNumber + "@something.coms";
}
