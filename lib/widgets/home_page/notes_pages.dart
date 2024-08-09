import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotesPage extends StatefulWidget {
  final String subject;

  NotesPage({required this.subject});

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final CollectionReference _notesCollection =
      FirebaseFirestore.instance.collection('notes');
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.requestPermission();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(message.notification!.title ?? 'Notification'),
            content: Text(message.notification!.body ?? 'New Notification'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    });
  }

  Future<void> _uploadFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );

      if (result != null) {
        PlatformFile file = result.files.first;
        String fileName = file.name;

        // Firebase Storage'a dosyayı yüklememe ***
        if (file.bytes != null) {
          // Web platformunda dosya yükleme   ****
          await FirebaseStorage.instance
              .ref('uploads/$fileName')
              .putData(file.bytes!);
        } else if (file.path != null) {
          // Mobil platformda dosya yükleme  ****
          File selectedFile = File(file.path!);
          await FirebaseStorage.instance
              .ref('uploads/$fileName')
              .putFile(selectedFile);
        }

        // Dosya URL'sini alın
        String downloadURL = await FirebaseStorage.instance
            .ref('uploads/$fileName')
            .getDownloadURL();

        // Firestore'a dosya bilgilerini kaydedetme  ****
        await _notesCollection.add({
          'subject': widget.subject,
          'fileName': fileName,
          'fileURL': downloadURL,
          'timestamp': FieldValue.serverTimestamp(),
        });

        print('Dosya başarıyla yüklendi: $fileName');

        // Bildirim gönderme yeni dosya yuklendiginde bildirim gonderiyoruz
        await (fileName);
      } else {
        print('Dosya seçilmedi.');
      }
    } catch (e) {
      print('Dosya yükleme hatası: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.subject} Notları'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _notesCollection
                  .where('subject', isEqualTo: widget.subject)
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                return ListView(
                  children: snapshot.data!.docs.map((doc) {
                    return ListTile(
                      title: Text(doc['fileName']),
                      onTap: () {
                        // Dosya URL'sini kullanarak dosyayı indirme
                        (doc['fileURL']);
                      },
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _uploadFile,
        child: Icon(Icons.add),
      ),
    );
  }
}


/*  // FirebaseMessaging örneğini olusturuyoruz
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Token alma işlemi
  try {
    String? fcmToken = await messaging.getToken(
      vapidKey: 'BER2GV1Q_NeNevQjZYeBa0NjI6YGrewL4V0Co8i_nfXY0j1fo6xiJAc8Pe7ykmD6zg6HyL7GlUUa0U7a-axaQh',
    );
    if (fcmToken != null) {
      print("Token: $fcmToken");
    } else {
      print("Token: null");
    }
  } catch (e) {
    print("Error getting FCM token: $e");
  } */