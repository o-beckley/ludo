class Player{
  final String username;
  final String id;
  final String profileImageUrl;

  Player({
    required this.username,
    required this.id,
    required this.profileImageUrl,
  });

  static Player fromMap(Map<String, dynamic> data){
    return Player(
      username: data['username'],
      id: data['id'],
      profileImageUrl: data['profileImageUrl'],
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'username': username,
      'id': id,
      'profileImageUrl': profileImageUrl,
    };
  }
}