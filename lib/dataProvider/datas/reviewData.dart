class ReviewData {
  String author;
  String comment;
  int rating;
  String addedOn;

  ReviewData({this.author, this.comment, this.rating, this.addedOn});

  ReviewData.fromJson(Map<String, dynamic> json) {
    author = json['Author'];
    comment = json['Comment'];
    rating = json['Rating'];
    addedOn = json['AddedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Author'] = this.author;
    data['Comment'] = this.comment;
    data['Rating'] = this.rating;
    data['AddedOn'] = this.addedOn;
    return data;
  }
}
