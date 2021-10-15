import 'package:cick_movie_app/ui/styles/color_scheme.dart';
import 'package:flutter/material.dart';

class SearchField extends StatefulWidget {
  final String query;
  final String hintText;
  final ValueChanged<String> onChanged;

  const SearchField({
    Key key,
    @required this.query,
    @required this.hintText,
    @required this.onChanged,
  }) : super(key: key);

  @override
  _SearchFieldState createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final controller = TextEditingController();

  @override
  void initState() {
    controller.addListener(() => setState(() {}));

    super.initState();
  }

  @override
  void dispose() {
    controller.removeListener(() => setState(() {}));

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      child: TextField(
        controller: controller,
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
          suffixIcon: controller.text.isEmpty
              ? Container(width: 0)
              : IconButton(
                  onPressed: () {
                    controller.clear();
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
