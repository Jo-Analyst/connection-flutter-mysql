import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CURSOS DE INFORMÁTICA',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, dynamic>> _users = [];

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    final connection = await getConnection();
    await connection.query("SELECT * FROM categorias");
    var results = await connection.query("SELECT * FROM categorias");
    setState(() {
      _users = results.map((r) => r.fields).toList();
    });
    await connection.close();
  }

  Future<MySqlConnection> getConnection() async {
    final settings = ConnectionSettings(
      host: dotenv.env["HOST"]!,
      port: int.parse(dotenv.env["PORT"]!),
      user: dotenv.env["USER"]!,
      password: dotenv.env["PASSWORD"]!,
      db: dotenv.env["DB"]!,
    );
    final connection = await MySqlConnection.connect(settings);
    return connection;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = screenWidth / 2; // Definindo o tamanho da coluna

    return Scaffold(
      appBar: AppBar(
        title: const Text('CURSOS DE INFORMÁTICA'),
        centerTitle: true,
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: itemWidth / 150,
                ),
                itemCount: _users.length,
                itemBuilder: (context, index) {
                  final user = _users[index];
                  return GridTile(
                    child: Container(
                      color: Colors.grey[200],
                      child: Center(
                        child: Text(
                          user['nome'],
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
