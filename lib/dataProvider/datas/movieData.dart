class MovieData {
  String iD;
  String name;
  dynamic rating;
  String addedBy;
  int voters;
  String addedOn;

  MovieData(
      {this.iD,
        this.name,
        this.rating,
        this.addedBy,
        this.voters,
        this.addedOn});

  MovieData.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
    rating = json['Rating'];
    addedBy = json['AddedBy'];
    voters = json['Voters'];
    addedOn = json['AddedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Name'] = this.name;
    data['Rating'] = this.rating;
    data['AddedBy'] = this.addedBy;
    data['Voters'] = this.voters;
    data['AddedOn'] = this.addedOn;
    return data;
  }
}
