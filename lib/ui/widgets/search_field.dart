import 'package:cick_movie_app/ui/styles/color_scheme.dart';
import 'package:flutter/material.dart';

class SearchField extends StatefulWidget {
  final String query;
  final String hintText;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const SearchField({
    Key key,
    @required this.query,
    @required this.hintText,
    @required this.controller,
    @required this.onChanged,
  }) : super(key: key);

  @override
  _SearchFieldState createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      child: TextField(
        controller: widget.controller,
        autofocus: true,
        autocorrect: false,
        enableSuggestions: false,
        textInputAction: TextInputAction.done,
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(left: 16),
          hintText: widget.hintText,
          filled: true,
          fillColor: dividerColor,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(8),
          ),
          suffixIcon: widget.controller.text.isEmpty
              ? Container(width: 0)
              : IconButton(
                  onPressed: () {
                    widget.controller.clear();
                    widget.onChanged('');
                    // FocusScope.of(context).requestFocus(FocusNode());
                  },
                  icon: Icon(
                    Icons.close,
                    color: defaultTextColor,
                  ),
                ),
        ),
        onChanged: widget.onChanged,
        style: TextStyle(
          fontSize: 16,
          color: defaultTextColor,
        ),
      ),
    );
  }
}
