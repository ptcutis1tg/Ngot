import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class UserWelcome extends StatelessWidget {
  final String userName;
  final String userAvatar;

  const UserWelcome({
    super.key,
    required this.userName,
    this.userAvatar =
        'assets/user/anonymous.jpg', // Mặc định nếu không có avatar
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          key: ValueKey<String>(userAvatar),
          radius: 25,
          backgroundImage: _avatarProvider(userAvatar),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome back,', style: TextStyle(color: Colors.grey[600])),
            Text(userName.isNotEmpty ? userName : 'Guest',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }

  ImageProvider _avatarProvider(String avatar) {
    var value = avatar.trim();
    if (value.startsWith('memory:')) {
      final encoded = value.substring('memory:'.length);
      try {
        return MemoryImage(base64Decode(encoded));
      } catch (_) {
        return const AssetImage('assets/user/anonymous.jpg');
      }
    }
    if (value.startsWith('file://')) {
      value = Uri.parse(value).toFilePath();
    }
    if (value.startsWith('http://') || value.startsWith('https://')) {
      return NetworkImage(value);
    }
    if (value.isEmpty) {
      return const AssetImage('assets/user/anonymous.jpg');
    }
    if (value.startsWith('assets/')) {
      return AssetImage(value);
    }
    if (!kIsWeb) {
      if (!File(value).existsSync()) {
        return const AssetImage('assets/user/anonymous.jpg');
      }
      return FileImage(File(value));
    }
    return const AssetImage('assets/user/anonymous.jpg');
  }
}
