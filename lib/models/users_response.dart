import 'package:telekilogram/models/user.dart';

class UsersResponse {
  final List<UserModel> users;
  final int total;
  final int skip;
  final int limit;

  UsersResponse({
    required this.users,
    required this.total,
    required this.skip,
    required this.limit,
  });

  factory UsersResponse.fromJson(Map<String, dynamic> json) {
    final list = (json["users"] as List? ?? []);
    return UsersResponse(
      users: list.map((e) => UserModel.fromJson(e as Map<String, dynamic>)).toList(),
      total: (json["total"] ?? 0) as int,
      skip: (json["skip"] ?? 0) as int,
      limit: (json["limit"] ?? 0) as int,
    );
  }
}
