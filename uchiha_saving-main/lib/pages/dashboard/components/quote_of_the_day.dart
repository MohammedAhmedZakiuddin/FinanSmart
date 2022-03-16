import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uchiha_saving/api/article_fetcher.dart';
import 'package:uchiha_saving/models/person.dart';

class QuoteOfTheDay extends StatelessWidget {
  final Person person;
  const QuoteOfTheDay({Key? key, required this.person}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
        future: ArticleFetcher().fetchQuote(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Center(
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
            );
          }
          return SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Card(
                elevation: 15,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Quote of The Day',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.ptSansNarrow(
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1,
                            fontSize:
                                MediaQuery.of(context).size.height * 0.024,
                          ),
                        ),
                      ),
                      Text(
                        snapshot.data!['quote'],
                        textAlign: TextAlign.left,
                        style: GoogleFonts.lato(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w400,
                          fontSize: MediaQuery.of(context).size.height * 0.022,
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            "~ " + snapshot.data!['author'],
                            style: GoogleFonts.lato(
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w400,
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.022,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
