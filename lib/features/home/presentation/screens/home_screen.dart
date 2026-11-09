import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../game/presentation/screens/game_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Default selected time control (e.g., 3 min)
  String selectedTimeControl = '3 min';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {},
        ),
        title: Row(
          children: [
            const Icon(Icons.extension, color: AppColors.primaryGreen, size: 28),
            const SizedBox(width: 8),
            Text(
              'Chess.com',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
            ),
          ],
        ),
        backgroundColor: AppColors.surfaceDark,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- 1. User Profile Header Bar ---
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
                    const Text(
                      'Tanush-25',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                    ),
                    const SizedBox(width: 8),
                    const Text('🇮🇳', style: TextStyle(fontSize: 16)),
                    const Spacer(),
                    const Icon(Icons.local_fire_department, color: Colors.orange, size: 20),
                    const Text(
                      ' 1100',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // --- 2. Time Control Selectors (3 min, 1 min, 10 min) ---
              Row(
                children: ['3 min', '1 min', '10 min'].map((time) {
                  bool isSelected = selectedTimeControl == time;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedTimeControl = time;
                          });
                        },
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

              // --- 3. Big Green Start Game Button ---
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const GameScreen()),
                  );
                },
                child: const Text(
                  'Start Game',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),

              // --- 4. Stacked Menu Buttons ---
              _buildMenuButton(
                icon: Icons.flash_on,
                title: 'Play Online',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const GameScreen()),
                  );
                },
              ),
              _buildMenuButton(
                icon: Icons.smart_toy,
                title: 'Play Bots',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Bot mode coming soon!')),
                  );
                },
              ),
              _buildMenuButton(
                icon: Icons.school,
                title: 'Play Coach',
                onTap: () {},
              ),
              _buildMenuButton(
                icon: Icons.people,
                title: 'Play a Friend',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const GameScreen()),
                  );
                },
              ),
              const SizedBox(height: 20),

              // --- 5. Puzzle / Bottom Preview Banner ---
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceDark,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      color: const Color(0xFF739552),
                      child: const Center(
                        child: Icon(Icons.grid_view, color: Colors.white54, size: 30),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Row(
                            children: [
                              Icon(Icons.extension, color: Colors.amber, size: 16),
                              SizedBox(width: 4),
                              Text('3', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16)),
                              Spacer(),
                              Text('195 🔥 3', style: TextStyle(color: Colors.grey, fontSize: 14)),
                            ],
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Solve Puzzles',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton({required IconData icon, required String title, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.surfaceDark,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          alignment: Alignment.centerLeft,
          elevation: 0,
        ),
        onPressed: onTap,
        child: Row(
          children: [
            Icon(icon, color: Colors.white70, size: 22),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 14),
          ],
        ),
      ),
    );
  }
}