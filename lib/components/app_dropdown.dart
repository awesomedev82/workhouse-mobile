import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:workhouse/utils/constant.dart';

class AppDropdown extends StatefulWidget {
  const AppDropdown({
    Key? key,
    required this.items,
    this.initialValue,
    required this.onItemSelected,
  }) : super(key: key);
  final List<String> items;
  final String? initialValue;
  final Function(String?) onItemSelected;
  @override
  _AppDropdownState createState() => _AppDropdownState();
}

class _AppDropdownState extends State<AppDropdown> {
  String? _selectedItem;

  @override
  void initState() {
    super.initState();
    _selectedItem = widget.initialValue;
  }

  void _showBottomSheet(BuildContext context) {
    String _tempSelectedItem = _selectedItem ?? "";
    showModalBottomSheet(
      context: context,
      scrollControlDisabledMaxHeightRatio: 0.8,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0), // TL: Top Left
                  topRight: Radius.circular(30.0), // TR: Top Right
                ),
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    height: 70,
                    padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Color(0xFFF2F2F2),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    width: 140,
                                    height: 4,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFF2F2F2).withOpacity(1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          right: 0,
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedItem = _tempSelectedItem;
                                    widget.onItemSelected(_selectedItem);
                                    print(_selectedItem);
                                  });
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "Done",
                                  style: GoogleFonts.inter(
                                    textStyle: TextStyle(
                                      fontSize: 14,
                                      height: 1.6,
                                      fontWeight: FontWeight.w300,
                                      color: Color(0xFF17181A),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ...widget.items.map(
                            (option) {
                              bool isSelected = _tempSelectedItem == option;
                              return option != ''
                                  ? GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _tempSelectedItem = option;
                                          print(_tempSelectedItem);
                                        });
                                      },
                                      child: Container(
                                        height: 70,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 24),
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? Color(0xFFDEE0E3)
                                                  .withOpacity(0.39)
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border(
                                            bottom: BorderSide(
                                              color: Color(0xFFDEE0E3),
                                              width: 1,
                                            ),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(option),
                                            //  SizedBox(width: 16),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Icon(
                                                Icons.check_circle,
                                                color: isSelected
                                                    ? Color(0xFF014E53)
                                                    : Colors.grey
                                                        .withOpacity(0),
                                                size: 35,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : Container();
                            },
                          ).toList(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      _tempSelectedItem = _selectedItem ?? "sectect";
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showBottomSheet(context),
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        decoration: BoxDecoration(
          border:
              Border.all(color: Color.fromARGB(255, 114, 113, 113), width: 1),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _selectedItem ?? 'Select an item',
              style: TextStyle(
                color: _selectedItem == null ? Colors.grey : Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w300,
              ),
            ),
            Icon(
              Ionicons.chevron_down_outline,
              color: Color(0xFF7D7E83),
              size: 12,
            ),
          ],
        ),
      ),
    );
  }
}
