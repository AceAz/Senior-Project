import 'package:flutter/material.dart';
import 'package:park_wise/Screens/home/setup_components/lot_selector_page.dart';
import '../home/signout_form.dart';
import '../home/setup_components/feed_page.dart';
//import '../home/setup_components/school_info_form.dart';


class HomePage extends StatelessWidget {
  
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // return Form(
    //   child: Column(
    //     children: [
    //       ElevatedButton(
    //         onPressed: () async {
    //           AuthService().signout(context: context);
    //           },
    //         child: Text(
    //           "Sign out".toUpperCase(),
    //         ),
    //       )
    //     ]
    //   )
    // );
    return DefaultTabController( 
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'ParkWise',
            style: TextStyle(fontSize: 16),
          ),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(40),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: Container(
                height: 40,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: Colors.green.shade100,
                ),
                child: const TabBar(
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  indicator: BoxDecoration(
                    color: Colors.green,
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


