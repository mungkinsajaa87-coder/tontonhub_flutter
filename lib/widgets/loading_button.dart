import 'package:flutter/material.dart';

class LoadingButton extends StatelessWidget {
  const LoadingButton({
    super.key,
    required this.label,
    required this.isLoading,
    required this.onPressed,
    this.icon,
  });

  final String label;
  final bool isLoading;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: isLoading ? null : onPressed,
      icon: isLoading
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
            )
          : Icon(icon ?? Icons.check),
      label: Text(isLoading ? 'Memproses...' : label),
    );
  }
}
