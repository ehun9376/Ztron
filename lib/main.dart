import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Test7~8"),
      ),
      body: RetryWidget(),
    );
  }
}

class RetryWidget extends StatefulWidget {
  RetryWidget({Key? key}) : super(key: key);

  @override
  State<RetryWidget> createState() => _RetryWidgetState();
}

class _RetryWidgetState extends State<RetryWidget> {
  int retryCount = 0;

  Future<String> fetchData() async {
    try {
      var respond = await http.get(Uri.parse("http"));
      return respond.body.toString();
    } catch (e) {
      if (retryCount >= 3) {
        throw e;
      } else {
        retryCount++;

        return fetchData();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return Center(child: Text('Data: ${snapshot.data}'));
        }
      },
    );
  }
}
