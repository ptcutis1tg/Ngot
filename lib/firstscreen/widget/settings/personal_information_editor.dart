import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/firstscreen/widget/settings/avatar_display_options_sheet.dart';
import 'package:flutter_application_1/providers/userprofileprovider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class PersonalInformationEditor extends StatelessWidget {
  const PersonalInformationEditor({super.key});

  @override
  Widget build(BuildContext context) {
    return const _PersonalInformationEditorBody();
  }
}

class _PersonalInformationEditorBody extends StatefulWidget {
  const _PersonalInformationEditorBody();

  @override
  State<_PersonalInformationEditorBody> createState() =>
      _PersonalInformationEditorBodyState();
}

class _PersonalInformationEditorBodyState
    extends State<_PersonalInformationEditorBody> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late String _avatarPath;

  @override
  void initState() {
    super.initState();
    final provider = context.read<UserProfileProvider>();
    _nameController = TextEditingController(text: provider.userName);
    _emailController = TextEditingController(text: provider.userEmail);
    _avatarPath = provider.userAvatar;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final provider = context.read<UserProfileProvider>();
    await provider.setUserName(_nameController.text.trim());
    await provider.setUserEmail(_emailController.text.trim());
    await provider.setUserAvatar(_avatarPath.trim());

    if (!mounted) return;
    Navigator.of(context).pop();
  }

  Future<void> _pickAvatarFromExplorer() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true,
    );
    if (result == null || result.files.isEmpty) return;

    final savedValue = await _persistPickedAvatar(result.files.single);
    if (savedValue == null || savedValue.isEmpty) return;

    if (!mounted) return;
    final selectedAvatar = await AvatarDisplayOptionsSheet.show(
      context: context,
      avatarPath: savedValue,
    );
    if (selectedAvatar == null || selectedAvatar.trim().isEmpty) return;

    final persistedAvatar = await _persistFinalAvatarSelection(
      selectedAvatar.trim(),
    );
    _avatarPath = persistedAvatar;
    if (!mounted) return;
    await context.read<UserProfileProvider>().setUserAvatar(_avatarPath);
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();
    if (!mounted) return;
    setState(() {});
  }

  Future<String?> _persistPickedAvatar(PlatformFile picked) async {
    if (kIsWeb) {
      final bytes = picked.bytes;
      if (bytes == null || bytes.isEmpty) {
        return null;
      }
      return 'memory:${base64Encode(bytes)}';
    }

    final appDir = await getApplicationDocumentsDirectory();
    final avatarsDir = Directory('${appDir.path}/avatars');
    if (!avatarsDir.existsSync()) {
      await avatarsDir.create(recursive: true);
    }

    final extension = (picked.extension?.trim().isNotEmpty ?? false)
        ? picked.extension!.trim()
        : 'jpg';
    final targetPath =
        '${avatarsDir.path}/avatar_${DateTime.now().millisecondsSinceEpoch}.$extension';
    final targetFile = File(targetPath);

    final bytes = picked.bytes;
    if (bytes != null && bytes.isNotEmpty) {
      await targetFile.writeAsBytes(bytes, flush: true);
      return targetPath;
    }

    final sourcePath = picked.path;
    if (sourcePath != null &&
        sourcePath.isNotEmpty &&
        !sourcePath.startsWith('content://')) {
      await File(sourcePath).copy(targetPath);
      return targetPath;
    }

    return null;
  }

  Future<String> _persistFinalAvatarSelection(String selectedAvatar) async {
    final value = selectedAvatar.trim();
    if (value.isEmpty) return _avatarPath;
    if (kIsWeb ||
        value.startsWith('memory:') ||
        value.startsWith('http://') ||
        value.startsWith('https://') ||
        value.startsWith('assets/')) {
      return value;
    }

    final normalizedPath = value.startsWith('file://')
        ? Uri.parse(value).toFilePath()
        : value;
    final source = File(normalizedPath);
    if (!source.existsSync()) {
      return _avatarPath;
    }

    final appDir = await getApplicationDocumentsDirectory();
    final avatarsDir = Directory('${appDir.path}/avatars');
    if (!avatarsDir.existsSync()) {
      await avatarsDir.create(recursive: true);
    }

    final extension =
        source.path.split('.').length > 1 ? source.path.split('.').last : 'jpg';
    final targetPath =
        '${avatarsDir.path}/avatar_${DateTime.now().millisecondsSinceEpoch}.$extension';
    await source.copy(targetPath);
    return targetPath;
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sheetColor = isDark ? const Color(0xFF161616) : Colors.white;

    return Container(
      decoration: BoxDecoration(
        color: sheetColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + bottomInset),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                const _EditorHeader(),
                const SizedBox(height: 16),
                _AvatarPreview(
                  avatarPath: _avatarPath,
                  onPickAvatar: _pickAvatarFromExplorer,
                ),
                const SizedBox(height: 18),
                _NameField(controller: _nameController),
                const SizedBox(height: 12),
                _EmailField(controller: _emailController),
                const SizedBox(height: 18),
                _EditorActions(
                  onCancel: () => Navigator.of(context).pop(),
                  onSave: _save,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EditorHeader extends StatelessWidget {
  const _EditorHeader();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Personal Information',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Update your profile details shown in the app.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _AvatarPreview extends StatefulWidget {
  final String avatarPath;
  final Future<void> Function() onPickAvatar;

  const _AvatarPreview({required this.avatarPath, required this.onPickAvatar});

  @override
  State<_AvatarPreview> createState() => _AvatarPreviewState();
}

class _AvatarPreviewState extends State<_AvatarPreview> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1F1F1F) : const Color(0xFFF6F7F8),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                CircleAvatar(
                  key: ValueKey<String>(widget.avatarPath),
                  radius: 42,
                  backgroundImage: _avatarProvider(widget.avatarPath),
                ),
                Positioned(
                  right: -4,
                  bottom: -2,
                  child: Material(
                    color: const Color(0xFF2ECC71),
                    shape: const CircleBorder(),
                    child: InkWell(
                      onTap: widget.onPickAvatar,
                      customBorder: const CircleBorder(),
                      child: const Padding(
                        padding: EdgeInsets.all(7),
                        child: Icon(
                          Icons.edit_outlined,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: widget.onPickAvatar,
              icon: const Icon(Icons.photo_library_outlined),
              label: const Text('Choose image from device'),
            ),
          ],
        ),
      ),
    );
  }
}

