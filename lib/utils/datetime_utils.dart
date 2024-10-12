extension DatetimeUtils on DateTime{
  String get timeDifference{
    Duration d = DateTime.now().difference(this);
    if(d.inDays >= 365){
      return '${(d.inDays/365).floor()}y';
    }
    else if(d.inDays >= 30){
      return '${(d.inDays/30).floor()}mo';
    }
    else if(d.inDays >= 7){
      return '${(d.inDays/7).floor()}w';
    }
    else if(d.inDays >= 1){
      return '${d.inDays}d';
    }
    else if(d.inHours >=1 ){
      return '${d.inHours}h';
    }
    else if(d.inMinutes >=1){
      return '${d.inMinutes}m';
    }
    else {
      return '${d.inSeconds}s';
    }
  }
}