class LoginResponse {
  String refresh;
  String token;

  LoginResponse({this.refresh, this.token});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    refresh = json['refresh'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['refresh'] = this.refresh;
    data['token'] = this.token;
    return data;
  }
}