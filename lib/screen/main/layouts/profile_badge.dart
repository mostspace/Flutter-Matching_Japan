import 'package:flutter/material.dart';
import 'package:matching_app/common.dart';
import 'package:matching_app/utile/index.dart';

class ProfileBadgeWidget extends StatelessWidget {
  const ProfileBadgeWidget({super.key, required this.badges});

  final List<BadgeItemObject> badges;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(
            // left: vww(context, 6),
            // right: vww(context, 6),
            bottom: vhh(context, 3)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text("紹介バッジ",
                    style: TextStyle(fontSize: 16, color: PRIMARY_FONT_COLOR))),
            Wrap(
                spacing: 8,
                runSpacing: -8,
                children: badges.map((BadgeItemObject e) {
                  String textColor = e.color;
                  return FilterChip(
                    label: Text(e.title,
                        style: TextStyle(
                            fontSize: 13,
                            color: e.isChecked
                                ? Colors.white
                                : Color(int.parse(textColor.substring(1, 7),
                                        radix: 16) +
                                    0xFF000000))),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      side: BorderSide(
                          color: Color(int.parse(textColor.substring(1, 7),
                                  radix: 16) +
                              0xFF000000),
                          width: 1.0),
                    ),
                    clipBehavior: Clip.antiAlias,
                    backgroundColor: e.isChecked
                        ? Color(int.parse(textColor.substring(1, 7),
                                radix: 16) +
                            0xFF000000)
                        : Color(int.parse(textColor.substring(1, 7),
                                radix: 16) +
                            0x33000000),
                    selectedColor: Color(
                        int.parse(textColor.substring(1, 7), radix: 16) +
                            0xFF000000),
                    onSelected: (bool value) {},
                  );
                }).toList())
          ],
        ));
  }
}
