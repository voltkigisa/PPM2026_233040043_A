import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class Catatan {
  final String judul;
  final String isi;
  final String kategori;
  final String email;
  final DateTime dibuatPada;

  Catatan({
    required this.judul,
    required this.isi,
    required this.kategori,
    required this.email,
    required this.dibuatPada,
  });

  Catatan copyWith({
    String? judul,
    String? isi,
    String? kategori,
    String? email,
  }) {
    return Catatan(
      judul: judul ?? this.judul,
      isi: isi ?? this.isi,
      kategori: kategori ?? this.kategori,
      email: email ?? this.email,
      dibuatPada: this.dibuatPada, // tetap pakai tanggal asli
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catatan Mahasiswa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      initialRoute: '/',
      routes: {'/': (context) => const HomePage()},
      onGenerateRoute: (settings) {
        if (settings.name == '/tambah') {
          final catatan = settings.arguments as Catatan?;
          return MaterialPageRoute(
            builder: (_) => TambahCatatanPage(catatanEdit: catatan),
          );
        } else if (settings.name == '/detail') {
          final catatan = settings.arguments as Catatan;
          return MaterialPageRoute(
            builder: (_) => DetailCatatanPage(catatan: catatan),
          );
        }
        return null;
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // === STATE ===
  final List<Catatan> _catatan = [
    Catatan(
      judul: 'Belajar Flutter',
      isi: 'Mempelajari Stateful Widget, Form, dan Navigation.',
      kategori: 'Kuliah',
      email: 'mahasiswa@unpas.ac.id',
      dibuatPada: DateTime.now(),
    ),
  ];
  String _filterKategori = 'Semua';
  final _kategoriOpsi = const [
    'Semua',
    'Kuliah',
    'Tugas',
    'Pribadi',
    'Lainnya',
  ];

  List<Catatan> get _catatanFiltered {
    if (_filterKategori == 'Semua') return _catatan;
    return _catatan.where((c) => c.kategori == _filterKategori).toList();
  }

  Future<void> _bukaTambahCatatan() async {
    final hasil = await Navigator.pushNamed(context, '/tambah');

    if (hasil is Catatan) {
      setState(() => _catatan.add(hasil));

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Catatan "${hasil.judul}" ditambahkan')),
      );
    }
  }

  void _hapusCatatan(int index) {
    final judulDihapus = _catatan[index].judul;
    setState(() => _catatan.removeAt(index));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Catatan "$judulDihapus" dihapus'),
        action: SnackBarAction(label: 'Urungkan', onPressed: () {}),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catatan Mahasiswa'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: DropdownButton<String>(
              value: _filterKategori,
              underline: const SizedBox(), // hilangkan garis bawah
              icon: const Icon(Icons.filter_list),
              items: _kategoriOpsi
                  .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                  .toList(),
              onChanged: (v) => setState(() => _filterKategori = v!),
            ),
          ),
        ],
      ),
      body: _catatanFiltered.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.note_outlined, size: 80, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    _filterKategori == 'Semua'
                        ? 'Belum ada catatan'
                        : 'Tidak ada catatan "$_filterKategori"',
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tekan + untuk menambah catatan baru',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _catatanFiltered.length,
              itemBuilder: (context, i) {
                final c = _catatanFiltered[i]; // ✅ pakai filtered
                final indexAsli = _catatan.indexOf(
                  c,
                ); // ✅ index di list asli untuk hapus/edit

                return Dismissible(
                  key: ValueKey(c.dibuatPada),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) =>
                      _hapusCatatan(indexAsli), // ✅ pakai index asli
                  child: ListTile(
                    leading: const Icon(Icons.note),
                    title: Text(c.judul),
                    subtitle: Text(c.kategori),
                    onTap: () async {
                      final hasil = await Navigator.pushNamed(
                        context,
                        '/detail',
                        arguments: c,
                      );

                      if (hasil == 'hapus') {
                        _hapusCatatan(indexAsli); // ✅ pakai index asli
                      } else if (hasil is Catatan) {
                        setState(
                          () => _catatan[indexAsli] = hasil,
                        ); // ✅ pakai index asli
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Catatan "${hasil.judul}" diperbarui',
                            ),
                          ),
                        );
                      }
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _bukaTambahCatatan, // panggil method yang sudah dibuat
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TambahCatatanPage extends StatefulWidget {
  final Catatan? catatanEdit; // ✅ null = tambah baru, isi = mode edit

  const TambahCatatanPage({super.key, this.catatanEdit});

  @override
  State<TambahCatatanPage> createState() => _TambahCatatanPageState();
}

