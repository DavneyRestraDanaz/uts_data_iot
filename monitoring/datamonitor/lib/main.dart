import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'models/data_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: TextTheme(
          bodyLarge: const TextStyle(fontSize: 16, color: Colors.black),
          bodyMedium: TextStyle(fontSize: 14, color: Colors.grey[700]),
          titleLarge: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<DataModel> data;

  @override
  void initState() {
    super.initState();
    data = ApiService().fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.home, size: 30),
            SizedBox(width: 8),
            Text("Data Display", style: TextStyle(fontSize: 24)),
          ],
        ),
        backgroundColor: Colors.teal.shade600,
        elevation: 12,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal.shade700, Colors.teal.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<DataModel>(
          future: data,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}", style: const TextStyle(color: Colors.red, fontSize: 16)));
            } else if (!snapshot.hasData) {
              return const Center(child: Text("No Data Available", style: TextStyle(fontSize: 18)));
            } else {
              var data = snapshot.data!;
              return ListView(
                children: [
                  _buildTemperatureBoxes(data),
                  const SizedBox(height: 16),
                  _buildTemperatureList(data),
                  _buildMonthYearList(data),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildTemperatureBoxes(DataModel data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildTemperatureCard("Suhu Max", data.suhumax),
            _buildTemperatureCard("Suhu Min", data.suhumin),
            _buildTemperatureCard("Suhu Rata", data.suhurata),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildTemperatureCard(String title, dynamic value) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 18,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      color: Colors.teal.shade50,
      shadowColor: Colors.teal.withOpacity(0.5),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal),
            ),
            const SizedBox(height: 10),
            Text(
              value.toString(),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTemperatureList(DataModel data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Max Temperature and Humidity Data:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal)),
        ...data.nilaiSuhuMaxHumidMax.map((item) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: _buildTemperatureListItem(item),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildMonthYearList(DataModel data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Month-Year Data:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal)),
        ...data.monthYearMax.map((item) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: _buildMonthYearListItem(item),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildTemperatureListItem(SuhuHumidMax item) {
    return GestureDetector(
      onTap: () => _showDetailDialog(context, item),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        elevation: 12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Colors.teal.shade50,
        shadowColor: Colors.teal.withOpacity(0.5),
        child: ListTile(
          leading: const Icon(Icons.thermostat_rounded, color: Colors.teal),
          title: Text("IDX: ${item.idx}", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          tileColor: Colors.teal.shade100,
        ),
      ),
    );
  }

  Widget _buildMonthYearListItem(MonthYearMax item) {
    return GestureDetector(
      onTap: () {
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        elevation: 12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Colors.teal.shade50,
        shadowColor: Colors.teal.withOpacity(0.5),
        child: ListTile(
          leading: const Icon(Icons.calendar_today_rounded, color: Colors.teal),
          title: Text("Month-Year: ${item.monthYear}", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        ),
      ),
    );
  }

  void _showDetailDialog(BuildContext context, SuhuHumidMax item) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          elevation: 20,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Detail for IDX: ${item.idx}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.teal)),
                const SizedBox(height: 12),
                _buildDetailText("Suhu: ${item.suhu}°C"),
                _buildDetailText("Humid: ${item.humid}%"),
                _buildDetailText("Kecerahan: ${item.kecerahan} Lux"),
                _buildDetailText("Timestamp: ${item.timestamp}"),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Close", style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailText(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 16),
    );
  }
}
