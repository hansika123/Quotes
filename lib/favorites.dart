import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quotes/models/fav_quotes.dart';
import './models/quotes_model.dart';
import './models/objectbox.dart';
import './models/fav_quotes.dart';
import 'home.dart';
import 'navbar.dart';

class FavoritePage extends StatefulWidget {
  final String token;
  final int currentIndex;

  const FavoritePage(
      {Key? key, required this.token, required this.currentIndex})
      : super(key: key);

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  late PageController _pageController;
  int _currentIndex = 1;

  List<FavoriteQuotes> favoriteQuotes = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
    fetchFavoriteQuotes();
  }


  Future<void> fetchFavoriteQuotes() async {
    final objectBox = ObjectBox();
    await objectBox.openDBStore();

    try {
     
      favoriteQuotes = objectBox.store.box<FavoriteQuotes>().getAll();
    } catch (error) {
      print('Error fetching favorite quotes from ObjectBox: $error');
    }

    await objectBox.closeDBStore();
    
    setState(() {});
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void navigateToPage(int index) {
    setState(() {
      _currentIndex = index;
      _pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    int currentIndex = 1;
    String token = widget.token;
    return Scaffold(
      bottomNavigationBar: BottomNavigationBarWidget(
        currentIndex: currentIndex,
        onTap: (int index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage(token: token)),
            );
          } else {
            navigateToPage(index);
          }
        },
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/card2.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 50),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Favorites',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 250, 250, 249),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                scrollDirection: Axis.vertical,
                controller: _pageController,
                itemCount: favoriteQuotes.length,
                itemBuilder: (context, index) {
                  final favquote = favoriteQuotes[index];
                  return Container(
                    padding: const EdgeInsets.all(16.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Card(
                        elevation: 100,
                        color: Colors.transparent,
                        child: Stack(
                        
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('assets/card2.jpg'),
                                  fit: BoxFit.fill,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '"${favquote.quote}"',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.capriola(
                                        fontSize: 18.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 20.0),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              
                              bottom: 10.0,
                              right: 10.0,
                              child: IconButton(
                                icon: Icon(
                                  favquote.isLiked
                                      ? Icons.favorite
                                      : Icons.favorite,
                                ),
                                color: favquote.isLiked
                                    ? Colors.white
                                    : Colors.red,
                                onPressed: () async {
                                  setState(() {
                                   
                                    favquote.isLiked = !favquote.isLiked;
                                  });
                                  final objectBox = ObjectBox();
                                  await objectBox.openDBStore();
                                  try {
                                   
                                    if (favquote.isLiked) {
                                      objectBox.store
                                          .box<FavoriteQuotes>()
                                          .remove(favquote.id);
                                      favoriteQuotes.removeWhere(
                                          (quote) => quote.id == favquote.id);
                                    } else {
                                      
                                      objectBox.store
                                          .box<FavoriteQuotes>()
                                          .put(favquote);
                                    }
                                  } catch (error) {
                                    print(
                                        'Error updating liked quotes in ObjectBox: $error');
                                  }

                                  await objectBox.closeDBStore();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
