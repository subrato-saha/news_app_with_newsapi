import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:news_app_with_newsapi/Models/headlines_model.dart';
import 'package:news_app_with_newsapi/Pages/HomePage/news_card.dart';
import 'package:http/http.dart' as http;

class Recommendation extends StatefulWidget {
  const Recommendation({super.key});

  @override
  State<Recommendation> createState() => _RecommendationState();
}

HeadlinesModel? recomendationModel;
bool isLoading = true;

class _RecommendationState extends State<Recommendation> {
  _getRecomendation() async {
    var recomendation = await http.get(Uri.parse(
        "https://newsapi.org/v2/everything?q=us&pagesize=20&apiKey=6db74abef5124c0697f2b724cf4c959e"));
    var result = jsonDecode(recomendation.body);
    setState(() {
      recomendationModel = HeadlinesModel.fromJson(result);
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _getRecomendation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              "Recommendation",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
            ),
            MaterialButton(
              onPressed: () {},
              child: Text(
                "View all",
                style: TextStyle(color: Colors.blue),
              ),
            )
          ]),
          isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: ((context, index) => NewsCard(
                        recomendationModel: recomendationModel,
                        index: index,
                      )),
                  separatorBuilder: ((context, index) => SizedBox(
                        height: 10,
                      )),
                  itemCount: recomendationModel!.articles!.length)
        ],
      ),
    );
  }
}
