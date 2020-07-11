class NumberExist{

  // Возвращает информацию о наличии
  static String getTextNumber(String _startText, int _inputNumber) {

    String answer = _startText;

    if (_inputNumber == 0)
      answer += "нет";
    else if (_inputNumber != 0)
      answer += _inputNumber.toString();

    return answer;
  }
//
//  static String getChatUidString(String target) {
//    return
//  }
}