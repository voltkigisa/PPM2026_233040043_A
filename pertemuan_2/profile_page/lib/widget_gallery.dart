import 'package:flutter/material.dart';

class WidgetGallery extends StatelessWidget {
  const WidgetGallery({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Widget Gallery'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Widget Gallery',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          _buildSectionTitle('Basic Widgets'),
          _buildBasicWidgets(),
          const SizedBox(height: 20),
          _buildSectionTitle('Layout Widgets'),
          _buildLayoutWidgets(),
          const SizedBox(height: 20),
          _buildSectionTitle('Interactive Widgets'),
          _buildInteractiveWidgets(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget _buildBasicWidgets() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildWidgetCard('Text', const Text(
          'This is a sample text widget.',
          style: TextStyle(fontSize: 16),
        )),
        _buildWidgetCard('Icon', const Icon(
          Icons.favorite,
          size: 40,
          color: Colors.red,
        )),
        _buildWidgetCard('Image', Container(
          width: 100,
          height: 100,
          color: Colors.grey.shade300,
          child: const Icon(Icons.image, size: 50),
        )),
        _buildWidgetCard('Container', Container(
          width: 100,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.green.shade200,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(
            child: Text('Container'),
          ),
        )),
      ],
    );
  }

  Widget _buildLayoutWidgets() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildWidgetCard('Row', Container(
          height: 60,
          color: Colors.grey.shade200,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(Icons.star, color: Colors.yellow),
              Icon(Icons.star, color: Colors.yellow),
              Icon(Icons.star, color: Colors.yellow),
            ],
          ),
        )),
        _buildWidgetCard('Column', Container(
          width: 100,
          height: 100,
          color: Colors.grey.shade200,
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.home),
              Text('Home'),
            ],
          ),
        )),
        _buildWidgetCard('Stack', Container(
          width: 150,
          height: 100,
          color: Colors.grey.shade300,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 100,
                height: 60,
                color: Colors.blue,
              ),
              Text(
                'Stack',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        )),
        _buildWidgetCard('ListView', SizedBox(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: List.generate(5, (index) => Container(
              width: 80,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              color: Colors.primaries[index % Colors.primaries.length],
              child: Center(child: Text('Item $index')),
            )),
          ),
        )),
      ],
    );
  }

  Widget _buildInteractiveWidgets() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildWidgetCard('ElevatedButton', ElevatedButton(
          onPressed: () {},
          child: const Text('Elevated Button'),
        )),
        _buildWidgetCard('OutlinedButton', OutlinedButton(
          onPressed: () {},
          child: const Text('Outlined Button'),
        )),
        _buildWidgetCard('TextButton', TextButton(
          onPressed: () {},
          child: const Text('Text Button'),
        )),
        _buildWidgetCard('Checkbox', const Row(
          children: [
            Checkbox(
              value: true,
              onChanged: null,
            ),
            Text('Checkbox'),
          ],
        )),
        _buildWidgetCard('Switch', const Row(
          children: [
            Switch(
              value: true,
              onChanged: null,
            ),
            Text('Switch'),
          ],
        )),
        _buildWidgetCard('Slider', Container(
          width: 200,
          child: Slider(
            value: 0.5,
            onChanged: null,
          ),
        )),
        _buildWidgetCard('TextField', const TextField(
          decoration: InputDecoration(
            labelText: 'Enter text',
            border: OutlineInputBorder(),
          ),
        )),
      ],
    );
  }

  Widget _buildWidgetCard(String title, Widget child) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }
}