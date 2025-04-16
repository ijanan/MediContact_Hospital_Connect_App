
import 'dart:io';

import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'news_feed_screen.dart';
import 'profile_screen.dart';

class PrescriptionsScreen extends StatefulWidget {
  const PrescriptionsScreen({super.key});

  

  @override
  PrescriptionsScreenState createState() => PrescriptionsScreenState();
}

class PrescriptionsScreenState extends State<PrescriptionsScreen> {
  int _selectedBottomIndex = 0;
  List<File> _prescriptions = [];
  bool _showAllImages = false;


  void _onItemTapped(int index) {
    
    setState(() {
      _selectedBottomIndex = index;
      if (_selectedBottomIndex == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NewsFeedScreen()),
        ).then((_) => setState(() {}));
      } else if (_selectedBottomIndex == 0) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        ).then((_) => setState(() {}));
      } else if (_selectedBottomIndex == 2) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        ).then((_) => setState(() {}));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF9A75F9)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Prescriptions'),
        centerTitle: true,
        
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        color: const Color(0xFFEAEAEA),
        child: Column(
          children: <Widget>[
             Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _showAllImages = !_showAllImages;
                    });
                  },
                  icon: Icon(_showAllImages ? Icons.folder_open : Icons.folder),
                  label: Text(_showAllImages ? "Close Folder" : "Folder"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9A75F9),
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _showAllImages 
                  ? GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: _prescriptions.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Image.file(_prescriptions[index], fit: BoxFit.cover);
                      },
                    )
                   : Container(
                    alignment: Alignment.center,
                     child: const Text("Press Folder Button to view all images",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                   )
              ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 50),
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
           
             FloatingActionButton(
              heroTag: "btn2",
              onPressed: () => _pickImage(ImageSource.camera),
              backgroundColor: const Color(0xFF9A75F9),
              child: const Icon(Icons.camera_alt, color: Colors.white,),
              
            ),
            const SizedBox(width: 10),
             FloatingActionButton(
              heroTag: "btn1",
               onPressed: () => _pickImage(ImageSource.gallery),
               backgroundColor: const Color(0xFF9A75F9),
               child: const Icon(Icons.add, color: Colors.white,),
              
            ),
           ],
         ),
       ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.newspaper_outlined), label: 'News Feed'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: 'Profile'),
        ],
        currentIndex: _selectedBottomIndex,
        selectedItemColor: const Color(0xFF9A75F9),
        onTap: _onItemTapped,
      ),
    );
  }
    final ImagePicker _picker = ImagePicker();
  Future<void> _pickImage(ImageSource source) async {
     final pickedFile = await _picker.pickImage(source: source);
     if (pickedFile != null) {
      setState(()=>_prescriptions.add(File(pickedFile.path)));
    }
  }
}