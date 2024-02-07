import 'package:bookclub/utils/ourTheme.dart';
import 'package:flutter/material.dart';

class OurAllGroups extends StatefulWidget {
  const OurAllGroups({super.key});

  @override
  State<OurAllGroups> createState() => _OurAllGroupsState();
}

class _OurAllGroupsState extends State<OurAllGroups> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ourTheme().lightGreen,

    );
  }
}
