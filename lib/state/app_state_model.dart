import 'package:flutter/material.dart';

import '../models/ModelProvider.dart';

class AppStateModel extends ChangeNotifier {
  // Internal, private state
  bool _datastoreReady = false;
  bool _feedLoaded = false;
  List<Post?> _loadedPosts = [];

  // Unmodifiable view of the state;
  get datastoreReady => _datastoreReady;
  get feedLoaded => _feedLoaded;
  get getLoadedPosts => _loadedPosts;

  void setDatastoreReady(bool state) {
    _datastoreReady = state;
  }

  void setFeedLoaded(bool state) {
    _feedLoaded = state;
    notifyListeners();
  }

  void setLoadedPosts(List<Post?> posts) {
    _loadedPosts = posts;
    notifyListeners();
  }
}
