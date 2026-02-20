import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Islam Videos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green), // Changed to green for Islamic theme
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/player': (context) => const VideoPlayerScreen(),
      },
    );
  }
}

class Video {
  final String id;
  final String title;
  final String description;
  final String youtubeUrl;

  const Video({
    required this.id,
    required this.title,
    required this.description,
    required this.youtubeUrl,
  });

  String get thumbnailUrl => YoutubePlayer.getThumbnail(videoId: id);
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Mock data for Islamic videos - replace with dynamic data once Supabase is connected
  static const List<Video> videos = [
    Video(
      id: 'dQw4w9WgXcQ', // Placeholder YouTube ID - replace with real Islamic video IDs
      title: 'Beautiful Quran Recitation',
      description: 'A soothing recitation of Surah Al-Fatiha by Sheikh Saad Al-Ghamidi.',
      youtubeUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
    ),
    Video(
      id: '9bZkp7q19f0', // Another placeholder
      title: 'Islamic Lecture: The Importance of Prayer',
      description: 'Dr. Yasir Qadhi explains the significance of Salah in Islam.',
      youtubeUrl: 'https://www.youtube.com/watch?v=9bZkp7q19f0',
    ),
    Video(
      id: 'kJQP7kiw5Fk', // Another placeholder
      title: 'Islamic History: Life of Prophet Muhammad',
      description: 'An educational video on the biography of the Prophet (PBUH).',
      youtubeUrl: 'https://www.youtube.com/watch?v=kJQP7kiw5Fk',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Islam Videos'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: ListView.builder(
        itemCount: videos.length,
        itemBuilder: (context, index) {
          final video = videos[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: Image.network(
                video.thumbnailUrl,
                width: 100,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.video_library, size: 60),
              ),
              title: Text(video.title, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(video.description),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/player',
                  arguments: video,
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late YoutubePlayerController _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final video = ModalRoute.of(context)!.settings.arguments as Video;
    _controller = YoutubePlayerController(
      initialVideoId: video.id,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final video = ModalRoute.of(context)!.settings.arguments as Video;
    return Scaffold(
      appBar: AppBar(
        title: Text(video.title),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.green,
      ),
    );
  }
}