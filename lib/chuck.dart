/* 
{
  "icon_url" : "https://assets.chucknorris.host/img/avatar/chuck-norris.png",
  "id" : "Yw2zxCdSSJWWGZQUWmd0pA",
  "url" : "",
  "value" : "when a robber steal stuff from people they say its like taking candy from a baby. but when they steal from Chuck Norris it's not as easy as they think."
}
*/

class Chuck {
  final String iconUrl;
  final String id;
  final String url;
  final String value;

  Chuck({
    required this.iconUrl,
    required this.id,
    required this.url,
    required this.value,
  });

  factory Chuck.fromJson(Map<String, dynamic> json) {
    return Chuck(
      iconUrl: json['icon_url'],
      id: json['id'],
      url: json['url'],
      value: json['value'],
    );
  }
}
