import 'dart:convert';
import 'dart:io';

import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AvatarDisplayOptionsSheet extends StatefulWidget {
  final String avatarPath;

  const AvatarDisplayOptionsSheet({
    super.key,
    required this.avatarPath,
  });

  static Future<String?> show({
    required BuildContext context,
    required String avatarPath,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AvatarDisplayOptionsSheet(avatarPath: avatarPath),
    );
  }

  @override
  State<AvatarDisplayOptionsSheet> createState() =>
      _AvatarDisplayOptionsSheetState();
}

class _AvatarDisplayOptionsSheetState extends State<AvatarDisplayOptionsSheet> {
  bool _isProcessing = false;

  Future<void> _useOriginal() async {
    if (_isProcessing) return;
    Navigator.of(context).pop(widget.avatarPath);
  }

  Future<void> _openFreeformCrop() async {
    if (_isProcessing) return;
    setState(() => _isProcessing = true);
    try {
      final bytes = await _loadBytes(widget.avatarPath);
      if (!mounted) return;
      if (bytes == null || bytes.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cannot open this image for crop.')),
        );
        return;
      }

      final croppedBytes = await showModalBottomSheet<Uint8List>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => _FreeformCropSheet(imageBytes: bytes),
      );
      if (!mounted || croppedBytes == null || croppedBytes.isEmpty) return;
      final encoded = base64Encode(croppedBytes);
      Navigator.of(context).pop('memory:$encoded');
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Future<Uint8List?> _loadBytes(String avatarPath) async {
    final value = avatarPath.trim();
    if (value.isEmpty) return null;

    if (value.startsWith('memory:')) {
      final encoded = value.substring('memory:'.length);
      try {
        return base64Decode(encoded);
      } catch (_) {
        return null;
      }
    }

    if (value.startsWith('file://')) {
      final path = Uri.parse(value).toFilePath();
      final file = File(path);
      if (!file.existsSync()) return null;
      return file.readAsBytes();
    }

    if (value.startsWith('http://') || value.startsWith('https://')) {
      return null;
    }

    if (value.startsWith('assets/')) {
      return null;
    }

    if (!kIsWeb) {
      final file = File(value);
      if (!file.existsSync()) return null;
      return file.readAsBytes();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SafeArea(
      top: false,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF161616) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 38,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Avatar options',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              'Choose original image or crop manually with freeform mode.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 14),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.check_circle_outline),
              title: const Text('Use original image'),
              onTap: _isProcessing ? null : _useOriginal,
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.crop_free),
              title: const Text('Freeform'),
              subtitle: const Text('Adjust manually'),
              onTap: _isProcessing ? null : _openFreeformCrop,
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed:
                    _isProcessing ? null : () => Navigator.of(context).pop(),
                child: _isProcessing
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Cancel'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FreeformCropSheet extends StatefulWidget {
  final Uint8List imageBytes;

  const _FreeformCropSheet({required this.imageBytes});

  @override
  State<_FreeformCropSheet> createState() => _FreeformCropSheetState();
}

class _FreeformCropSheetState extends State<_FreeformCropSheet> {
  final CropController _controller = CropController();
  bool _isCropping = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.86,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF101010) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              width: 38,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  TextButton(
                    onPressed: _isCropping
                        ? null
                        : () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const Spacer(),
                  Text(
                    'Freeform Crop',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: _isCropping
                        ? null
                        : () {
                            setState(() => _isCropping = true);
                            _controller.crop();
                          },
                    child: _isCropping
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Apply'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Crop(
                image: widget.imageBytes,
                controller: _controller,
                onCropped: (croppedImage) {
                  Navigator.of(context).pop(croppedImage);
                },
                withCircleUi: false,
                baseColor: isDark ? const Color(0xFF0F0F0F) : Colors.black,
                maskColor: Colors.black.withValues(alpha: 0.55),
                cornerDotBuilder: (size, edgeAlignment) => const DotControl(),
                fixCropRect: false,
                interactive: true,
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
