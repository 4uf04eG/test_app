import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:test_app/models/cat_fact.dart';
import 'package:test_app/services/data_fetcher_service.dart';
import 'package:test_app/widgets/error_screen.dart';
import 'package:test_app/widgets/loading_screen.dart';

class DetailsPage extends StatefulWidget {
  final CatFact fact;

  const DetailsPage({Key key, this.fact}) : super(key: key);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Details")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: Container(
                height: MediaQuery.of(context).size.height / 2,
                child: FutureBuilder(
                  future: DataFetcher.requestCatImageLink(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return ErrorScreen(
                        onReload: () {
                          setState(() {});
                        },
                      );
                    }

                    if (snapshot.hasData) {
                      return _buildImage(snapshot.data);
                    } else {
                      return Card(child: LoadingScreen());
                    }
                  },
                ),
              ),
            ),
            Text(
              widget.fact.text,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildImage(String url) {
    return CachedNetworkImage(
        imageUrl: url,
        errorWidget: (context, _, __) {
          return ErrorScreen(
            onReload: () {
              setState(() {});
            },
          );
        },
        imageBuilder: (context, builder) {
          return Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  image: DecorationImage(
                      image: builder,
                      fit: BoxFit.cover
                  ),
              )
          );
        },
        placeholder: (_, __) => Card(child: LoadingScreen()));
  }
}
