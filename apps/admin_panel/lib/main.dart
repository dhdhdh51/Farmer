import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const AdminApp());
}

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Kisan Ledger Admin',
        theme: ThemeData(colorSchemeSeed: Colors.green, useMaterial3: true),
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, s) => s.data == null ? const AdminLogin() : const AdminDashboard(),
        ),
      );
}

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});
  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final email = TextEditingController();
  final pass = TextEditingController();
  String? error;
  Future<void> login() async {
    try {
      final cred = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email.text.trim(), password: pass.text.trim());
      final doc = await FirebaseFirestore.instance.collection('users').doc(cred.user!.uid).get();
      if (!['admin', 'super_admin'].contains(doc.data()?['role'])) {
        await FirebaseAuth.instance.signOut();
        setState(() => error = 'Not authorized');
      }
    } catch (e) {
      setState(() => error = '$e');
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      body: Center(
          child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                TextField(controller: email, decoration: const InputDecoration(labelText: 'Admin Email')),
                TextField(controller: pass, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
                if (error != null) Text(error!, style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 12),
                FilledButton(onPressed: login, child: const Text('Login'))
              ])))));
}

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final users = FirebaseFirestore.instance.collection('users');
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard'), actions: [IconButton(onPressed: () => FirebaseAuth.instance.signOut(), icon: const Icon(Icons.logout))]),
      body: Row(children: [
        Expanded(
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: users.snapshots(),
            builder: (context, snap) {
              if (!snap.hasData) return const Center(child: CircularProgressIndicator());
              return ListView(
                children: snap.data!.docs
                    .map((u) => ListTile(
                          title: Text(u.data()['name'] ?? 'No Name'),
                          subtitle: Text('${u.id} • ${u.data()['role'] ?? 'farmer'}'),
                          trailing: Switch(
                            value: !(u.data()['blocked'] ?? false),
                            onChanged: (v) => users.doc(u.id).update({'blocked': !v}),
                          ),
                        ))
                    .toList(),
              );
            },
          ),
        ),
      ]),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => FirebaseFirestore.instance.collection('notifications').add({
          'title': 'Admin Announcement',
          'body': 'Stay updated with irrigation plans.',
          'createdAt': FieldValue.serverTimestamp(),
          'target': 'broadcast'
        }),
        label: const Text('Broadcast Notification'),
      ),
    );
  }
}
