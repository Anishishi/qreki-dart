int toOrdinal(DateTime date) {
  final startDate =
      DateTime(1, 1, 1); // January 1, 1 AD is the base for toordinal
  final difference = date.difference(startDate);
  return difference.inDays + 1; // Adding 1 because January 1, 1 AD is day 1
}
