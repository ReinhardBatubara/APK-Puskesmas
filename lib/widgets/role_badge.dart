import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/constants/role_constants.dart';

class RoleBadge extends StatelessWidget {
  final String role;
  final bool small;

  const RoleBadge({super.key, required this.role, this.small = false});

  @override
  Widget build(BuildContext context) {
    final color = RoleConstants.getRoleColor(role);
    final icon = RoleConstants.getRoleIcon(role);
    final name = RoleConstants.getRoleName(role);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? 8 : 12,
        vertical: small ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: small ? 12 : 14, color: color),
          const SizedBox(width: 4),
          Text(
            name,
            style: GoogleFonts.poppins(
              fontSize: small ? 10 : 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
