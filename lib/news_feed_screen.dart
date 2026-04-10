import 'package:flutter/material.dart';
import 'package:myapp/home_screen.dart';
import 'package:myapp/profile_screen.dart';

class NewsFeedScreen extends StatefulWidget {
  const NewsFeedScreen({Key? key}) : super(key: key);

  @override
  NewsFeedScreenState createState() => NewsFeedScreenState();
}

class NewsFeedScreenState extends State<NewsFeedScreen> {
  static const String _localAvatar = 'assets/images/ff.jpg';
  int _selectedBottomIndex = 1;
  final List<Map<String, String>> _posts = [
    {
      'userName': 'Dr. Tanvir Ahmed',
      'userImageUrl': _localAvatar,
      'postContent':
          'Always remember to stay hydrated during these hot summer days!',
      'postImageUrl':
          'https://images.unsplash.com/photo-1511688878353-3a2f5be94cd7?q=80&w=600&fit=crop',
    },
    {
      'userName': 'Dr. Sumaiya Rahman',
      'userImageUrl': _localAvatar,
      'postContent':
          'Our new diagnostic center is now open for appointments. Check the diagnostics tab!',
      'postImageUrl':
          'https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?q=80&w=600&fit=crop',
    },
  ];

  void navigateTo(Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    ).then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Disable default back button
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            const Text('News Feeds'),
            InkWell(
              onTap: () {
                navigateTo(const ProfileScreen());
              },
              child: const CircleAvatar(
                backgroundImage: AssetImage(_localAvatar),
                radius: 20,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),

            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Whats on your mind?',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.camera_alt),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 10.0, bottom: 10.0),
            child: Text(
              'Recently Post',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _posts.length,
              itemBuilder: (context, index) {
                return _buildPost(_posts[index]);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF9A75F9),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.feed), label: 'News'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedBottomIndex,
        onTap: (index) {
          setState(() {
            _selectedBottomIndex = index;
            if (_selectedBottomIndex == 0) {
              navigateTo(const HomeScreen());
            } else if (_selectedBottomIndex == 2) {
              navigateTo(const ProfileScreen());
            }
          });
        },
      ),
    );
  }

  Widget _buildPost(Map<String, String> post) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0, left: 10, right: 10),
      elevation: 3,
      shadowColor: colorScheme.primary.withAlpha(30),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            leading: CircleAvatar(
              backgroundImage: post['userImageUrl']!.startsWith('assets/')
                  ? AssetImage(post['userImageUrl']!) as ImageProvider
                  : NetworkImage(post['userImageUrl']!),
              radius: 20,
            ),
            title: Text(
              post['userName']!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: PopupMenuButton<String>(
              onSelected: (value) {},
              itemBuilder: (BuildContext context) {
                return {'Edit', 'Delete'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Text(post['postContent'] ?? ''),
          ),
          if (post['postImageUrl'] != null && post['postImageUrl']!.isNotEmpty)
            Image.network(
              post['postImageUrl']!,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 200,
                color: colorScheme.surfaceContainerHighest,
                child: const Center(child: Icon(Icons.broken_image, size: 50)),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                  onPressed: () {},
                  icon: Icon(
                    Icons.thumb_up_alt_outlined,
                    color: colorScheme.primary,
                  ),
                  label: Text(
                    'Like',
                    style: TextStyle(color: colorScheme.primary),
                  ),
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: Icon(
                    Icons.comment_outlined,
                    color: colorScheme.primary,
                  ),
                  label: Text(
                    'Comment',
                    style: TextStyle(color: colorScheme.primary),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
