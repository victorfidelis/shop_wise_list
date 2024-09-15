import 'package:flutter/material.dart';

class SearchComponent extends StatefulWidget {
  const SearchComponent({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.hintText,
  });

  final TextEditingController controller;
  final Function() onChanged;
  final String hintText;

  @override
  State<SearchComponent> createState() => _SearchComponentState();
}

class _SearchComponentState extends State<SearchComponent> {
  bool cleanIsVisible = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).colorScheme.shadow, blurRadius: 4, offset: Offset(0, 4))
          ]),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Icon(
              Icons.search,
              color: Color(0xff808080),
            ),
          ),
          Expanded(
            child: TextField(
              controller: widget.controller,
              onChanged: (value) {
                if (value.trim().isEmpty)
                  cleanIsVisible = false;
                else
                  cleanIsVisible = true;
                widget.onChanged();
                setState(() {});
              },
              style: TextStyle(fontSize: 14),
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
                hintText: widget.hintText,
              ),
            ),
          ),
          cleanIsVisible
              ? InkWell(
                  onTap: () {
                    widget.controller.text = '';
                    cleanIsVisible = false;
                    widget.onChanged();
                    setState(() {});
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                        color: Colors.red, borderRadius: BorderRadius.all(Radius.circular(12))),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Limpar',
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.clear,
                          color: Colors.white,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
