class Notes {
  final int? id;
  final String noteText;
  final int userID;
  final String dateOfInsertion;

  Notes(this.id, this.noteText, this.userID, this.dateOfInsertion);

  Notes.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        noteText = res["noteText"],
        userID = res["userID"],
        dateOfInsertion = res["dateOfInsertion"];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'noteText': noteText,
      'userID': userID,
      'dateOfInsertion': dateOfInsertion,
    };
  }
}
