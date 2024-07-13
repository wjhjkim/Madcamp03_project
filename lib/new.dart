PreferredSize(
preferredSize: Size.fromHeight(15.0),
child: GestureDetector(
onTap: _pickDate,
child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
Icon(Icons.calendar_month),
Text(
DateFormat(' yyyy.MM.dd.').format(_selectedDate),
),
]),
),
),