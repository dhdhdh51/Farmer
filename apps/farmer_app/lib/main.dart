import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

final authProvider = StreamProvider<User?>((ref) => FirebaseAuth.instance.authStateChanges());

Future<void> _bg(RemoteMessage message) async {}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  await Hive.openBox('offline_queue');
  FirebaseMessaging.onBackgroundMessage(_bg);
  runApp(const ProviderScope(child: KisanLedgerApp()));
}

class KisanLedgerApp extends ConsumerWidget {
  const KisanLedgerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    return MaterialApp(
      title: 'Kisan Ledger',
      theme: ThemeData(colorSchemeSeed: Colors.green, useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      home: auth.when(
        data: (user) => user == null ? const LoginPage() : const FarmerHomePage(),
        loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (_, __) => const Scaffold(body: Center(child: Text('Auth error'))),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final email = TextEditingController();
  final pass = TextEditingController();
  String? err;
  Future<void> signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email.text.trim(), password: pass.text.trim());
    } on FirebaseAuthException catch (e) {
      setState(() => err = e.message);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            TextField(controller: email, decoration: const InputDecoration(labelText: 'Email')),
            TextField(controller: pass, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
            if (err != null) Text(err!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 12),
            FilledButton(onPressed: signIn, child: const Text('Login')),
            TextButton(
              onPressed: () => FirebaseAuth.instance.sendPasswordResetEmail(email: email.text.trim()),
              child: const Text('Forgot Password'),
            ),
          ]),
        ),
      );
}

class FarmerHomePage extends StatelessWidget {
  const FarmerHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final fields = FirebaseFirestore.instance.collection('fields').where('ownerId', isEqualTo: uid);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kisan Ledger Dashboard'),
        actions: [IconButton(onPressed: () => FirebaseAuth.instance.signOut(), icon: const Icon(Icons.logout))],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => fields.add({
          'ownerId': uid,
          'name': 'New Field',
          'village': 'Unknown',
          'area': 1.0,
          'unit': 'acre',
          'createdAt': FieldValue.serverTimestamp(),
        }),
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: fields.snapshots(),
        builder: (context, snap) {
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final docs = snap.data!.docs;
          return ListView(
            children: [
              Card(child: ListTile(title: const Text('Weather'), subtitle: const Text('Integrate weather API key in production.'))),
              ...docs.map((d) => Card(
                    child: ListTile(
                      title: Text(d['name'] ?? ''),
                      subtitle: Text('${d['village']} • ${d['area']} ${d['unit']}'),
                    ),
                  )),
            ],
          );
        },
      ),
    );
  }
}
