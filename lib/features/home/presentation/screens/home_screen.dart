import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../auth/presentation/screens/login_screen.dart';
import '../../../auth/presentation/screens/signup_screen.dart';
import '../../../game/presentation/screens/game_screen.dart';
import '../widgets/app_drawer.dart';
import '../widgets/menu_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedTimeControl = '3 min';
  String? username;
  int rating = 1200;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username');
      rating = prefs.getInt('rating') ?? 1200;
    });
  }

  int _getTimeInSeconds(String timeStr) {
    switch (timeStr) {
      case '1 min': return 60;
      case '10 min': return 600;
      case '3 min':
      default: return 180;
    }
  }

  @override
  Widget build(BuildContext context) {
    int timeSeconds = _getTimeInSeconds(selectedTimeControl);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      drawer: AppDrawer(
        username: username,
        onLogout: () {
          setState(() {
            username = null;
          });
        },
      ),
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.extension, color: AppColors.primaryGreen, size: 28),
            SizedBox(width: 8),
            Text('Chess.com', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)),
          ],
        ),
        backgroundColor: AppColors.surfaceDark,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // User Profile Header or Guest Login Banner
              if (username != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceDark,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Colors.white24,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        username!,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                      ),
                      const SizedBox(width: 8),
                      const Text('🇮🇳', style: TextStyle(fontSize: 16)),
                      const Spacer(),
                      const Icon(Icons.local_fire_department, color: Colors.orange, size: 20),
                      Text(
                        ' $rating',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                )
              else
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryGreen),
                        onPressed: () async {
                          final loggedIn = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const LoginScreen()),
                          );
                          if (loggedIn == true) _loadUserData();
                        },
                        child: const Text('Log In', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const SignupScreen()));
                        },
                        child: const Text('Sign Up', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 20),

              // Time Controls
              Row(
                children: ['3 min', '1 min', '10 min'].map((time) {
                  bool isSelected = selectedTimeControl == time;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: GestureDetector(
                        onTap: () => setState(() => selectedTimeControl = time),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF383633) : AppColors.surfaceDark,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected ? AppColors.primaryGreen : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            time,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),

              // Start Game
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => GameScreen(initialTimeSeconds: timeSeconds)),
                  );
                },
                child: const Text('Start Game', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
              const SizedBox(height: 20),

              // Menu Buttons
              MenuButton(
                icon: Icons.flash_on,
                title: 'Play Online',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => GameScreen(initialTimeSeconds: timeSeconds)),
                  );
                },
              ),
              MenuButton(
                icon: Icons.people,
                title: 'Play a Friend',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => GameScreen(initialTimeSeconds: timeSeconds)),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}