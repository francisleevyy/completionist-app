import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class GuidesScreen extends StatelessWidget {
  const GuidesScreen({super.key});

  //  LIST OF GUIDE WEBSITES
  final List<Map<String, dynamic>> _guideSites = const [
    {
      'name': 'Steam Guides',
      'url': 'https://steamcommunity.com/',
      'icon': Icons.gamepad,
      'color': Color(0xFF1b2838),
      'desc': 'Community created guides & walkthroughs.',
    },
    {
      'name': 'PowerPyx',
      'url': 'https://www.powerpyx.com/',
      'icon': Icons.emoji_events,
      'color': Color(0xFFC62828),
      'desc': 'The best for 100% trophy & achievement hunting.',
    },
    {
      'name': 'IGN Wikis',
      'url': 'https://www.ign.com/wikis',
      'icon': Icons.map_outlined,
      'color': Color(0xFFbf1c1e),
      'desc': 'Detailed walkthroughs and maps.',
    },
    {
      'name': 'GameFAQs',
      'url': 'https://gamefaqs.gamespot.com/',
      'icon': Icons.text_snippet_outlined,
      'color': Color(0xFF1565C0),
      'desc': 'In-depth text guides and secrets.',
    },
    {
      'name': 'StrategyWiki',
      'url': 'https://strategywiki.org/',
      'icon': Icons.menu_book,
      'color': Color(0xFF2E7D32),
      'desc': 'Community compendium of strategy guides.',
    },
    {
      'name': 'More Soon!',
      'url': '',
      'icon': Icons.more_time,
      'color': Color(0xFF607D8B),
      'desc': 'We are adding more guides soon.',
    },
  ];

  // OPEN IN-APP BROWSER
  Future<void> _launchURL(BuildContext context, String urlString) async {
    if (urlString.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('More guide sources are on the way!'),
          backgroundColor: Colors.deepPurpleAccent,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final Uri url = Uri.parse(urlString);
    try {
      if (!await launchUrl(url, mode: LaunchMode.inAppBrowserView)) {
        throw Exception('Could not launch $url');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open $urlString'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2C003E), Color(0xFF512DA8), Color(0xFF7B1FA2)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // HEADER
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Column(
              children: [
                Text(
                  'Game Guides',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Select a source to find walkthroughs and start achievement hunting!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),

          // GRID OF WEBSITES
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 0.85,
              ),
              itemCount: _guideSites.length,
              itemBuilder: (context, index) {
                final site = _guideSites[index];
                return _buildGuideCard(context, site);
              },
            ),
          ),
        ],
      ),
    );
  }

  // GUIDE CARD WIDGET
  Widget _buildGuideCard(BuildContext context, Map<String, dynamic> site) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            site['color'].withOpacity(0.8),
            site['color'].withOpacity(0.4),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _launchURL(context, site['url']),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(site['icon'], size: 32, color: Colors.white),
                ),
                const SizedBox(height: 15),
                Text(
                  site['name'],
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  site['desc'],
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
