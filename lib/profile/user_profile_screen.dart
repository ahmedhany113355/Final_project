
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_ecommerce_app/providers/auth_provider.dart' as my_auth;
import 'package:my_ecommerce_app/models/user_model.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<my_auth.AuthProvider>(context);
    final UserModel? user = authProvider.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('����� ������')),
        body:
            const Center(child: Text('������ ����� ������ ���� ���� ������.')),
      );
    }

    String initials = '';
    if (user.firstName.isNotEmpty == true) {
      initials += user.firstName[0].toUpperCase();
    }
    if (user.lastName.isNotEmpty == true) {
      initials += user.lastName[0].toUpperCase();
    }

    return Scaffold(
      appBar: AppBar(title: const Text('��� �������� ������')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Theme.of(context)
                    .colorScheme
                    .primary
                    .withAlpha((255 * 0.2).round()),
                child: initials.isNotEmpty
                    ? Text(
                        initials,
                        style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54),
                      )
                    : const Icon(Icons.person, size: 50, color: Colors.black54),
              ),
            ),
            const SizedBox(height: 24.0),
            _buildProfileInfoRow(
                '����� ������:', '${user.firstName} ${user.lastName}'),
            _buildProfileInfoRow('������ ����������:', user.email),
            _buildProfileInfoRow('������:', user.phone),
            _buildProfileInfoRow('�������:', user.address),
            _buildProfileInfoRow('�����:', user.gender),
            _buildProfileInfoRow(
                '����� �������:',
                user.birthdate?.toLocal().toString().split(' ')[0] ??
                    '��� �����'),
            const SizedBox(height: 32.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  if (!context.mounted) return;
                  await Provider.of<my_auth.AuthProvider>(context,
                          listen: false)
                      .signOut();
                  if (!context.mounted) return;
                  Navigator.of(context).pushReplacementNamed('/');
                },
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text('����� ������',
                    style: TextStyle(fontSize: 18, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}
