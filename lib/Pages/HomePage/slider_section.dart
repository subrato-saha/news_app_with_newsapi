import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news_app_with_newsapi/Models/headlines_model.dart';

final List<String> imgList = [];

class SliderSection extends StatefulWidget {
  const SliderSection({super.key});

  @override
  State<SliderSection> createState() => _SliderSectionState();
}

HeadlinesModel? headlinesModel;
bool isDataLoading = true;

class _SliderSectionState extends State<SliderSection> {
  int _current = 0;
  final CarouselController _controller = CarouselController();

  _getHeadLinesFromApi() async {
    var headLines = await http.get(Uri.parse(
        'https://newsapi.org/v2/top-headlines?country=us&pagesize=10&apiKey=6db74abef5124c0697f2b724cf4c959e'));
    var response = jsonDecode(headLines.body);

    setState(() {
      headlinesModel = HeadlinesModel.fromJson(response);
      for (var i = 0; i < headlinesModel!.articles!.length; i++) {
        imgList.add("${headlinesModel!.articles![i].urlToImage}");
      }
      isDataLoading = false;
    });
  }

  @override
  void initState() {
    _getHeadLinesFromApi();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isDataLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Container(
            height: 250,
            width: double.infinity,
            child: Column(children: [
              Expanded(
                child: CarouselSlider(
                  items: imageSliders,
                  carouselController: _controller,
                  options: CarouselOptions(
                      autoPlay: true,
                      autoPlayAnimationDuration: Duration(seconds: 2),
                      autoPlayInterval: Duration(seconds: 5),
                      enlargeCenterPage: true,
                      aspectRatio: 1.8,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _current = index;
                        });
                      }),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: imgList.asMap().entries.map((entry) {
                  return GestureDetector(
                    onTap: () => _controller.animateToPage(entry.key),
                    child: Container(
                      width: _current == entry.key ? 30 : 12,
                      height: 12,
                      margin:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: (Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Colors.black)
                              .withOpacity(_current == entry.key ? 0.9 : 0.4)),
                    ),
                  );
                }).toList(),
              ),
            ]),
          );
  }
}

final List<Widget> imageSliders = imgList
    .map((item) => Container(
          child: Container(
            // margin: EdgeInsets.all(5.0),
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                child: Stack(
                  children: <Widget>[
                    CachedNetworkImage(
                      imageUrl: item,
                      fit: BoxFit.cover,
                      width: 1000.0,
                      height: 500,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) => Center(
                              child: CircularProgressIndicator(
                                  value: downloadProgress.progress)),
                      errorWidget: (context, url, error) => Image.network(
                          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ065VmmNmIIHQKbtbZlGJN60fE9CeK5dQitptABkjh&s"),
                    ),
                    Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(200, 0, 0, 0),
                              Color.fromARGB(1, 0, 0, 0)
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  '${headlinesModel!.articles![imgList.indexOf(item)].source!.name}',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  Icons.verified,
                                  color: Colors.blue,
                                  size: 18,
                                )
                              ],
                            ),
                            Text(
                              // 'No. ${imgList.indexOf(item)} image',
                              '${headlinesModel!.articles![imgList.indexOf(item)].title}',
                              maxLines: 2,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
          ),
        ))
    .toList();
