import 'package:flutter/material.dart';
import 'package:myapp/home_screen.dart';
import 'package:myapp/profile_screen.dart';
import 'news_feed_screen.dart';

class Hospital{
  final String name;
  final String location;
  final String specialty;
  final String contact;
  final String workingHours;
  final String imageUrl;
    final String about;

  Hospital({
    required this.name,
    required this.location,
    required this.specialty,
    required this.contact,
    required this.workingHours,
    required this.imageUrl,required this.about,
  }) ;

}
  
class HospitalDetailPage extends StatefulWidget {
    final Hospital hospital;
  const HospitalDetailPage({super.key, required this.hospital});

  @override
  State<HospitalDetailPage> createState() => _HospitalDetailPageState();
}

class _HospitalDetailPageState extends State<HospitalDetailPage> {
  
  @override
  Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
             backgroundColor: Colors.transparent,
        
            elevation: 0,
            title: const Text('Hospital Details'),
            leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF9A75F9)),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ),
          body:   Column(
         
            children: const [
                 Center(
                  child: Text("No Information Avilable",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                ),

            ],
          ),
        ); 
  }
}

class HospitalsScreen extends StatefulWidget {
  const HospitalsScreen({super.key});

  @override
  HospitalsScreenState createState() => HospitalsScreenState();
}



class HospitalsScreenState extends State<HospitalsScreen> {
  int _selectedBottomIndex = 0;
     List<Hospital> filteredHospitals = [];

    @override
  void initState() {
    super.initState();
    filteredHospitals = List.from(_hospitals);
  }
  void filterHospitals(String query) {
    List<Hospital> tempList = [];
    if (query.isEmpty) {
      tempList = List.from(_hospitals);
    } else {
      for (var hospital in _hospitals) {
        if (hospital.name.toLowerCase().contains(query.toLowerCase()) ||
            hospital.specialty.toLowerCase().contains(query.toLowerCase())) {
          tempList.add(hospital);
        }
      }
    }
    setState(() {
      filteredHospitals = tempList;
    });
  }
final TextEditingController _searchController = TextEditingController();

  

 final List<Hospital> _hospitals = [
    Hospital(
      name: "Ibn Sina Specialized Hospital",
      location: "House # 48, Road # 9/A, Dhanmondi, Dhaka 1209",
      specialty: "Multidisciplinary",
      contact: "Hotline: 10615, +88 09610010615",
      workingHours: "24/7",
      imageUrl: "https://i.ibb.co/jH44z0T/ibn-sina.png",
      about: "To serve the humanity as a whole with this noble vision the Ibn Sina Trust started its journey in June 1980. The trust has agreed upon to provide health care service to the people of Bangladesh with affordable cost.",

    ),
    Hospital(
      name: "United Hospital Limited",
      location: "Plot 15, Road 71, Gulshan, Dhaka-1212, Bangladesh",
      specialty: "Multidisciplinary",
      contact: "+8802222262466",
      workingHours: "24/7",
      imageUrl: "https://i.ibb.co/v4K935z/united-hospital.png",
      about: "United Hospital Limited is one of the largest and most comprehensive multidisciplinary hospitals in Bangladesh. It is located in the heart of Gulshan, Dhaka.",
    ),
    Hospital(
      name: "Square Hospitals Ltd",
      location: "18/F, Bir Uttam Qazi Nuruzzaman Sarak, West Panthapath, Dhaka 1205",
      specialty: "Multidisciplinary",
      contact: "+8801713377977",
      workingHours: "24/7",
      imageUrl: "https://i.ibb.co/X2B9s6v/square-hospital.png",
      about: "Square Hospitals Ltd. is a tertiary care hospital with 650 beds, which has been designed and built to provide comprehensive healthcare services in Bangladesh.",
    ),
  ];

 

  void _onItemTapped(int index) {
    setState(() {
      _selectedBottomIndex = index;
      if (_selectedBottomIndex == 1) {
        Navigator.push(context,
                MaterialPageRoute(builder: (context) => const NewsFeedScreen()))
            .then((_) => setState(() {}));
      }
      else if(_selectedBottomIndex==0){
          Navigator.push(
           context,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
          ).then((value) => setState(() {}));
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
        title: const Text('Information',style: TextStyle(color: Color(0xFF9A75F9)),),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF9A75F9)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
              Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _searchController,
                    onChanged: filterHospitals,
                    decoration: InputDecoration(
                      labelText: "Search Hospital",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                  ),
                ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredHospitals.length,
              itemBuilder: (context, index) {
                final hospital = filteredHospitals[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: Image.network(hospital.imageUrl,width: 50,height: 50,),
                   title: Text(hospital.name,style:const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                    subtitle:  Text('Specialty: ${hospital.specialty}'),
                    trailing: TextButton(
                     onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>  HospitalDetailPage(hospital: hospital,),
                          ),
                        ).then((value) => setState(() {}));
                      },
                       child: const Text("More Info",style: TextStyle(color: Color(0xFF9A75F9)),),
                    ),

                  ),
                );
              },
              ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper_outlined),
            label: 'News Feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedBottomIndex,
        selectedItemColor: const Color(0xFF9A75F9),
        onTap: _onItemTapped,
      ),
    );
  }
}