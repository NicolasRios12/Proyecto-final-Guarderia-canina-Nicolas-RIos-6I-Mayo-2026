import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// AppBar personalizado de Dog Club.
/// Puede mostrar logo o título, y soporta menú hamburger.
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showLogo;
  final List<Widget>? actions;
  final VoidCallback? onMenuTap;

  const CustomAppBar({
    super.key,
    this.title,
    this.showLogo = false,
    this.actions,
    this.onMenuTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) => AppBar(
    backgroundColor: AppColors.primary,
    foregroundColor: Colors.white,
    leading: onMenuTap != null
        ? IconButton(
            icon: const Icon(Icons.menu),
            onPressed: onMenuTap ?? () => Scaffold.of(context).openDrawer(),
          )
        : null,
    title: showLogo
        ? const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.pets, color: Colors.white),
              SizedBox(width: 8),
              Text('Dog Club',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          )
        : title != null
            ? Text(title!, style: const TextStyle(color: Colors.white))
            : null,
    actions: actions,
    elevation: 0,
  );
}
