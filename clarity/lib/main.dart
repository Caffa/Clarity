import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './tabs/home.dart' as _firstTab;
import './tabs/dashboard.dart' as _secondTab;
import './tabs/favourites.dart' as _thirdTab;
import './screens/profile.dart' as _profilePage;
import './screens/about.dart' as _aboutPage;
import './screens/support.dart' as _supportPage;
import './screens/feedback.dart' as _feedbackPage;
import 'results.dart';

final TextEditingController searchQuery = new TextEditingController();

void main() => runApp(new MaterialApp(
      title: 'Clarity',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
          primarySwatch: Colors.indigo,
          scaffoldBackgroundColor: Colors.white,
          primaryColor: Colors.indigo,
          backgroundColor: Colors.white),
      home: new Tabs(),
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/profile':
            return new FromRightToLeft(
              builder: (_) => new _profilePage.Profile(),
              settings: settings,
            );
          case '/about':
            return new FromRightToLeft(
              builder: (_) => new _aboutPage.About(),
              settings: settings,
            );
          case '/support':
            return new FromRightToLeft(
              builder: (_) => new _supportPage.Support(),
              settings: settings,
            );
          case '/feedback':
            return new FromRightToLeft(
              builder: (_) => new _feedbackPage.Feedback(),
              settings: settings,
            );
        }
      },
    ));

class FromRightToLeft<T> extends MaterialPageRoute<T> {
  FromRightToLeft({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (settings.isInitialRoute) return child;

    return new SlideTransition(
      child: new Container(
        decoration: new BoxDecoration(boxShadow: [
          new BoxShadow(
            color: Colors.black26,
            blurRadius: 25.0,
          )
        ]),
        child: child,
      ),
      position: new Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(new CurvedAnimation(
        parent: animation,
        curve: Curves.fastOutSlowIn,
      )),
    );
  }

  @override
  Duration get transitionDuration => const Duration(milliseconds: 400);
}

class Tabs extends StatefulWidget {
  @override
  TabsState createState() => new TabsState();
}

class TabsState extends State<Tabs> {
  bool searchOver = true;
  bool isSearching = false;

  PageController _tabController;
  var _title_app = null;
  int _tab = 0;

  @override
  void initState() {
    super.initState();
    _tabController = new PageController();
    this._title_app = TabItems[0].title;
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  TabsState() {
    searchQuery.addListener(() {
      if (searchQuery.text.isEmpty) {
        setState(() {
          isSearching = false;
        });
      } else {
        setState(() {
          isSearching = true;
        });
      }
    });
  }

  Widget buildBar() {
    return new AppBar(
      title: new Text(
        _title_app,
        style: new TextStyle(
          fontSize:
              Theme.of(context).platform == TargetPlatform.iOS ? 17.0 : 20.0,
        ),
      ),
      elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
      backgroundColor: Colors.indigo,
      actions: <Widget>[
        new IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              setState(() {
                searchOver = false;
              });
            }),
      ],
    );
  }

