import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/firstscreen/widget/settings/avatar_display_options_sheet.dart';
import 'package:flutter_application_1/providers/app_settings_provider.dart';
import 'package:flutter_application_1/providers/app_translations.dart';
import 'package:flutter_application_1/providers/userprofileprovider.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PersonalInformationScreen extends StatelessWidget {
  const PersonalInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _PersonalInformationScreenBody();
  }
}

class _PersonalInformationScreenBody extends StatefulWidget {
  const _PersonalInformationScreenBody();

  @override
  State<_PersonalInformationScreenBody> createState() =>
      _PersonalInformationScreenBodyState();
}

class _PersonalInformationScreenBodyState
    extends State<_PersonalInformationScreenBody> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _fullNameController;
  late final TextEditingController _usernameController;
  late final TextEditingController _bioController;
  late String _avatarPath;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final provider = context.read<UserProfileProvider>();
    _fullNameController = TextEditingController(text: provider.userFullName);
    _usernameController = TextEditingController(text: provider.userName);
    _bioController = TextEditingController(text: provider.userBio);
    _avatarPath = provider.userAvatar;
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isSaving = true);

    try {
      final provider = context.read<UserProfileProvider>();
      await provider.setUserFullName(_fullNameController.text.trim());
      await provider.setUserName(_usernameController.text.trim());
      await provider.setUserBio(_bioController.text.trim());
      await provider.setUserAvatar(_avatarPath.trim());

      if (!mounted) return;
      
      final languageCode =
          context.read<AppSettingsProvider>().languageCode;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppTranslations.getText(languageCode, 'pi_save_success'),
          ),
          backgroundColor: const Color(0xFF2ECC71),
        ),
      );
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
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
    
    setState(() {
      _avatarPath = persistedAvatar;
    });

    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();
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
    final appSettings = context.watch<AppSettingsProvider>();
    final userProfile = context.watch<UserProfileProvider>();
    final languageCode = appSettings.languageCode;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Theme colors matching the premium look of the app
    final cardBgColor = isDark ? const Color(0xFF0F3124) : const Color(0xFFF0F5F2);
    final borderColor = isDark ? const Color(0xFF165C40) : const Color(0xFFD0E0D8);
    final textOnCardColor = isDark ? const Color(0xFFE5F4EB) : const Color(0xFF103A27);
    final labelColor = isDark ? const Color(0xFF98AF9F) : const Color(0xFF557F67);
    final readOnlyBgColor = isDark ? const Color(0xFF082218) : const Color(0xFFE5EDE9);

    // Get current User Metadata from Supabase
    final supabaseUser = Supabase.instance.client.auth.currentUser;
    final userId = supabaseUser?.id ?? 'Local_User';
    final rawCreatedAt = supabaseUser?.createdAt;
    String joinDate = '';
    if (rawCreatedAt != null) {
      try {
        final parsedDate = DateTime.parse(rawCreatedAt);
        joinDate = DateFormat(languageCode == 'vi' ? 'dd/MM/yyyy' : 'MM/dd/yyyy').format(parsedDate);
      } catch (_) {
        joinDate = rawCreatedAt;
      }
    } else {
      joinDate = AppTranslations.getText(languageCode, 'pi_join_date_today', defaultValue: languageCode == 'vi' ? 'Hôm nay' : (languageCode == 'ko' ? '오늘' : 'Today'));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppTranslations.getText(languageCode, 'pi_title')),
        actions: [
          if (_isSaving)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                ),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: _save,
              tooltip: AppTranslations.getText(languageCode, 'pi_save_tooltip'),
            ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Avatar Area
                Center(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFF2ECC71), width: 3),
                        ),
                        child: CircleAvatar(
                          key: ValueKey<String>(_avatarPath),
                          radius: 55,
                          backgroundImage: _avatarProvider(_avatarPath),
                        ),
                      ),
                      Positioned(
                        right: 2,
                        bottom: 2,
                        child: Material(
                          color: const Color(0xFF2ECC71),
                          shape: const CircleBorder(),
                          elevation: 3,
                          child: InkWell(
                            onTap: _pickAvatarFromExplorer,
                            customBorder: const CircleBorder(),
                            child: const Padding(
                              padding: EdgeInsets.all(8),
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Editable Fields Section
                Text(
                  AppTranslations.getText(languageCode, 'pi_title').toUpperCase(),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: labelColor,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 10),
                
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: cardBgColor,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: borderColor, width: 1),
                  ),
                  child: Column(
                    children: [
                      // Full name (Họ và tên)
                      TextFormField(
                        controller: _fullNameController,
                        style: TextStyle(color: textOnCardColor),
                        decoration: _fieldDecoration(
                          context: context,
                          labelText: AppTranslations.getText(languageCode, 'pi_full_name'),
                          icon: Icons.person_outline,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return AppTranslations.getText(languageCode, 'pi_error_name');
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      // Username (Tên người dùng)
                      TextFormField(
                        controller: _usernameController,
                        style: TextStyle(color: textOnCardColor),
                        decoration: _fieldDecoration(
                          context: context,
                          labelText: AppTranslations.getText(languageCode, 'pi_username'),
                          icon: Icons.alternate_email,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return AppTranslations.getText(languageCode, 'pi_error_username');
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      // Bio (Mô tả bản thân)
                      TextFormField(
                        controller: _bioController,
                        style: TextStyle(color: textOnCardColor),
                        maxLines: 3,
                        decoration: _fieldDecoration(
                          context: context,
                          labelText: AppTranslations.getText(languageCode, 'pi_bio'),
                          icon: Icons.description_outlined,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // Read-only System Section
                Text(
                  AppTranslations.getText(languageCode, 'pi_system_info').toUpperCase(),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: labelColor,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 10),

                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: cardBgColor,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: borderColor, width: 1),
                  ),
                  child: Column(
                    children: [
                      // Email
                      _buildReadOnlyField(
                        label: AppTranslations.getText(languageCode, 'pi_email'),
                        value: userProfile.userEmail.isNotEmpty
                            ? userProfile.userEmail
                            : (supabaseUser?.email ?? 'N/A'),
                        icon: Icons.email_outlined,
                        bgColor: readOnlyBgColor,
                        labelColor: labelColor,
                        valueColor: textOnCardColor,
                      ),
                      const SizedBox(height: 12),
                      
                      // User ID
                      _buildReadOnlyField(
                        label: AppTranslations.getText(languageCode, 'pi_user_id'),
                        value: userId,
                        icon: Icons.badge_outlined,
                        bgColor: readOnlyBgColor,
                        labelColor: labelColor,
                        valueColor: textOnCardColor,
                      ),
                      const SizedBox(height: 12),
                      
                      // Join Date
                      _buildReadOnlyField(
                        label: AppTranslations.getText(languageCode, 'pi_join_date'),
                        value: joinDate,
                        icon: Icons.calendar_today_outlined,
                        bgColor: readOnlyBgColor,
                        labelColor: labelColor,
                        valueColor: textOnCardColor,
                      ),
                      const SizedBox(height: 12),

                      // App Version
                      _buildReadOnlyField(
                        label: AppTranslations.getText(languageCode, 'pi_app_version'),
                        value: '1.0.0',
                        icon: Icons.verified_user_outlined,
                        bgColor: readOnlyBgColor,
                        labelColor: labelColor,
                        valueColor: textOnCardColor,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Save button
                ElevatedButton(
                  onPressed: _isSaving ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2ECC71),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 2,
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : Text(
                          AppTranslations.getText(languageCode, 'pi_save_changes'),
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReadOnlyField({
    required String label,
    required String value,
    required IconData icon,
    required Color bgColor,
    required Color labelColor,
    required Color valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, color: labelColor, size: 20),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 11, color: labelColor, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(fontSize: 14, color: valueColor, fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _fieldDecoration({
    required BuildContext context,
    required String labelText,
    required IconData icon,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InputDecoration(
      labelText: labelText,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: isDark ? const Color(0xFF082218) : const Color(0xFFE5EDE9),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.15),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF2ECC71), width: 1.4),
      ),
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
