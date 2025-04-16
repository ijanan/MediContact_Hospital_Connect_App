import 'package:flutter/material.dart';
import 'package:myapp/home_screen.dart';
import 'package:myapp/profile_screen.dart';

class NewsFeedScreen extends StatefulWidget {
  const NewsFeedScreen({Key? key}) : super(key: key);

  @override
  NewsFeedScreenState createState() => NewsFeedScreenState();
}

class NewsFeedScreenState extends State<NewsFeedScreen> {
  int _selectedBottomIndex = 1;
  final List<Map<String, String>> _posts = [
    {
      'userName': 'Anonymous',
      'userImageUrl': 'assets/images/user_placeholder.png',
      'postContent': 'This is a news feed post.',
      'postImageUrl': 'assets/images/post_placeholder.png',
    },
    {
      'userName': 'Anonymous',
      'userImageUrl': 'assets/images/user_placeholder.png',
      'postContent': 'This is a news feed post.',
      'postImageUrl': 'assets/images/post_placeholder.png',
    },
  ];

  void navigateTo(Widget screen) {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => screen)
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
                backgroundImage: AssetImage('assets/images/user_placeholder.png'),
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
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () {}, icon: const Icon(Icons.camera_alt)),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 10.0, bottom: 10.0),
            child: Text('Recently Post', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
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
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.feed),
            label: 'News',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),],
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
    return Container(
      margin: const EdgeInsets.all(10.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(post['userImageUrl']!),
              radius: 20,
            ),
            title: Text(post['userName']!, style: const TextStyle(fontWeight: FontWeight.bold)),
            trailing: PopupMenuButton<String>(
              onSelected: (value) {
              },
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
          Image(image: AssetImage(post['postImageUrl']!),
            fit: BoxFit.cover,
          ),
          
        ],
      ),
    );
  }
}