class _TambahCatatanPageState extends State<TambahCatatanPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _judulCtrl;
  late final TextEditingController _isiCtrl;
  late String _kategori;
  late final TextEditingController _emailCtrl;

  final _kategoriOpsi = const ['Kuliah', 'Tugas', 'Pribadi', 'Lainnya'];

  bool get _isEdit => widget.catatanEdit != null; // ✅ helper

  @override
  void initState() {
    super.initState();
    _judulCtrl = TextEditingController(text: widget.catatanEdit?.judul ?? '');
    _isiCtrl = TextEditingController(text: widget.catatanEdit?.isi ?? '');
    _emailCtrl = TextEditingController(
      text: widget.catatanEdit?.email ?? '',
    ); // ✅
    _kategori = widget.catatanEdit?.kategori ?? 'Kuliah';
  }

  @override
  void dispose() {
    _judulCtrl.dispose();
    _isiCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  void _simpan() {
    if (!_formKey.currentState!.validate()) return;

    final hasil = _isEdit
        ? widget.catatanEdit!.copyWith(
            judul: _judulCtrl.text.trim(),
            isi: _isiCtrl.text.trim(),
            kategori: _kategori,
            email: _emailCtrl.text.trim(),
          )
        : Catatan(
            judul: _judulCtrl.text.trim(),
            isi: _isiCtrl.text.trim(),
            kategori: _kategori,
            email: _emailCtrl.text.trim(),
            dibuatPada: DateTime.now(),
          );

    Navigator.pop(context, hasil);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEdit ? 'Edit Catatan' : 'Tambah Catatan',
        ), // ✅ judul dinamis
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _judulCtrl,
              decoration: const InputDecoration(
                labelText: 'Judul',
                prefixIcon: Icon(Icons.title),
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Judul wajib diisi';
                if (v.trim().length < 3) return 'Minimal 3 karakter';
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _kategori,
              decoration: const InputDecoration(
                labelText: 'Kategori',
                prefixIcon: Icon(Icons.category),
                border: OutlineInputBorder(),
              ),
              items: _kategoriOpsi
                  .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                  .toList(),
              onChanged: (v) => setState(() => _kategori = v!),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email Pengirim',
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Email wajib diisi';
                final regex = RegExp(r'^[\w.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z]{2,}$');
                if (!regex.hasMatch(v.trim()))
                  return 'Format email tidak valid';
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _isiCtrl,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Isi',
                prefixIcon: Icon(Icons.notes),
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Isi wajib diisi' : null,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _simpan,
              icon: const Icon(Icons.save),
              label: Text(_isEdit ? 'Update' : 'Simpan'), // ✅ label dinamis
            ),
          ],
        ),
      ),
    );
  }
}

// Ubah class menjadi StatelessWidget dengan parameter onHapus
class DetailCatatanPage extends StatelessWidget {
  final Catatan catatan;
  const DetailCatatanPage({super.key, required this.catatan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Catatan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit Catatan',
            onPressed: () async {
              final hasil = await Navigator.pushNamed(
                context,
                '/tambah',
                arguments: catatan,
              );
              if (hasil is Catatan && context.mounted) {
                Navigator.pop(context, hasil); // kirim hasil edit ke HomePage
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Hapus Catatan',
            onPressed: () async {
              // Tampilkan dialog konfirmasi dulu
              final konfirmasi = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Hapus Catatan?'),
                  content: Text(
                    'Catatan "${catatan.judul}" akan dihapus permanen.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text('Batal'),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text('Hapus'),
                    ),
                  ],
                ),
              );

              if (konfirmasi == true && context.mounted) {
                Navigator.pop(
                  context,
                  'hapus',
                ); // kirim sinyal 'hapus' ke HomePage
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              catatan.judul,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Chip(label: Text(catatan.kategori)),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.email_outlined, size: 16, color: Colors.grey),
                const SizedBox(width: 6),
                Text(
                  catatan.email,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            const Divider(height: 32),
            Text(
              catatan.isi,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
