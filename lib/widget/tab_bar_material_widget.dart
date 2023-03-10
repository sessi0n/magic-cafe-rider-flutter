import 'package:bike_adventure/constants/systems.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TabBarMaterialWidget extends StatefulWidget {
  const TabBarMaterialWidget({Key? key, required this.index,required  this.onChangedTab}) : super(key: key);
  final int index;
  final ValueChanged<int> onChangedTab;

  @override
  State<TabBarMaterialWidget> createState() => _TabBarMaterialWidgetState();
}

class _TabBarMaterialWidgetState extends State<TabBarMaterialWidget> {
  @override
  Widget build(BuildContext context) {
    final placeHolder = Opacity(opacity: 0, child: IconButton(onPressed: (){}, icon: const Icon(Icons.no_cell)),);

    return BottomAppBar(
      elevation: 10,
      color: Colors.black.withOpacity(0.7),
      shape: const CircularNotchedRectangle(),
      notchMargin: 5,
      child: SizedBox(
        height: 62,
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // buildTabItem(index: 0, text: '카페', icon: ImageIcon(AssetImage('assets/icons/quest3.png'), size: TAB_ICONS_SIZE)),
              buildTabItem(index: 0, text: '카페', icon: const FaIcon(FontAwesomeIcons.mugSaucer, size: 25)),
              // buildTabItem(index: 1, text: '상점', icon: ImageIcon(AssetImage('assets/icons/box4.png'), size: TAB_ICONS_SIZE)),
              buildTabItem(index: 1, text: '상점', icon: const FaIcon(FontAwesomeIcons.truckFast, size: 25)),
              placeHolder,
              // buildTabItem(index: 2, text: '내정보', icon: const ImageIcon(AssetImage('assets/icons/map.png'), size: TAB_ICONS_SIZE-6)),
              buildTabItem(index: 2, text: '출석', icon: const FaIcon(FontAwesomeIcons.motorcycle, size: 25)),
              // buildTabItem(index: 3, icon: const Icon(Icons.leaderboard_rounded, size: TAB_ICONS_SIZE +5)),
              // buildTabItem(index: 3, text: '세일', icon: const Icon(Icons.discount_rounded, size: TAB_ICONS_SIZE-3)),
              buildTabItem(index: 3, text: '주행', icon: const FaIcon(FontAwesomeIcons.mapLocationDot, size: 25)),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTabItem({required int index, required icon, required text}) {
    final isSelected = index == widget.index;
    return Flexible(
      child: InkWell(
        onTap: ()=> widget.onChangedTab(index),
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
            IconTheme(
                data: IconThemeData(
                  color: isSelected ? Colors.lightBlueAccent : Colors.grey,
                ),
                child: icon),
              Text(text, style: TextStyle(fontSize: 12, color: Colors.white),)
            ],
          ),
        ),
      ),
    );

    // return IconTheme(
    //     data: IconThemeData(
    //       color: isSelected ? Colors.black : Colors.grey,
    //     ),
    //     child: IconButton(onPressed: ()=> widget.onChangedTab(index), icon: icon));
  }
}
