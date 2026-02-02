import 'package:flutter/material.dart';

class VlcSpeedButton extends StatelessWidget {
  final double speed;
  final bool isSelected;
  final VoidCallback onTap;

  const VlcSpeedButton({
    super.key,
    required this.speed,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
            colors: [
              Colors.blue.shade400,
              Colors.blue.shade700,
            ],
          )
              : LinearGradient(
            colors: [
              Colors.blue.shade800.withOpacity(0.3),
              Colors.blue.shade400.withOpacity(0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.blue.shade300.withOpacity(
              isSelected ? 0.8 : 0.2,
            ),
            width: 1,
          ),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: Colors.blue.shade400.withOpacity(0.5),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${speed}x',
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.blue.shade300,
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Icon(
                Icons.check,
                color: Colors.white,
                size: 18,
              ),
            ],
          ],
        ),
      ),
    );
  }
}