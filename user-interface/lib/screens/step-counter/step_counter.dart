import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StepCounter extends StatefulWidget {
  const StepCounter({Key? key}) : super(key: key);

  @override
  _StepCounterState createState() => _StepCounterState();
}

class _StepCounterState extends State<StepCounter> {
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  String _status = '?', _steps = '?';
  late User _user; // Firestore user ID holder
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _savedSteps = [];

  @override
  void initState() {
    super.initState();
    _initializeUser();
  }

  void _initializeUser() async {
    _user = FirebaseAuth.instance.currentUser!;
    print('User initialized: ${_user.uid}');
    initPlatformState();
    fetchSavedStepCounts(); // Veritabanından adım sayısını al
  }

  void onStepCount(StepCount event) {
    print('Step count event: ${event.steps}');
    setState(() {
      _steps = event.steps.toString();
    });
    saveStepCount(event.steps);
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    print('Pedestrian status event: ${event.status}');
    setState(() {
      _status = event.status;
    });
  }

  void onPedestrianStatusError(error) {
    print('onPedestrianStatusError: $error');
    setState(() {
      _status = 'Pedestrian Status not available';
    });
    print(_status);
  }

  void onStepCountError(error) {
    print('onStepCountError: $error');
    setState(() {
      _steps = 'Step Count not available';
    });
  }

  void initPlatformState() {
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);

    if (!mounted) return;
  }

  Future<void> saveStepCount(int steps) async {
    try {
      await _firestore
          .collection('Users')
          .doc(_user.uid)
          .collection('step_counter')
          .add({
        'step_count': steps,
        'timestamp': FieldValue.serverTimestamp(),
      });
      fetchSavedStepCounts(); // Yeni adım sayısını kaydettikten sonra verileri al
    } catch (e) {
      print('Adım sayısını kaydederken hata oluştu: $e');
    }
  }

  Future<void> fetchSavedStepCounts() async {
    try {
      final querySnapshot = await _firestore
          .collection('Users')
          .doc(_user.uid)
          .collection('step_counter')
          .orderBy('timestamp', descending: true)
          .get();
      setState(() {
        _savedSteps = querySnapshot.docs
            .map((doc) =>
                {'steps': doc['step_count'], 'timestamp': doc['timestamp']})
            .toList();
      });
      print('Kaydedilen adım sayıları alındı: $_savedSteps');

      // Widget'i güncelle
      setState(() {}); // Boş setState çağrısı bile widget'i yeniden çizer
    } catch (e) {
      print('Adım sayılarını alırken hata oluştu: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedometer '),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Steps Taken',
              style: TextStyle(fontSize: 30),
            ),
            Text(
              _steps,
              style: const TextStyle(fontSize: 60),
            ),
            const Divider(
              height: 100,
              thickness: 0,
              color: Colors.white,
            ),
            const Text(
              'Pedestrian Status',
              style: TextStyle(fontSize: 30),
            ),
            Icon(
              _status == 'walking'
                  ? Icons.directions_walk
                  : _status == 'stopped'
                      ? Icons.accessibility_new
                      : Icons.error,
              size: 100,
            ),
            Center(
              child: Text(
                _status,
                style: _status == 'walking' || _status == 'stopped'
                    ? const TextStyle(fontSize: 30)
                    : const TextStyle(fontSize: 20, color: Colors.red),
              ),
            ),
            const Divider(
              height: 100,
              thickness: 0,
              color: Colors.white,
            ),
            const Text(
              'Saved Steps',
              style: TextStyle(fontSize: 30),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _savedSteps.length,
                itemBuilder: (context, index) {
                  final stepData = _savedSteps[index];
                  return ListTile(
                    title: Text('Steps: ${stepData['steps']}'),
                    subtitle: Text('Time: ${stepData['timestamp']}'),
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
