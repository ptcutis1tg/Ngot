import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/userprofileprovider.dart';
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
  late final TextEditingController _avatarController;

  @override
  void initState() {
    super.initState();
    final provider = context.read<UserProfileProvider>();
    _nameController = TextEditingController(text: provider.userName);
    _emailController = TextEditingController(text: provider.userEmail);
    _avatarController = TextEditingController(text: provider.userAvatar);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _avatarController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final provider = context.read<UserProfileProvider>();
    await provider.setUserName(_nameController.text.trim());
    await provider.setUserEmail(_emailController.text.trim());
    await provider.setUserAvatar(_avatarController.text.trim());

    if (!mounted) return;
    Navigator.of(context).pop();
  }

  Future<void> _pickAvatarFromExplorer() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (result == null || result.files.isEmpty) return;

    final path = result.files.single.path;
    if (path == null || path.isEmpty) return;

    _avatarController.text = path;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
                const _EditorHeader(),
                const SizedBox(height: 16),
                _AvatarPreview(
                  avatarPath: _avatarController.text,
                  onPickAvatar: _pickAvatarFromExplorer,
                ),
                const SizedBox(height: 16),
                _NameField(controller: _nameController),
                const SizedBox(height: 12),
                _EmailField(controller: _emailController),
                const SizedBox(height: 12),
                _AvatarField(
                  controller: _avatarController,
                  onChanged: () => setState(() {}),
                ),
                const SizedBox(height: 18),
                _EditorActions(onCancel: () => Navigator.of(context).pop(), onSave: _save),
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
    return const Text(
      'Personal Information',
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 36,
            backgroundImage: _avatarProvider(widget.avatarPath),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: widget.onPickAvatar,
            icon: const Icon(Icons.photo_library_outlined),
            label: const Text('Choose image from device'),
          ),
        ],
      ),
    );
  }
}

class _NameField extends StatelessWidget {
  final TextEditingController controller;

  const _NameField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(labelText: 'Username'),
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
      decoration: const InputDecoration(labelText: 'Email'),
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

class _AvatarField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onChanged;

  const _AvatarField({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(
        labelText: 'Avatar URL/Asset/Local path',
        hintText: 'https://... or assets/user/anonymous.jpg',
      ),
      onChanged: (_) => onChanged(),
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
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(onPressed: onCancel, child: const Text('Cancel')),
        const SizedBox(width: 8),
        ElevatedButton(onPressed: onSave, child: const Text('Save')),
      ],
    );
  }
}

ImageProvider _avatarProvider(String avatar) {
  final value = avatar.trim();
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
    return FileImage(File(value));
  }
  return const AssetImage('assets/user/anonymous.jpg');
}
