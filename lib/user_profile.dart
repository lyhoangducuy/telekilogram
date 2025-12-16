import 'package:flutter/material.dart';
import 'package:telekilogram/HomePage.dart';
import 'package:telekilogram/login&register/my_Login_Page.dart';

class UserProfile extends StatelessWidget {
  final Map<String, dynamic> userData;
  const UserProfile({super.key, required this.userData});

  static const _hiddenKeys = {
    'refreshToken',
    'refresh_token',
    'image',
  };

  @override
  Widget build(BuildContext context) {
    final displayName =
        (userData['name'] as String?) ??
        (userData['username'] as String?) ??
        'Người dùng';

    final username = userData['username'] as String?;
    final email = userData['email'] as String?;
    final id = userData['id']?.toString();
    final accessToken = userData['accessToken'] as String?;
    final avatarUrl = userData['image'] as String?;

    final details = userData.entries
        .where((e) => !_hiddenKeys.contains(e.key))
        .where((e) =>
            e.key != 'name' &&
            e.key != 'username' &&
            e.key != 'email' &&
            e.key != 'id' &&
            e.key != 'accessToken')
        .toList();

    return Scaffold(
      drawer: const AppNavigationDrawer(),
      appBar: AppBar(
        title: const Text('Thông tin người dùng'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ===== HEADER =====
              Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor:
                        Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    backgroundImage:
                        (avatarUrl != null && avatarUrl.isNotEmpty)
                            ? NetworkImage(avatarUrl)
                            : null,
                    child: (avatarUrl == null || avatarUrl.isEmpty)
                        ? Text(
                            displayName[0].toUpperCase(),
                            style: TextStyle(
                              fontSize: 32,
                              color:
                                  Theme.of(context).colorScheme.primary,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    displayName,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  if (username != null)
                    Text(
                      '@$username',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                ],
              ),

              const SizedBox(height: 20),

              // ===== CARD INFO =====
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Chi tiết tài khoản',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 12),

                      if (email != null) Text('Email: $email'),
                      if (id != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text('ID: $id'),
                        ),

                      if (details.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        const Divider(),
                        ...details.map(
                          (e) => Padding(
                            padding:
                                const EdgeInsets.symmetric(vertical: 6),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    e.key,
                                    style: const TextStyle(
                                        color: Colors.black54),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    e.value?.toString() ?? '',
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],

                      // ===== TOKEN =====
                      if (accessToken != null) ...[
                        const SizedBox(height: 12),
                        const Divider(),
                        const Text(
                          'Access Token',
                          style: TextStyle(
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 6),
                        SelectableText(
                          accessToken,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ===== BUTTONS =====
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Đóng'),
              ),

              const SizedBox(height: 10),

              OutlinedButton.icon(
                icon: const Icon(Icons.logout),
                label: const Text('Đăng xuất'),
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (_) => const LoginPage()),
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
