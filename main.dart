import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Soma:'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controlaSoma = TextEditingController();
  List<Icon?> _resultadoIcons = List.generate(10, (index) => null);
  int _x = 1;
  int _y = Random().nextInt(10);
  final Map<String, bool> _somasAcertadas = {};

  void _corrigir() {
    int soma = _x + _y;
    String digitado = _controlaSoma.text;
    int resultado = int.tryParse(digitado) ?? -1;

    setState(() {
      if (soma == resultado) {
        _resultadoIcons[_y] = const Icon(Icons.check, color: Colors.green);
        _somasAcertadas['$_x+$_y'] = true; // Marca a soma como acertada.
        _gerarNovaSoma();
      } else {
        _resultadoIcons[_y] ??= const Icon(Icons.close, color: Colors.red);
      }
      _controlaSoma.clear();
    });
  }

  void _mudarX() {
    setState(() {
      _gerarNovaSoma();
    });
  }

  void _gerarNovaSoma() {
    Random rand = Random();
    int novoX, novoY;
    do {
      novoX = rand.nextInt(10);
      novoY = rand.nextInt(10);
    } while (_somasAcertadas
        .containsKey('$novoX+$novoY')); // Evita somas já acertadas.
    _y = novoY;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('$_x + $_y = '),
                SizedBox(
                  width: 50,
                  child: TextField(
                    controller: _controlaSoma,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _corrigir,
                  child: const Text('Corrigir'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _mudarX,
              child: const Text('Mudar X'),
            ),
            const SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: List.generate(_resultadoIcons.length,
                    (index) => DataColumn(label: Text(''))),
                rows: [
                  DataRow(
                    cells: List.generate(
                        _resultadoIcons.length,
                        (index) => DataCell(_resultadoIcons[index] ??
                            const Icon(Icons.circle,
                                color: Colors.transparent))),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _mudarX,
        tooltip: 'Mudar X',
        child: const Icon(Icons.shuffle),
      ),
    );
  }
}
