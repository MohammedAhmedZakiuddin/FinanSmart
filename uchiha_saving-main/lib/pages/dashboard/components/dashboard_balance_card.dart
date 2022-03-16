import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uchiha_saving/models/person.dart';
import 'package:uchiha_saving/pages/dashboard/components/select_category_add_balance.dart';
import 'package:uchiha_saving/tools/custom_navigator.dart';
import 'package:uchiha_saving/tools/get_random_color.dart';
import 'package:uchiha_saving/tools/greeting.dart';

class DashboardBalanceCard extends StatelessWidget {
  final Person person;
  const DashboardBalanceCard({Key? key, required this.person})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 15,
          // color: getRandomColor(context),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greeting(DateTime.now()),
                  style: GoogleFonts.lato(
                    fontSize: _size.height * 0.03,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 25),
                Container(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Text(
                        "\$${person.balance.toStringAsFixed(2)}",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lato(
                          fontSize: _size.height * 0.04,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        "Available Balance",
                        style: GoogleFonts.lato(
                          fontSize: _size.height * 0.027,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      SizedBox(height: 20),
                      IconButton(
                        onPressed: () {
                          customNavigator(
                              context,
                              SelectCategoryAddBalanceUI(
                                  person: person, key: key));
                        },
                        icon: Icon(FontAwesome5.plus_square),
                        iconSize: _size.height * 0.05,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
