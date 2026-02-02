import 'package:flutter/material.dart';

class VlcFuturisticAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  const VlcFuturisticAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showBackButton = true,
    this.onBackPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 20);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.blue.shade900.withOpacity(0.8),
            Colors.transparent,
          ],
        ),
      ),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: showBackButton
            ? IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue.shade300.withOpacity(0.2),
              border: Border.all(
                color: Colors.blue.shade300,
                width: 1,
              ),
            ),
            child: Icon(
              Icons.arrow_back,
              color: Colors.blue.shade300,
            ),
          ),
          onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
        )
            : null,
        title: Text(
          title,
          style: TextStyle(
            color: Colors.blue.shade300,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
          ),
        ),
        centerTitle: true,
        actions: actions,
      ),
    );
  }
}