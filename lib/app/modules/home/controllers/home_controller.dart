import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var isLoggedIn = false.obs; // Status login
  var audioUrl = ''.obs; // URL audio dari Firebase

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    // Cek keberadaan token di SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final tokenExists = prefs.getString('token') != null;

    if (tokenExists) {
      // Jika token ada, cek user di Firebase Auth
      final User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        isLoggedIn.value = true;
        await fetchAudioUrl(currentUser.uid); // Ambil URL audio
      } else {
        isLoggedIn.value = false;
      }
    } else {
      isLoggedIn.value = false;
    }
  }

  Future<void> fetchAudioUrl(String userId) async {
    try {
      // Ambil data audio dari koleksi 'audio' di Firebase
      final doc = await _firestore.collection('audio').doc(userId).get();
      if (doc.exists) {
        audioUrl.value = doc.data()?['audio_url'] ?? ''; // Simpan URL audio
      }
    } catch (e) {
      print('Error fetching audio URL: $e');
    }
  }
}
