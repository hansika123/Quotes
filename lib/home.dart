import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import './models/quotes_model.dart';
import './pocketbase/quotes.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatelessWidget {
  final String token;
  const HomePage({Key? key, required this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    return Scaffold(
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
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 250, 250, 249)),
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
                        return Container(
                          padding: const EdgeInsets.all(16.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: Card(
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
                                      horizontal: 16.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '"${quote.quote}"',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.capriola(
                                            fontSize: 18.0,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 20.0),
                                      // Add additional widgets as needed
                                    ],
                                  ),
                                ),
                              ),
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
}
