class Validators {
  static String? validateTask(String value) {
    if (value.trim().isEmpty) {
      return "Task cannot be empty";
    }
    return null;
  }
}
