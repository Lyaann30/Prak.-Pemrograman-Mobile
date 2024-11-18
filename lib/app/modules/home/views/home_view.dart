import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/app/modules/home/controllers/home_controller.dart';
import 'package:myapp/app/routes/app_pages.dart';
import 'package:audioplayers/audioplayers.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeController homeController = Get.put(HomeController());
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();

    // Future.delayed untuk menunda proses cek login selama 10 detik
    Future.delayed(const Duration(seconds: 10), () async {
      await homeController.checkLoginStatus(); // Cek status login

      if (homeController.isLoggedIn.value) {
        // Jika user login dan audio URL tersedia, putar audio maksimal 7 detik
        if (homeController.audioUrl.value.isNotEmpty) {
          try {
            await _audioPlayer.play(UrlSource(homeController.audioUrl.value));
            // Menghentikan audio setelah 7 detik
            Future.delayed(const Duration(seconds: 7), () async {
              await _audioPlayer.stop();
            });
          } catch (e) {
            print('Failed to play audio: $e');
          }
        }
        // Arahkan ke halaman profil setelah audio selesai atau langsung
        Get.offNamed(Routes.HOMEPAGE);
      } else {
        // Jika belum login, arahkan ke halaman login
        Get.offNamed(Routes.LOGIN);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Mengubah latar belakang menjadi hitam
      body: Center(
        child: Image.asset(
          'assets/logo app.png',
          width: 250,
          height: 250,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
