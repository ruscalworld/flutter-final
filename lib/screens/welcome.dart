import 'package:flutter/material.dart';
import 'package:pr_final/screens/add_place.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Container(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.cloudy_snowing, size: 96, color: Colors.white),
              const SizedBox(height: 32),
              const Text(
                  'Добро пожаловать!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 32, color: Colors.white),
              ),
              const SizedBox(height: 16),
              const Text(
                  'Добавьте своё расположение, чтобы начать работу.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                style: const ButtonStyle(
                    padding: MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 16, horizontal: 32)),
                ),
                onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AddPlaceScreen())),
                child: const Text('Начать', style: TextStyle(fontSize: 18)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
