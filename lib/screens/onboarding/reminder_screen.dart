import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../home_screen.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  bool isReminderEnabled = false;
  String selectedTime = '10:00 AM';
  String selectedDay = 'Sundays';

  final List<String> times = [
    '8:00 AM',
    '9:00 AM',
    '10:00 AM',
    '11:00 AM',
    '12:00 PM',
    '1:00 PM',
    '2:00 PM',
  ];

  final List<String> days = [
    'Sundays',
    'Mondays',
    'Tuesdays',
    'Wednesdays',
    'Thursdays',
    'Fridays',
    'Saturdays',
  ];

  @override
  void initState() {
    super.initState();
    _checkNotificationPermission();
  }

  Future<void> _checkNotificationPermission() async {
    final status = await Permission.notification.status;
    if (status.isDenied) {
      _showNotificationPermissionDialog();
    }
  }

  Future<void> _showNotificationPermissionDialog() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text(
          '"Mealtim" Would Like To Send\nYou Notifications',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: const Text(
          'Notifications may include alerts,\nsounds, and icon badges. These can be\nconfigured in Settings.',
          textAlign: TextAlign.center,
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() => isReminderEnabled = false);
                  },
                  child: const Text("Don't Allow"),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    final status = await Permission.notification.request();
                    setState(() => isReminderEnabled = status.isGranted);
                  },
                  child: const Text(
                    "Allow",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFAF5),
      body: SafeArea(
        child: Stack(
          children: [
            // Back Button
            Positioned(
              left: 16,
              top: 0,
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            ),

            // Progress Indicator
            Positioned(
              left: 16,
              top: 40,
              right: 16,
              child: Row(
                children: List.generate(5, (index) {
                  return Expanded(
                    child: Container(
                      height: 12,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: ShapeDecoration(
                        color: index < 4 ? const Color(0xFF33985B) : const Color(0xFFE6E6E6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),

            // Main Content
            Positioned(
              left: 16,
              top: 76,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Set a weekly reminder',
                    style: TextStyle(
                      color: Color(0xFF191919),
                      fontSize: 32,
                      fontFamily: 'DM Sans',
                      fontWeight: FontWeight.w700,
                      letterSpacing: -1.60,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Remind me to make a meal plan',
                        style: TextStyle(
                          color: Color(0xFF191919),
                          fontSize: 18,
                          fontFamily: 'DM Sans',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Switch(
                        value: isReminderEnabled,
                        onChanged: (value) {
                          setState(() {
                            isReminderEnabled = value;
                          });
                        },
                        activeColor: const Color(0xFFF48600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  if (isReminderEnabled) ...[
                    _buildDropdown(
                      'at $selectedTime',
                      times,
                      (value) => setState(() => selectedTime = value),
                    ),
                    const SizedBox(height: 16),
                    _buildDropdown(
                      'on $selectedDay',
                      days,
                      (value) => setState(() => selectedDay = value),
                    ),
                  ],
                ],
              ),
            ),

            // Done Button
            Positioned(
              left: 17,
              right: 17,
              bottom: 40,
              child: ElevatedButton(
                onPressed: () {
                  // Save reminder settings if needed
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(),
                    ),
                    (route) => false, // Remove all previous routes
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF48600),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Done',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: 'DM Sans',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(String value, List<String> items, Function(String) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0xFFCCCCCC)),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF191919),
              fontSize: 18,
              fontFamily: 'DM Sans',
              fontWeight: FontWeight.w500,
            ),
          ),
          const Icon(Icons.keyboard_arrow_down),
        ],
      ),
    );
  }
} 