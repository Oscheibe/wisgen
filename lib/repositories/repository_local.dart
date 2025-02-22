import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wisgen/models/wisdom.dart';
import 'package:wisgen/repositories/repository.dart';

///Repository that cashes a list of Wisdom form a local file in memory
///and then Provides a given amount of random entries.
class LocalRepository implements Repository<Wisdom> {
  static const _path = './assets/advice.txt';
  List<Wisdom> _cash;
  final Random _random = new Random();

  @override
  Future<List<Wisdom>> fetch(int amount, BuildContext context) async {
    //if the cash is empty, load the local text file into it.
    if (_cash == null) _cash = await _loadFile(context);

    List<Wisdom> res = new List();
    for (int i = 0; i < amount; i++) {
      res.add(_cash[_random.nextInt(_cash.length)]);
    }
    return res;
  }

  ///Reads out Local File and converts entries to Wisdoms
  Future<List<Wisdom>> _loadFile(BuildContext context) async {
    String localAdvice = await DefaultAssetBundle.of(context).loadString(_path);
    List<String> strings = localAdvice.split('\n');
    List<Wisdom> wisdoms = new List();

    String currentType;
    int relativeIndex;

    for (int i = 0; i < strings.length; i++) {
      if (strings[i].startsWith('#')) {
        //new type of wisdom
        strings[i] = strings[i].substring(2);
        currentType = strings[i];
        relativeIndex = 1;
        continue; //do not add type header
      }
      wisdoms.add(
          new Wisdom(id: relativeIndex, text: strings[i], type: currentType));
      relativeIndex++;
    }
    return wisdoms;
  }
}
