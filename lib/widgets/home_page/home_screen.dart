import 'package:flutter/material.dart';

import 'package:note_share_project/widgets/home_page/notes_pages.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> subjects = [
    'Programming Languages',
    'Data Management and File Structures',
    'Computer Networks',
    'Microprocessors',
    'Microprocessors Laboratory',
    'Fundamentals of Computer Vision',
    'Fundamentals of Machine Learning',
    'Computing for Medicine',
    'Automata Theory  and Formal Languages',
    'Differential  Equations',
    'Human-Computer Interaction and Usability',
    'Digital Logic Systems',
    'Engineering Ethics',
    'Introduction to Programming',
    'Database Management Systems',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          title: Text('Computer Engineering Lesson Notes'),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                // Arama işlemleri için ama su an aktif degil
              },
            ),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(1.0),
            child: Divider(height: 1, color: Colors.amber),
          ),
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10.0),
        itemCount: subjects.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotesPage(subject: subjects[index]),
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 5.0),
              padding: EdgeInsets.all(80.0),
              decoration: BoxDecoration(
                color: Colors.primaries[index % Colors.primaries.length],
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      subjects[index],
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Icon(Icons.arrow_forward)
                  ]),
            ),
          );
        },
      ),
    );
  }
}
