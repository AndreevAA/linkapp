class UserInputDataVerification {
  static String _allCapitalsRus = "абвгдеёжзийклмнопрстуфхцчшщъыьэюя";

  // Верификация значения имени
  static bool isInputNameRight(String _name) {
    bool answer = true;

    // Проверка на длину
    if (_name.length >= 32)
      answer = false;

    // Провека на инвалидность введенного имени
    else if (_name.length >= 2) {
      for (int i = 0; i < _name.length; i++) {
        if (i == 0) {
          if (_name[0] == _name[0].toLowerCase()) {
            answer = false;
            break;
          }
        } else {
          bool meetFlag = false;
          if (_name[i] == "-" || _name[i] == " ")
            meetFlag = true;
          else {
            for (int j = 0; j < _allCapitalsRus.length; j++) {
              if (_name[i].toLowerCase() == _allCapitalsRus[j]) {
                meetFlag = true;
                break;
              }
            }
          }
          if (meetFlag == false) {
            answer = false;
            break;
          }
        }
      }
    }

    return answer;
  }

  // Верификация значения фамилии
  static bool isInputSurnameRight(String _surname) {
    bool answer = true;

    // Проверка на длину
    if (_surname.length >= 32)
      answer = false;

    // Проверка на корректность введенной фамилии
    else if (_surname.length >= 2) {
      for (int i = 0; i < _surname.length; i++) {
        if (i == 0) {
          if (_surname[0] == _surname[0].toLowerCase()) {
            answer = false;
            break;
          }
        } else {
          bool meetFlag = false;
          if (_surname[i] == "-" || _surname[i] == " ")
            meetFlag = true;
          else {
            for (int j = 0; j < _allCapitalsRus.length; j++) {
              if (_surname[i].toLowerCase() == _allCapitalsRus[j]) {
                meetFlag = true;
                break;
              }
            }
          }
          if (meetFlag == false) {
            answer = false;
            break;
          }
        }
      }
    }

    return answer;
  }

  // Верификация значения даты рождения
  static bool isInputBirthday(String _birthday) {
    bool answer = true;

//    DateTime date = DateTime.now();
//
//    // Проверка на длину
//    if (date.year - int.parse(_birthday) <= 4) answer = false;

    return answer;
  }
}
