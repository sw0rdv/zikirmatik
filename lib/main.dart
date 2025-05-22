import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const ZikirmatikApp());
}

class ZikirmatikApp extends StatelessWidget {
  const ZikirmatikApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zikirmatik',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: const Color(0xfff2fdf2),
      ),
      home: const ZikirScreen(),
    );
  }
}

class ZikirScreen extends StatefulWidget {
  const ZikirScreen({super.key});

  @override
  State<ZikirScreen> createState() => _ZikirScreenState();
}

class _ZikirScreenState extends State<ZikirScreen> {
  int sayac = 0;
  int hedef = 33;
  bool sessizMod = false;

  void arttir() async {
    HapticFeedback.lightImpact();
    setState(() => sayac++);

    if (!sessizMod && sayac % hedef == 0 && sayac != 0) {
      final player = AudioPlayer();
      await player.play(AssetSource('click.mp3'));
    }
  }

  void sifirla() {
    setState(() => sayac = 0);
  }

  void modDegistir({required int? yeniHedef, required bool sessiz}) {
    setState(() {
      hedef = yeniHedef ?? 0;
      sessizMod = sessiz;
      sayac = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Zikirmatik'), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Zikir Sayısı', style: TextStyle(fontSize: 24)),
            Text(
              '$sayac',
              style: const TextStyle(
                fontSize: 72,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 40),
            GestureDetector(
              onTap: arttir,
              child: Container(
                width: 120,
                height: 120,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
                ),
                child: const Icon(
                  Icons.fingerprint,
                  color: Colors.white,
                  size: 60,
                ),
              ),
            ),
            const SizedBox(height: 30),
            TextButton(
              onPressed: sifirla,
              child: const Text(
                'Sıfırla',
                style: TextStyle(color: Colors.red, fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              children: [
                ChoiceChip(
                  label: const Text('33'),
                  selected: hedef == 33 && !sessizMod,
                  onSelected: (_) => modDegistir(yeniHedef: 33, sessiz: false),
                ),
                ChoiceChip(
                  label: const Text('100'),
                  selected: hedef == 100 && !sessizMod,
                  onSelected: (_) => modDegistir(yeniHedef: 100, sessiz: false),
                ),
                ChoiceChip(
                  label: const Text('1000'),
                  selected: hedef == 1000 && !sessizMod,
                  onSelected: (_) =>
                      modDegistir(yeniHedef: 1000, sessiz: false),
                ),
                ChoiceChip(
                  label: const Text('∞'),
                  selected: sessizMod,
                  onSelected: (_) => modDegistir(yeniHedef: null, sessiz: true),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
