import 'package:bday/services/storage_service.dart';
import 'package:bday/theme/assets.dart';
import 'package:bday/widgets/edit_entry.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/bday_record.dart';
import 'add_entry_modal.dart';

class BDayList extends StatefulWidget {
  final SortOption sortOption;
  final String filterQuery;

  const BDayList(
      {super.key, this.sortOption = SortOption.byName, this.filterQuery = ''});

  @override
  BDayListState createState() => BDayListState();
}

class BDayListState extends State<BDayList> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BDayRecord>>(
      future: context
          .watch<StorageService>()
          .list(sortBy: widget.sortOption, filter: widget.filterQuery),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return Stack(
            children: [
              if (!snapshot.hasData || snapshot.data!.isEmpty)
                const Center(child: Text("No entries found"))
              else
                ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    BDayRecord current = snapshot.data![index];
                    return _buildListItem(context, current);
                  },
                ),
              const Positioned(
                bottom: 10,
                right: 10,
                child: AddEntryModal(),
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildListItem(BuildContext context, BDayRecord current) {
    return GestureDetector(
      onLongPress: () {
        EditDialog.show(context, record: current);
      },
      child: ListTile(
        title: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: current.image == null
                  ? AssetsTheme.defaultProfile(context)
                  : FileImage(current.image!),
              backgroundColor: Colors.transparent,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    current.name,
                    style: const TextStyle(fontSize: 19),
                  ),
                  Text(
                    "${current.bornString()} - ${current.age()} Years",
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Text(
              current.daysTillBday() == 0
                  ? "Today"
                  : current.daysTillBday() == 1
                      ? "Tomorrow"
                      : "${current.daysTillBday()} days",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
