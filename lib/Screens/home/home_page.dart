import 'package:flutter/material.dart';
import 'package:park_wise/Screens/home/setup_components/lot_selector_page.dart';
import '../home/setup_components/feed_page.dart';
import '../home/setup_components/settings_screen.dart';


class HomePage extends StatelessWidget {
  
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController( 
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            'ParkWise',
            style: TextStyle(fontSize: 16),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsScreen()),
                );
              },
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(40),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: Container(
                height: 40,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: Color.fromARGB(255, 198, 229, 233),
                ),
                child: const TabBar(
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  indicator: BoxDecoration(
                    color:  Color.fromARGB(255, 21, 206, 230),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.black54,
                  tabs: [
                    Tab(text: 'Feed'),
                    Tab(text: 'Parking Lots'),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            Center(child: FeedPage()),
            Center(child: LotSelectorPage()),
    
          ],
        ),
      ),           
    ); 
  }
}