  Widget buildSearchBar(BuildContext context) {
    return new AppBar(
        centerTitle: true,
        title:
            new Stack(alignment: const Alignment(1.0, 1.0), children: <Widget>[
          new TextField(
            controller: searchQuery,
            style: new TextStyle(
              color: Colors.white,
            ),
            decoration: new InputDecoration(
                hintText: "Type to search",
                hintStyle: new TextStyle(color: Colors.white)),
          ),
          new IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                _handleSearchEnd();
              })
        ]),
        backgroundColor: Colors.indigo,
        actions: <Widget>[
          new IconButton(
              icon: new Icon(
                Icons.send,
                color: Colors.white,
              ),
              onPressed: () {
                _handleSearchSend(searchQuery.text);
              })
        ]);
  }

  void _handleSearchEnd() {
    setState(() {
      searchQuery.clear();
    });
  }

  void _handleSearchSend(String query) {
    if (query == null || query == '') {
      print('search cannot be empty');
      return;
    }
    setState(() {
      searchOver = true;
    });
    _handleSearchEnd();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ResultsPage(query: query)),
    );
  }

  Widget buildHomePage() {
    return new PageView(
      controller: _tabController,
      onPageChanged: onTabChanged,
      children: <Widget>[
        new _firstTab.Home(),
        new _secondTab.Dashboard(),
        new _thirdTab.Favourites()
      ],
    );
  }

  Widget buildSearchList(BuildContext context) {
    return new StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection("Products").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return new Container();
          return new ListView(children: getSearchItems(snapshot));
        });
  }

  getSearchItems(AsyncSnapshot<QuerySnapshot> snapshot) {
    List<DocumentSnapshot> docs = snapshot.data.documents;
    List<String> names = List();
    List<ChildItem> searchList = List();
    for (var d in docs) {
      names.add(Product.fromSnapshot(d).name);
      if (!names.contains(Product.fromSnapshot(d).brand)) {
        names.add(Product.fromSnapshot(d).brand);
      }
    }
    for (int i = 0; i < names.length; i++) {
      String item = names.elementAt(i);
      if (item.toLowerCase().contains(searchQuery.text.toLowerCase())) {
        searchList.add(ChildItem(this, item));
      }
    }
    return searchList;
  }

  @override
  Widget build(BuildContext context) => new Scaffold(
      //App Bar
      appBar: searchOver ? buildBar() : buildSearchBar(context),
      body: new Container(
        child: isSearching ? buildSearchList(context) : buildHomePage(),
      ),

      //Tabs
      bottomNavigationBar: Theme.of(context).platform == TargetPlatform.iOS
          ? new CupertinoTabBar(
              activeColor: Colors.indigo,
              currentIndex: _tab,
              onTap: onTap,
              items: TabItems.map((TabItem) {
                return new BottomNavigationBarItem(
                  title: new Text(TabItem.title),
                  icon: new Icon(TabItem.icon),
                );
              }).toList(),
            )
          : new BottomNavigationBar(
              currentIndex: _tab,
              onTap: onTap,
              items: TabItems.map((TabItem) {
                return new BottomNavigationBarItem(
                  title: new Text(TabItem.title),
                  icon: new Icon(TabItem.icon),
                );
              }).toList(),
            ),

      //Drawer
      drawer: new Drawer(
          child: new ListView(
        children: <Widget>[
          new Container(
            height: 120.0,
            child: new DrawerHeader(
              padding: new EdgeInsets.all(0.0),
              decoration: new BoxDecoration(
                color: new Color(0xFFECEFF1),
              ),
              child: new Center(
                child: new FlutterLogo(
                  colors: Colors.indigo,
                  size: 54.0,
                ),
              ),
            ),
          ),
          new ListTile(
              leading: new Icon(Icons.face),
              title: new Text('Profile'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).pushNamed('/profile');
              }),
          new ListTile(
              leading: new Icon(Icons.info),
              title: new Text('About'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).pushNamed('/about');
              }),
          new ListTile(
              leading: new Icon(Icons.chat),
              title: new Text('Support'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).pushNamed('/support');
              }),
          new Divider(),
          new ListTile(
              leading: new Icon(Icons.feedback),
              title: new Text('Feedback'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).pushNamed('/feedback');
              }),
        ],
      )));

  void onTap(int tab) {
    _tabController.jumpToPage(tab);
  }

  void onTabChanged(int tab) {
    setState(() {
      this._tab = tab;
    });

    switch (tab) {
      case 0:
        this._title_app = TabItems[0].title;
        break;

      case 1:
        this._title_app = TabItems[1].title;
        break;

      case 2:
        this._title_app = TabItems[2].title;
        break;
    }
  }
}

class TabItem {
  const TabItem({this.title, this.icon});

  final String title;
  final IconData icon;
}

const List<TabItem> TabItems = const <TabItem>[
  const TabItem(title: 'Home', icon: Icons.home),
  const TabItem(title: 'Dashboard', icon: Icons.dashboard),
  const TabItem(title: 'Favourites', icon: Icons.favorite)
];

class ChildItem extends StatelessWidget {
  final TabsState state;
  final String name;

  ChildItem(this.state, this.name);

  @override
  Widget build(BuildContext context) {
    return new ListTile(
        title: new Text(this.name,
            style: new TextStyle(
              color: Colors.indigo,
            )),
        onTap: () {
          searchQuery.clear();
          state._handleSearchSend(this.name);
        });
  }
}

class Product {
  final String brand;
  final String name;
  final String price;
  final String loves;
  final List<dynamic> images;
  final List<dynamic> details;

  final DocumentReference reference;

  Product.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['brand'] != null),
        assert(map['name'] != null),
        //assert(map['price'] != null),
        assert(map['loves'] != null),
        //assert(map['image'] != null),
        assert(map['details'] != null),
        brand = map['brand'],
        name = map['name'],
        price = map['price'],
        loves = map['loves'],
        images = map['images'],
        details = map['details'];

  Product.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Product<$brand:$name:$price:$loves$images:$details>";
}
