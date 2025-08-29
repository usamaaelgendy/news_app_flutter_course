extension DateTimeFormatter on DateTime {
  String formatDateTime() {
    final diff = DateTime.now().difference(this);

    if (diff.inMinutes < 60) {
      return "${diff.inMinutes}m ago";
    }
    if (diff.inHours < 24) {
      return "${diff.inHours}h ago";
    }

    return "${diff.inDays}d ago";
  }
}
