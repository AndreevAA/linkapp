package com.chatapp.main;

/*
 * Класс EmotionalCheckController работает следующим образом.
 * 
 * Оценку ты получаешь вызовом функции checkTone() и передаешь ей
 * идентификатор пользователя (строку) и, собственно, строку, которую ввел пользователь
 * и которую необходимо оценить.
 * 
 * Идентификатор пользователя не обязателен, если тебе в логике он не нужен, или ты управляешь им
 * на своей стороне, то передавай просто пустую строку.
 * 
 * Класс содержит массивы со словами, распределенные в зависимости от весового коэффициента.
 * 
 * Так, массив wordsRating1Negative содержит строки с весом -1 (максимально негативный тон),
 * а массив wordsRating1Positive содержит строки с весом +1 (максимально позитивный тон).
 * Также есть строки с весом +0.5 и -0.5, а также +0.25 и -0.25.
 * 
 * Перед словом может стоять символ "!" - это значит, что у слова может быть обратное значение,
 * которое невелирует тон.
 * 
 * Например, "болит" - это явно негативный тон, а "не болит" - это уже не негативный тон.
 * 
 * Слова введены с учетом различных форм.
 * Например, "ты меня достал" также будет учитывать "ты меня достала".
 * 
 * Примеры:
 *
 * "у него болит голова": рейтинг -1.00
 * "у него не болит голова": рейтинг 0.00
 *
 * Для простоты похожие слова не дублируются, то есть фраза:
 *
 * "у него болит голова и болит живот" все равно даст -1.00
 * 
 * Целесообразно реагировать на сообщение, если рейтинг по сумме сообщений равен -1 и ниже - это значит,
 * что пользователь испытывает явные негативные эмоции. Регулярно негативные сообщения могут стать поводом
 * для принятия действий со стороны социальной сети.
 * 
 */

import java.time.format.DateTimeFormatter;
import java.time.LocalDateTime;

public class EmotionalCheckController {
	
	public static String userId; // may be empty string if you manage user on your side
	public static float combinedUserScore;
	public static String lastUpdateTime;
	
	public static String[] wordsRating1Negative = {"!убить", "!убийца", "!убьем", "террор", "террорист", "бомба", "взрыв", "взорвем", "взорвать", "оружие", "!боль", "!болит", "урод", "дурак", "придурок", "придурки", "глупый", "глупые", "глупая", "тупой", "тупые", "тупая", "сука", "суки", "идиот", "шарлатан", "ты меня достал", "меня достали", "меня достало",  "все плохо", "все плохие", "смерть", "умрем", "умрут", "умереть", "убийца", "убийцы", "убийство", "плохое самочувствие", "!болезнь", "!болею", "!заболел", "!кашель", "!кашляю", "!насморк", "!чихаю", "!чихает", "из носа льет", "!травма", "!травмировал", "!пытка", "!пытки", "!пытать", "!пытали", "лежал в больнице", "!лежала в больнице", "!лежали в больнице", "!делали операцию", "!делал операцию", "!делала операцию", "!несчастье", "!несчастлив"};
	public static String[] wordsRating05Negative = {"скука", "!скучно", "!скучаю", "!скучаем", "!скучают", "нет дела", "ничем не занят", "ничего не делаю", "ничего не делаем", "ничего не делают", "!бездельничаю", "!бездельничаем", "туплю", "тупим", "тупят", "!тяжело", "напряжение", "напряженно", "!устал", "!усталость", "!негатив", "!вкалываю", "!изнываю", "!хотелось бы лучше", "да ну нафиг"};
	public static String[] wordsRating025Negative = {"!работа", "работаю", "труд", "тружусь", "трудимся", "труженик", "!хочу отдохнуть", "!хочу развлечься", "офигел", "это еще что", "да ну нафиг"};
	public static String[] wordsRating1Positive = {"!супер", "!отлично", "!шикарно", "!великолепно", "!офигенно", "!очень рад", "!счастлив", "!кайф", "!эфория", "!улетно"};
	public static String[] wordsRating05Positive = {"!норм", "!рад", "!прикол", "!зачет", "это тема!", "!топ"};
	public static String[] wordsRating025Positive = {"!ok", "!ОК", "!окей", "!согласен", "!согласна", "!подтверждаю"};

	public static float checkTone(String uID, String strUserInput)
	{		
		DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
		LocalDateTime nowTime = LocalDateTime.now();
		lastUpdateTime = dtf.format(nowTime);

		userId = uID;
		
		strUserInput = " "+strUserInput;

		// Проверка негативных значений

		for(int f = 0; f < wordsRating1Negative.length; f++)
		{
			if(wordsRating1Negative[f].substring(0,1).equals("!"))
			{
				combinedUserScore -= checkScore(wordsRating1Negative[f].substring(1), strUserInput, 1);
			}
			else
			{
				if(strUserInput.indexOf(wordsRating1Negative[f]) >= 0) combinedUserScore -= 1;
			}
		}

		for(int f = 0; f < wordsRating05Negative.length; f++)
		{
			if(wordsRating05Negative[f].substring(0,1).equals("!"))
			{
				combinedUserScore -= checkScore(wordsRating05Negative[f].substring(1), strUserInput, (float)0.5);
			}
			else
			{
				if(strUserInput.indexOf(wordsRating05Negative[f]) >= 0) combinedUserScore -= (float)0.5;
			}
		}

		for(int f = 0; f < wordsRating025Negative.length; f++)
		{
			if(wordsRating025Negative[f].substring(0,1).equals("!"))
			{
				combinedUserScore -= checkScore(wordsRating025Negative[f].substring(1), strUserInput, (float)0.25);
			}
			else
			{
				if(strUserInput.indexOf(wordsRating025Negative[f]) >= 0) combinedUserScore -= (float)0.25;
			}
		}

		// Проверка позитивных значений
		
		for(int f = 0; f < wordsRating1Positive.length; f++)
		{
			if(wordsRating1Positive[f].substring(0,1).equals("!"))
			{
				combinedUserScore += checkScore(wordsRating1Positive[f].substring(1), strUserInput, 1);
			}
			else
			{
				if(strUserInput.indexOf(wordsRating1Positive[f]) >= 0) combinedUserScore += 1;
			}
		}

		for(int f = 0; f < wordsRating05Positive.length; f++)
		{
			if(wordsRating05Positive[f].substring(0,1).equals("!"))
			{
				combinedUserScore += checkScore(wordsRating05Positive[f].substring(1), strUserInput, (float)0.5);
			}
			else
			{
				if(strUserInput.indexOf(wordsRating05Positive[f]) >= 0) combinedUserScore += (float)0.5;
			}
		}

		for(int f = 0; f < wordsRating025Positive.length; f++)
		{
			if(wordsRating025Positive[f].substring(0,1).equals("!"))
			{
				combinedUserScore += checkScore(wordsRating025Positive[f].substring(1), strUserInput, (float)0.25);
			}
			else
			{
				if(strUserInput.indexOf(wordsRating025Positive[f]) >= 0) combinedUserScore += (float)0.25;
			}
		}
		
		return combinedUserScore;
	}
	
	private static float checkScore(String strActual, String strUserInput, float val)
	{
		float comboScore = 0;

		int i = strUserInput.indexOf(strActual);
		System.out.println("i:"+i);
		if(i >= 0)
		{
			if((i >= 4 && !strUserInput.substring(i-4,i-1).equals(" не")) && (i >= 5 && !strUserInput.substring(i-5,i-1).equals(" нет")))
			{
				comboScore += val;
			}
		}

		return comboScore;
	}
}
