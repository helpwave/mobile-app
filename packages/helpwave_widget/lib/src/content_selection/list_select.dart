import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:helpwave_widget/loading.dart';

class ListSelect<T> extends StatelessWidget {
  final FutureOr<List<T>> items;

  final void Function(T item) onSelect;

  final Widget Function(BuildContext context, T item, Function() select) builder;

  const ListSelect({
    super.key,
    required this.items,
    required this.onSelect,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return LoadingFutureBuilder(
      data: items,
      thenBuilder: (context, data) => Column(
        children: data.map((item) => builder(context, item, () => onSelect(item))).toList(),
      ),
    );
  }
}
