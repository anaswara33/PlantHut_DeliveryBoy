enum Menu { profile, dashboard }

extension MenuExtension on Menu {
  String toStringValue() {
    return this.toString().split('.').last;
  }
}
