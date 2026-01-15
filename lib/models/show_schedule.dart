class ShowSchedule {
  final String idShow;
  final String tglShow;
  final String jamShow;
  final String setlist;
  final String lineUp;

  ShowSchedule({
    required this.idShow,
    required this.tglShow,
    required this.jamShow,
    required this.setlist,
    required this.lineUp,
  });

  factory ShowSchedule.fromJson(Map<String, dynamic> json) {
    return ShowSchedule(
      idShow: json['id'] ?? json['idShow'] ?? '',
      tglShow: json['tglShow'] ?? '-',
      jamShow: json['jamShow'] ?? '-',
      setlist: json['setlist'] ?? '-',
      lineUp: json['lineUp'] ?? '-',
    );
  }
}
