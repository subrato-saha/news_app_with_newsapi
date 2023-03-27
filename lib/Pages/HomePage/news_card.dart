import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_app_with_newsapi/Models/headlines_model.dart';
import 'package:jiffy/jiffy.dart';

class NewsCard extends StatelessWidget {
  HeadlinesModel? recomendationModel;
  int index;
  NewsCard({super.key, required this.recomendationModel, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.red,
      height: 150,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: "${recomendationModel!.articles![index].urlToImage}",
              height: 200,
              width: 150,
              fit: BoxFit.cover,
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  Center(
                      child: CircularProgressIndicator(
                          value: downloadProgress.progress)),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
          Flexible(
            child: Container(
              padding: EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${recomendationModel!.articles![index].title}",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    maxLines: 2,
                  ),
                  Text(
                    "Source : ${recomendationModel!.articles![index].source!.name}",
                    style: TextStyle(fontWeight: FontWeight.w300),
                  ),
                  Text(
                      "${Jiffy(recomendationModel!.articles![index].publishedAt).format('MMM dd, yyyy')}")
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