InputDecoration _fieldDecoration({
  required BuildContext context,
  required String labelText,
  String? hintText,
  required IconData icon,
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return InputDecoration(
    labelText: labelText,
    hintText: hintText,
    prefixIcon: Icon(icon),
    filled: true,
    fillColor: isDark ? const Color(0xFF222222) : const Color(0xFFF7F8FA),
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(
        color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.28),
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: Color(0xFF2ECC71), width: 1.4),
    ),
  );
}

class _NameField extends StatelessWidget {
  final TextEditingController controller;

  const _NameField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: _fieldDecoration(
        context: context,
        labelText: 'Username',
        hintText: 'Your display name',
        icon: Icons.person_outline,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter username';
        }
        return null;
      },
    );
  }
}

class _EmailField extends StatelessWidget {
  final TextEditingController controller;

  const _EmailField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: _fieldDecoration(
        context: context,
        labelText: 'Email',
        hintText: 'example@email.com',
        icon: Icons.alternate_email_outlined,
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        final raw = value?.trim() ?? '';
        if (raw.isEmpty) return null;
        if (!raw.contains('@')) {
          return 'Invalid email';
        }
        return null;
      },
    );
  }
}

class _EditorActions extends StatelessWidget {
  final VoidCallback onCancel;
  final Future<void> Function() onSave;

  const _EditorActions({required this.onCancel, required this.onSave});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: onCancel,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 13),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Cancel'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton(
            onPressed: onSave,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 13),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Save'),
          ),
        ),
      ],
    );
  }
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
