import 'package:flutter/material.dart';
import 'package:eduline/app/core/app_size.dart';

class PasswordStrengthWidget extends StatelessWidget {
  final int strength; // 0-5 scale
  final String strengthText;
  final Map<String, bool> requirements;
  final String password;

  const PasswordStrengthWidget({
    super.key,
    required this.strength,
    required this.strengthText,
    required this.requirements,
    required this.password,
  });

  @override
  Widget build(BuildContext context) {
    if (password.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: getHeight(12)),
        // Strength indicator bars and text in same row
        Row(
          children: [
            // Progress bars
            ...List.generate(4, (index) {
              bool isActive = index < strength && strength > 0;
              return Expanded(
                child: Container(
                  height: getHeight(4),
                  margin: EdgeInsets.only(right: index < 3 ? getWidth(8) : 0),
                  decoration: BoxDecoration(
                    color:
                        isActive
                            ? _getStrengthColor(strength)
                            : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(getWidth(2)),
                  ),
                ),
              );
            }),

            // Spacing between bars and text
            SizedBox(width: getWidth(100)),

            // Strength text
            if (strengthText.isNotEmpty)
              Text(
                strengthText,
                style: TextStyle(
                  fontSize: getWidth(12),
                  color: _getStrengthColor(strength),
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),

        SizedBox(height: getHeight(8)),

        // Requirements text - Always show when there's a password
        if (password.isNotEmpty)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                requirements['minLength']! &&
                        requirements['hasLetter']! &&
                        requirements['hasNumber']!
                    ? Icons.check_circle_outline_rounded
                    : Icons.cancel,
                color:
                    requirements['minLength']! &&
                            requirements['hasLetter']! &&
                            requirements['hasNumber']!
                        ? Colors.green
                        : Colors.red,
                size: getWidth(19),
              ),
              SizedBox(width: getWidth(8)),
              Expanded(
                child: Text(
                  "At least 8 characters with a combination of letters and numbers",
                  style: TextStyle(
                    fontSize: getWidth(13),
                    color:
                        requirements['minLength']! &&
                                requirements['hasLetter']! &&
                                requirements['hasNumber']!
                            ? Colors.green
                            : Colors.red,
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }

  Color _getStrengthColor(int strength) {
    if (strength <= 2) return Colors.red;
    if (strength == 3) return Colors.orange;
    return Colors.green;
  }
}
