import 'package:flutter/material.dart';
import 'package:letterboxd/pages/main_page.dart';
import 'package:letterboxd/pages/search_movie_page.dart';
import 'package:letterboxd/pages/view_review_page.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  final List<Widget> _pages = [const MainPage(), const ViewReviewPage(), const SearchMoviePage()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Letterboxd'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Handle notifications
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            const UserAccountsDrawerHeader(
              accountName: Text('User Name'),
              accountEmail: Text('fg'),
              currentAccountPicture: CircleAvatar(
                child: Text(
                  'U',
                  style: TextStyle(fontSize: 24.0),
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.black54,
              ),
            ),
            // Expanded scrollable content
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                    leading: const Icon(Icons.home),
                    title: const Text('Home'),
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        _currentIndex = 0;
                      });
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.rate_review),
                    title: const Text('Reviews'),
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        _currentIndex = 1;
                      });
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.search),
                    title: const Text('Search'),
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        _currentIndex = 2;
                      });
                    },
                  ),
                  ListTile(
                      leading: const Icon(Icons.movie),
                      title: const Text('Watchlist'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/watchlist');
                      }),
                  ListTile(
                      leading: const Icon(Icons.movie_filter),
                      title: const Text('Watched'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/recent');
                      }),
                  ListTile(
                    leading: const Icon(Icons.movie_edit),
                    title: const Text('Lists'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/list');
                    },
                  ),
                  ListTile(
                      leading: const Icon(Icons.account_circle),
                      title: const Text('Profile'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/profile');
                      }),
                ],
              ),
            ),
            // Footer at bottom
            Container(
              color: Colors.black54,
              height: 50,
              alignment: Alignment.center,
              width: double.infinity,
              child: const Text(
                ':->LetterBoxd<-:',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.rate_review),
            label: 'Reviews',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
        ],
      ),
    );
  }
}
