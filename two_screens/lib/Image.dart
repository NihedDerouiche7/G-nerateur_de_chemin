class SavedImage {
  List<dynamic> new_strokes_x = [];
  List<dynamic> new_strokes_y = [];
  List<dynamic> direction = [];
  String name = "";

  SavedImage({
    required this.new_strokes_x,
    required this.new_strokes_y,
    required this.direction,
  }) {}

  SavedImage.fromJson(Map<dynamic, dynamic> json) {
    print(json);
    final new_strokes_xs = json['new_strokes_x'].toString().split(",");
    for (var element in new_strokes_xs) {
      try {
        new_strokes_x.add(int.parse(element));
      } catch (e) {}
    }

    final new_strokes_ys = json['new_strokes_y'].toString().split(",");
    for (var element in new_strokes_ys) {
      try {
        new_strokes_y.add(int.parse(element));
      } catch (e) {}
    }
    direction = json['direction'].toString().split(",");
    name = json['name'];
  }

  toJson() {
    return {
      "name": DateTime.now().toString(),
      "new_strokes_x": new_strokes_x.join(','),
      "new_strokes_y": new_strokes_y.join(","),
      "direction": direction.join(","),
    };
  }
}
