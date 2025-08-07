import 'package:flutter/material.dart';
import 'map_screen.dart';
import 'gemini_chatbot.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("EskwelaRuta"),
          backgroundColor: const Color(0xFF48C9B0),
          bottom: const TabBar(tabs: [
            Tab(icon: Icon(Icons.school), text: "Nearby Schools"),
            Tab(icon: Icon(Icons.chat_bubble), text: "Chat"),
          ]),
        ),
        body: const TabBarView(children: [
          MapScreen(),
          GeminiAssistantPage(),
        ]),
      ),
    );
  }
}
