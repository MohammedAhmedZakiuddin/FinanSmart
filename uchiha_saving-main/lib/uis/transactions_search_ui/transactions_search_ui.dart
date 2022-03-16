import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:uchiha_saving/models/person.dart';
import 'package:uchiha_saving/models/transaction.dart';
import 'package:uchiha_saving/pages/transaction_page/transaction_builder.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as fr;

class TransactionSearchUI extends StatefulWidget {
  final Person person;
  const TransactionSearchUI({Key? key, required this.person}) : super(key: key);

  @override
  _TransactionSearchUIState createState() => _TransactionSearchUIState();
}

class _TransactionSearchUIState extends State<TransactionSearchUI> {
  TextEditingController _textEditingController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        body: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              pinned: true,
              title: Text("Transactions"),
              foregroundColor:
                  ThemeProvider.controllerOf(context).currentThemeId == "dark"
                      ? Colors.white
                      : Colors.black,
            ),
            SliverStickyHeader(
              sticky: true,
              header: Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  controller: _textEditingController,
                  decoration: InputDecoration(
                    labelText: "Search Transactions",
                    hintText: "Eg. Grocery",
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      onPressed: () {
                        _textEditingController.clear();
                        setState(() {});
                      },
                      icon: Icon(Icons.cancel),
                    ),
                  ),
                  onChanged: (val) {
                    setState(() {});
                  },
                ),
              ),
              sliver: StreamBuilder<fr.QuerySnapshot>(
                  stream: fr.FirebaseFirestore.instance
                      .collection("Transactions")
                      .doc(widget.person.id)
                      .collection("Transactions")
                      .orderBy("title")
                      .startAt([_textEditingController.text]).endAt(
                          [_textEditingController.text + '\uf8ff']).snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return SliverToBoxAdapter(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    List<Transaction> _list = snapshot.data!.docs
                        .map((e) => Transaction.fromDynamic(e))
                        .toList();
                    if (_list.isEmpty) {
                      return SliverToBoxAdapter(
                          child: Center(
                        child: Column(
                          children: [
                            SizedBox(height: _size.height * 0.2),
                            Text(
                              "Cannot find any transactions\n😐😐😐",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.lato(
                                fontSize: _size.height * 0.023,
                              ),
                            ),
                          ],
                        ),
                      ));
                    }
                    return TransactionBuilder(
                      person: widget.person,
                      transactionList: _list,
                      transactionIdList:
                          snapshot.data!.docs.map((e) => e.id).toList(),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
