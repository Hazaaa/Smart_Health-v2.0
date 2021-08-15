import 'package:smart_health_v2/domain/auth/models/health_card.dart';

class User {
  final String userId;
  final String? email;

  // ignore: unused_field
  HealthCard? _userHealthCard;

  User(this.userId, this.email) {
    _userHealthCard = HealthCard(email!.split('@')[0]);
  }
}
