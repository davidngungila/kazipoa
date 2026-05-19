import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class OtpVerificationPage extends StatefulWidget {
  const OtpVerificationPage({super.key});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final List<TextEditingController> controllers =
      List.generate(6, (_) => TextEditingController());

  int seconds = 59;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      if (seconds > 0) {
        setState(() => seconds--);
        return true;
      }
      return false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          _background(),

          SafeArea(
            child: Column(
              children: [
                _appBar(context),
                const SizedBox(height: 20),
                _stepIndicator(),
                const SizedBox(height: 20),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: _card(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // BACKGROUND
  Widget _background() {
    return Positioned.fill(
      child: Stack(
        children: [
          Positioned(
            top: -120,
            left: -80,
            child: _blob(500),
          ),
          Positioned(
            top: -100,
            right: -120,
            child: _blob(400),
          ),
        ],
      ),
    );
  }

  Widget _blob(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            const Color(0xFF00D4FF).withOpacity(0.15),
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  // APPBAR
  Widget _appBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Color(0xFF00D4FF)),
          ),
          const Expanded(
            child: Text(
              "Thibitisha",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  // STEP INDICATOR
  Widget _stepIndicator() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _bar(false),
            _bar(true),
            _bar(false, small: true),
          ],
        ),
        const SizedBox(height: 6),
        const Text(
          "HATUA YA 2 KATI YA 3",
          style: TextStyle(
            color: Color(0xFF00D4FF),
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }

  Widget _bar(bool active, {bool small = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: small ? 12 : 40,
      height: 6,
      decoration: BoxDecoration(
        color: active ? const Color(0xFF00D4FF) : Colors.white10,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  // CARD
  Widget _card() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        children: [
          const Icon(Icons.phone_android,
              color: Color(0xFF00D4FF), size: 55),

          const SizedBox(height: 16),

          const Text(
            "Ingiza Namba ya Siri",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            "Tumetuma OTP ya tarakimu 6 kwenye simu yako",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white54, fontSize: 12),
          ),

          const SizedBox(height: 25),

          // OTP INPUTS
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(6, (i) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 42,
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white10),
                ),
                child: TextField(
                  controller: controllers[i],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF00D4FF),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  keyboardType: TextInputType.number,
                  maxLength: 1,
                  decoration: const InputDecoration(
                    counterText: "",
                    border: InputBorder.none,
                  ),
                ),
              );
            }),
          ),

          const SizedBox(height: 25),

          // TIMER
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.schedule,
                  color: Colors.white54, size: 18),
              const SizedBox(width: 6),
              Text(
                "0:${seconds.toString().padLeft(2, '0')}",
                style: const TextStyle(color: Colors.white54),
              ),
            ],
          ),

          const SizedBox(height: 10),

          TextButton(
            onPressed: () {},
            child: const Text(
              "Tuma Tena Namba",
              style: TextStyle(
                color: Color(0xFF00D4FF),
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
          ),

          const SizedBox(height: 15),

          // BUTTON
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00D4FF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                HapticFeedback.heavyImpact();
                // Navigate to profile setup after successful OTP verification
                context.go('/pro_registration/setup');
              },
              child: const Text(
                "Thibitisha",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white12),
            ),
            child: const Text(
              "Verified Secure",
              style: TextStyle(
                fontSize: 10,
                color: Colors.white54,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}