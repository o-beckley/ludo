class LudoPosition{
  num x;
  num y;
  LudoPosition(this.x, this.y);

  @override
  String toString() {
    return 'LudoPosition($x, $y)';
  }

  @override
  int get hashCode => [x.toDouble(), y.toDouble()].hashCode;
  
  @override
  bool operator == (covariant LudoPosition other){
    return (x == other.x) && (y == other.y);
  }
}