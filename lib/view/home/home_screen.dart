import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../models/categories_news_model.dart';
import '../../models/news_channel_headlines_model.dart';
import '../../view_model/news_view_model.dart';
import '../category/categories_screen.dart';
import 'home_detailed/article_detail_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

enum FilterList { bbcNews, aryNews, independent, reuters, cnn, alJazeera }

class _HomePageState extends State<HomePage> {
  final newsViewModelApi = NewsViewModel();
  final format = DateFormat("MMMM dd,yyyy");
  FilterList? selectedItem;
  String name = "bbc-news";

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black38,
      appBar: PreferredSize(
        preferredSize: const Size(0, 40),
        child: AppBar(
          backgroundColor: Colors.black12,
          leading: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const CategoriesScreen()),
              );
            },
            icon: Image.asset(
              'assets/images/category_icon.png',
              height: 30,
              width: 30,color: Colors.white70,
            ),
          ),
          title: Text(
            'News',
            style:
                GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w700,color: Colors.white70),
          ),
          actions: [

            SizedBox(
              width: MediaQuery.of(context).size.width*.15,
              child: PopupMenuButton<FilterList>(
                initialValue: selectedItem,
                onSelected: (FilterList item) {
                  if (FilterList.bbcNews == item) {
                    name = "bbc-news";
                  }
                  if (FilterList.aryNews.name == item.name) {
                    name = "ary-news";
                  }
                  if (FilterList.alJazeera.name == item.name) {
                    name = "al-jazeera-english";
                  }
                  if (FilterList.cnn.name == item.name) {
                    name = "cnn";
                  }
                  if (FilterList.independent.name == item.name) {
                    name = "independent";
                  }
                  if (FilterList.reuters.name == item.name) {
                    name = "reuters";
                  }
                  if (FilterList.reuters.name == item.name) {
                    name = "nbc-news";
                  }

                  setState(() {
                    selectedItem = item;
                  });
                },
                itemBuilder: (context) => <PopupMenuEntry<FilterList>>[
                  const PopupMenuItem<FilterList>(
                    value: FilterList.bbcNews,
                    child: SizedBox(
                      width: 150,
                        child: Text("BBC News",style: TextStyle(color: Colors.white),)),
                  ),
                   const PopupMenuItem<FilterList>(
                      value: FilterList.aryNews, child: Text("ARY News",style: TextStyle(color: Colors.white),)),
                   const PopupMenuItem<FilterList>(
                      value: FilterList.alJazeera, child: Text("Al-Jazeera",style: TextStyle(color: Colors.white),)),
                   const PopupMenuItem<FilterList>(
                      value: FilterList.cnn, child: Text("CNN",style: TextStyle(color: Colors.white),)),
                   const PopupMenuItem<FilterList>(
                      value: FilterList.independent, child: Text("Independent",style: TextStyle(color: Colors.white),)),
                  const PopupMenuItem<FilterList>(
                      value: FilterList.reuters, child: Text("reuters",style: TextStyle(color: Colors.white),)),
                  // Add other PopupMenuItems
                ],
                icon: const Icon(Icons.menu, color: Colors.white70,size: 30,), // Change the dropdown arrow color

                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // const Divider(
          //   thickness: .3,
          //   color: Colors.white,
          // ),
          SizedBox(
            height: height * 0.3,
            child: FutureBuilder<NewsChannelHeadlinesModel>(
                future:
                    newsViewModelApi.fetchNewChannelHeadLinesApi(context, name),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SpinKitCircle(
                      color: Colors.white,
                    );
                  } else {
                    return ListView.builder(
                        itemCount: snapshot.data!.articles!.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          DateTime dateTime = DateTime.parse(snapshot
                              .data!.articles![index].publishedAt
                              .toString());
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ArticleDetailsScreen(
                                            id: snapshot.data!.articles![index]
                                                .source!.id,
                                            newsName: snapshot.data!
                                                .articles![index].source!.name,
                                            title: snapshot
                                                .data!.articles![index].title,
                                            publishedAt:
                                                format.format(dateTime),
                                            urlToImage: snapshot.data!
                                                .articles![index].urlToImage,
                                            author: snapshot
                                                .data!.articles![index].author,
                                            content: snapshot
                                                .data!.articles![index].content,
                                            description: snapshot.data!
                                                .articles![index].description,
                                          )));
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    height: height * 0.4,
                                    width: width * .9,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: height * .01,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: CachedNetworkImage(
                                        imageUrl: snapshot
                                            .data!.articles![index].urlToImage
                                            .toString(),
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            Container(
                                          child: spinKit2,
                                        ),
                                        errorWidget: (context, url, error) =>
                                            const Icon(
                                          Icons.error_outline,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 3,
                                    child: Card(
                                      elevation: 5,
                                      color: Colors.black.withOpacity(0.4),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Container(
                                        padding: const EdgeInsets.all(20),
                                        alignment: Alignment.center,
                                        height: height * 0.20,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: width * 0.7,
                                              child: Text(
                                                snapshot.data!.articles![index]
                                                    .title
                                                    .toString(),
                                                maxLines: 3,
                                                style: GoogleFonts.aBeeZee(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                    color: Colors.white),
                                              ),
                                            ),
                                            const Spacer(),
                                            SizedBox(
                                              width: width * 0.7,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Flexible(
                                                    child: Text(
                                                      snapshot
                                                          .data!
                                                          .articles![index]
                                                          .source!
                                                          .name
                                                          .toString(),
                                                      style:
                                                          GoogleFonts.aBeeZee(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.red),
                                                    ),
                                                  ),
                                                  Text(
                                                    format.format(dateTime),
                                                    style: const TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                  }
                }),
          ),
          SizedBox(height: height * 0.01),
          const Divider(
            thickness: .3,
            color: Colors.white,
          ),
          Expanded(
            child: SizedBox(
              height: height * 0.5,
              child: FutureBuilder<CategoriesNewsModel>(
                future: newsViewModelApi.fetchCategoriesNewsApi(context, "General"),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SpinKitCircle(
                      color: Colors.white,
                    );
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.articles!.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        DateTime dateTime = DateTime.parse(
                          snapshot.data!.articles![index].publishedAt.toString(),
                        );
                        return Column(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ArticleDetailsScreen(
                                      id: snapshot.data!.articles![index].source!.id,
                                      newsName:
                                      snapshot.data!.articles![index].source!.name,
                                      title: snapshot.data!.articles![index].title,
                                      publishedAt: format.format(dateTime),
                                      urlToImage:
                                      snapshot.data!.articles![index].urlToImage,
                                      author: snapshot.data!.articles![index].author,
                                      content: snapshot.data!.articles![index].content,
                                      description:
                                      snapshot.data!.articles![index].description,
                                    ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 5,
                                  horizontal: 10,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: CachedNetworkImage(
                                        imageUrl: snapshot
                                            .data!.articles![index].urlToImage
                                            .toString(),
                                        fit: BoxFit.cover,
                                        height: height * 0.15,
                                        width: width * 0.25,
                                        placeholder: (context, url) => Container(
                                          child: spinKit2,
                                        ),
                                        errorWidget: (context, url, error) => const Icon(
                                          Icons.error_outline,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                        child: SizedBox(
                                          height: height * 0.15,
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                child: Center(
                                                  child: Text(
                                                    snapshot.data!
                                                        .articles![index].title
                                                        .toString(),
                                                    style: GoogleFonts.aBeeZee(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    snapshot.data!.articles![index].source!
                                                        .name
                                                        .toString(),
                                                    style:  TextStyle(
                                                      color: Colors.red.shade800,
                                                    ),
                                                  ),
                                                  Flexible(
                                                    child: Text(
                                                      format.format(dateTime),
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Divider(
                              color: Colors.white,
                              thickness: .3,
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),


        ],
      ),
    );
  }
}

const spinKit2 = SpinKitFadingCircle(
  color: Colors.amber,
  size: 40,
);
