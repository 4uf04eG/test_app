import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:test_app/models/cat_fact.dart';
import 'package:test_app/pages/details_page.dart';
import 'package:test_app/services/data_fetcher_service.dart';
import 'package:test_app/services/storage_service.dart';
import 'package:test_app/widgets/error_screen.dart';
import 'package:test_app/widgets/loading_screen.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _controller = RefreshController(initialRefresh: true);

  Map<CatFact, bool> _allFactsWithStoredParam;
  bool _areFactsLoaded = false;

  @override
  Widget build(BuildContext context) {
    if (_allFactsWithStoredParam == null) {
      _allFactsWithStoredParam = Map();

      StorageService.getAllCatFacts()
          .then((f) => _addFacts(f, isStored: true))
          .catchError((err) => print(err.toString()));
    }

    return Scaffold(
        appBar: AppBar(title: Text("Facts about cats")),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SmartRefresher(
                controller: _controller,
                enablePullUp: _areFactsLoaded,
                enablePullDown: !_areFactsLoaded,
                onRefresh: _loadContent,
                onLoading: _loadContent,
                child: _buildFacts())));
  }

  Widget _buildFacts() {
    if (_allFactsWithStoredParam?.isEmpty ?? true) {
      return _areFactsLoaded
          ? ErrorScreen(onReload: () => _controller.requestLoading())
          : LoadingScreen();
    }

    return ListView(
        shrinkWrap: true,
        children: ListTile.divideTiles(
            context: context,
            tiles: _allFactsWithStoredParam.entries.map(
              (entry) => ListTile(
                title: Text(entry.key.text),
                trailing: entry.value
                    ? RaisedButton(
                        child: Text("Remove"),
                        color: Colors.red,
                        textColor: Colors.white,
                        onPressed: () {
                          StorageService.removeCatFact(entry.key);

                          setState(() {
                            _allFactsWithStoredParam[entry.key] = false;
                          });
                        })
                    : RaisedButton(
                        child: Text("Store"),
                        color: Colors.green,
                        textColor: Colors.white,
                        onPressed: () {
                          StorageService.saveCatFact(entry.key);

                          setState(() {
                            _allFactsWithStoredParam[entry.key] = true;
                          });
                        },
                      ),
                onTap: () => _openDetailsPage(entry.key),
              ),
            )).toList());
  }

  void _loadContent() {
    DataFetcher.requestFacts(5).then(_addFacts).then((_) {
      _controller.loadComplete();
      _areFactsLoaded = true;
    }).catchError(_handleError);
  }

  void _addFacts(List<CatFact> facts, {isStored = false}) {
    facts.forEach((fact) {
      _allFactsWithStoredParam[fact] = isStored;
    });
    setState(() {});
  }

  void _handleError(dynamic error) {
    _controller.loadFailed();
    setState(() {
      _areFactsLoaded = true;
    });
  }

  void _openDetailsPage(CatFact fact) {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => DetailsPage(fact: fact)));
  }
}
