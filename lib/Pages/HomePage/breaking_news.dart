import 'package:flutter/material.dart';
import 'package:news_app_with_newsapi/Pages/HomePage/slider_section.dart';

class BreakingNews extends StatelessWidget {
  const BreakingNews({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(15),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Breaking News",
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
          ),
          SliderSection(),
        ],
      ),
    );
  }
}
