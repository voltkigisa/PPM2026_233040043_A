import 'package:flutter/material.dart';
import 'widget_gallery.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      themeMode: _themeMode,
      home: ProfilePage(
        toggleTheme: _toggleTheme,
        isDarkMode: _themeMode == ThemeMode.dark,
      ),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    super.key,
    required this.toggleTheme,
    required this.isDarkMode,
  });

  final VoidCallback toggleTheme;
  final bool isDarkMode;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}
class _ProfilePageState extends State<ProfilePage> {
   // Contoh data untuk ListView.builder
   final List<String> items = [
     'Item 1',
     'Item 2',
     'Item 3',
     'Item 4',
     'Item 5',
     'Item 6',
     'Item 7',
     'Item 8',
     'Item 9',
     'Item 10',
   ];

   @override
   Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(
         title: const Text('Profil Saya'),
         actions: [
           IconButton(
             icon: const Icon(Icons.search),
             onPressed: () {},
           ),
           IconButton(
             icon: const Icon(Icons.collections),
             onPressed: () {
               Navigator.push(
                 context,
                 MaterialPageRoute(builder: (context) => const WidgetGallery()),
               );
             },
           ),
           IconButton(
             icon: Icon(
               widget.isDarkMode ? Icons.dark_mode : Icons.light_mode,
             ),
             onPressed: widget.toggleTheme,
           ),
         ],
       ),
      drawer: Drawer(
        child: ListView(
          children: const [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(leading: Icon(Icons.home), title: Text('Beranda')),
            ListTile(leading: Icon(Icons.person), title: Text('Profil')),
            ListTile(leading: Icon(Icons.settings), title: Text('Pengaturan')),
            ListTile(leading: Icon(Icons.info), title: Text('Tentang')),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          // Contoh penggunaan EdgeInsets yang berbeda untuk setiap item
          EdgeInsets padding;
          switch (index % 4) {
            case 0:
              padding = EdgeInsets.all(16); // semua sisi 16
              break;
            case 1:
              padding = EdgeInsets.symmetric(horizontal: 24, vertical: 8); // kiri-kanan 24, atas-bawah 8
              break;
            case 2:
              padding = EdgeInsets.only(left: 16, top: 8); // pilih sisi tertentu
              break;
            case 3:
              padding = EdgeInsets.fromLTRB(16, 8, 16, 24); // left, top, right, bottom
              break;
            default:
              padding = EdgeInsets.zero;
          }

          return Padding(
            padding: padding,
            child: Card(
              child: ListTile(
                title: Text(items[index]),
                subtitle: Text('Padding: ${padding.toString()}'),
                leading: CircleAvatar(
                  child: Text('${index + 1}'),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.edit),
        label: const Text('Edit'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Pengaturan'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'Tentang'),
        ],
      ),
    );
  }
}