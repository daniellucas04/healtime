import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  final List<Map<String, String>> tutorialData = [
    {
      "title": "Bem-vindo!",
      "subtitle": "Gerencie seus medicamentos de forma simples e segura.",
      "image": "assets/tutorial/tutorial_01.png"
    },
    {
      "title": "Cadastre seus remédios",
      "subtitle": "Adicione nome, dosagem e horários de uso.",
      "image": "assets/tutorial/tutorial_02.png"
    },
    {
      "title": "Receba lembretes",
      "subtitle": "Nunca mais esqueça de tomar seus medicamentos.",
      "image": "assets/tutorial/tutorial_03.png"
    },
    {
      "title": "Acompanhe seu histórico",
      "subtitle": "Veja quando e como tomou seus remédios.",
      "image": "assets/tutorial/tutorial_04.png"
    },
    {
      "title": "Gerencie varias pessoas",
      "subtitle": "Cuide dos medicamentos de todos.",
      "image": "assets/tutorial/tutorial_05.png"
    },
  ];

  int _current = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: CarouselSlider(
                items: tutorialData.map((item) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(item["image"]!, height: 230),
                      const SizedBox(height: 20),
                      Text(
                        item["title"]!,
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Text(
                          item["subtitle"]!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  );
                }).toList(),
                carouselController: _controller,
                options: CarouselOptions(
                  autoPlay: false,
                  enableInfiniteScroll: false,
                  enlargeCenterPage: true,
                  height: 400,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  },
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: tutorialData.asMap().entries.map((entry) {
                return GestureDetector(
                  onTap: () => _controller.animateToPage(entry.key),
                  child: Container(
                    width: 12.0,
                    height: 12.0,
                    margin: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 4.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _current == entry.key
                          ? Colors.blue
                          : Colors.grey.withOpacity(0.4),
                    ),
                  ),
                );
              }).toList(),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/create_people');
                    },
                    child: const Text("Pular"),
                  ),
                  _current == tutorialData.length - 1
                      ? ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/create_people');
                          },
                          child: const Text("Começar"),
                        )
                      : ElevatedButton(
                          onPressed: () {
                            _controller.nextPage();
                          },
                          child: const Text("Próximo"),
                        ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

