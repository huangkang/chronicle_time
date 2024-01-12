class PhotoData {
  int? id;
  late int recordId;
  late int photoTime;
  late String photoPath;

  PhotoData({
    this.id,
    required this.recordId,
    required this.photoTime,
    required this.photoPath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'recordId': recordId,
      'photoTime': photoTime,
      'photoPath': photoPath
    };
  }

  static PhotoData fromMap(Map<String, dynamic> map) {
    return PhotoData(
        id: map['id'],
        recordId: map['recordId'],
        photoTime: map['photoTime'],
        photoPath: map['photoPath']);
  }
}
