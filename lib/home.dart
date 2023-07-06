import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:quotes/favorites.dart';
import 'package:quotes/models/objectbox.dart';
import './models/quotes_model.dart';
import './pocketbase/quotes.dart';
import 'package:google_fonts/google_fonts.dart';
import './models/fav_quotes.dart';
import 'package:objectbox/objectbox.dart';
import './models/objectbox.dart';
import 'navbar.dart';
import 'package:like_button/like_button.dart';

import 'objectbox.g.dart';

class HomePage extends StatefulWidget {
  final String token;

  const HomePage({Key? key, required this.token}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PageController _pageController;
  int _currentIndex = 0;
  List<bool> isLikedList = [];
  

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
    fetchLikedQuotes();
  }

  Future<void> fetchLikedQuotes() async {
    final objectBox = ObjectBox();
    await objectBox.openDBStore();

    try {
      final likedQuotes = objectBox.store.box<FavoriteQuotes>().getAll();
      final quotesList = await fetchQuotes(widget.token);

      
      isLikedList = quotesList
          .map((quote) =>
              likedQuotes.any((likedQuote) => likedQuote.quote == quote.quote))
          .toList();
    } catch (error) {
      print('Error fetching liked quotes from ObjectBox: $error');
    }

    await objectBox.closeDBStore();
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
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();

    int currentIndex = _currentIndex;
    String token = widget.token;
    return Scaffold(
      bottomNavigationBar: BottomNavigationBarWidget(
        currentIndex: currentIndex,
        onTap: (int index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FavoritePage(
                  token: token,
                  currentIndex: index,
                ),
              ),
            ).then((value) {
              setState(() {
                currentIndex = 1;
              });
            });
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
                'Quotes',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 250, 250, 249),
                ),
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => Future.delayed(const Duration(seconds: 1)),
                child: FutureBuilder<List<Quotes>>(
                  future: fetchQuotes(token),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasError) {
                      return const Center(child: Text('Error occurred'));
                    }
                    final quotesList = snapshot.data;
                    if (quotesList == null || quotesList.isEmpty) {
                      return const Center(child: Text('No quotes found'));
                    }

                    return PageView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: quotesList.length,
                      itemBuilder: (context, index) {
                        final quote = quotesList[index];

                        while (isLikedList.length <= index) {
                          isLikedList.add(false);
                        }
                        final isLiked = isLikedList[index];
                        return Container(
                          padding: const EdgeInsets.all(16.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: Stack(
                              children: [
                                Card(
                                  elevation: 100,
                                  color: Colors.transparent,
                                  child: Container(
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '"${quote.quote}"',
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
                                ),
                                Positioned(
                                  bottom: 16.0,
                                  left: 300.0,
                                  child: LikeButton(
                                    size: 35,
                                    isLiked: isLiked,
                                    // isLiked: isLikedList[index],
                                    onTap: (isLiked) async {
                                      await onLikeButtonTapped(
                                          isLiked, quote, index);
                                      // setState(() {
                                      //   isLikedList[index] = !isLiked;
                                      // });
                                    },
                                    likeBuilder: (bool isLiked) {
                                      return Icon(
                                        Icons.favorite,
                                        color: isLiked
                                            ? const Color.fromARGB(
                                                255, 207, 46, 6)
                                            : const Color.fromARGB(
                                                255, 247, 244, 244),
                                        size: 35,
                                      );
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool?> onLikeButtonTapped(
      bool isLiked, Quotes quote, int index) async {
    final objectBox = ObjectBox();
    await objectBox.openDBStore();

    try {
      final query = objectBox.store
          .box<FavoriteQuotes>()
          .query(FavoriteQuotes_.quote.equals(quote.quote))
          .build();
      final List<FavoriteQuotes> existingQuotes = query.find();

      if (isLiked) {
       
        if (existingQuotes.isNotEmpty) {
          objectBox.store.box<FavoriteQuotes>().remove(existingQuotes[0].id);
        }
      } else {
        
        if (existingQuotes.isEmpty) {
          final favQuote = FavoriteQuotes(quote: quote.quote);
          objectBox.store.box<FavoriteQuotes>().put(favQuote);
          print(favQuote.quote);
        }
      }

      setState(() {
        isLikedList[index] = !isLiked;
      });
    } catch (error) {
      print('Error adding/removing quote to ObjectBox: $error');
    }

    await objectBox.closeDBStore();
   
  }
}
