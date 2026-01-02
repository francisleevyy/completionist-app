import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SideMenu extends StatelessWidget {
  final Function(int) onIndexChanged;

  const SideMenu({super.key, required this.onIndexChanged});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF2C003E), Color(0xFF512DA8), Color(0xFF7B1FA2)],
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // HEADER
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.transparent),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.menu, color: Colors.white, size: 30),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'MENU',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // MENU ITEMS
            _buildMenuItem(context, 0, 'PROFILE', Icons.person),
            _buildMenuItem(context, 1, 'LIBRARY', Icons.grid_view),
            _buildMenuItem(context, 2, 'GUIDES', Icons.menu_book),
            _buildMenuItem(context, 3, 'NOTES', Icons.edit_note),
          ],
        ),
      ),
    );
  }

  // Helper method to build each menu item
  Widget _buildMenuItem(
    BuildContext context,
    int index,
    String title,
    IconData icon,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
      onTap: () {
        onIndexChanged(index);
        Navigator.pop(context);
      },
      hoverColor: Colors.white.withOpacity(0.1),
    );
  }
}
