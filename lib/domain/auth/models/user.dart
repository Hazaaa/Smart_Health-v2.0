import 'package:smart_health_v2/domain/auth/models/health_card.dart';
import 'package:smart_health_v2/domain/auth/models/user_details.dart';

class User {
  final String userId;
  final String? email;

  // ignore: unused_field
  HealthCard? _userHealthCard;
  UserDetails? _userDetails;

  User(this.userId, this.email) {
    _userHealthCard = HealthCard(email!.split('@')[0]);
  }

  set userDetails(value) {
    _userDetails = value;
  }

  UserDetails get userDetails => _userDetails!;
}
