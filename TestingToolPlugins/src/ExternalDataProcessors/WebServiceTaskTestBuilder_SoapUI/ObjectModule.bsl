#Область ДополнительныеОбработки

Функция СведенияОВнешнейОбработке() Экспорт
	
	МассивНазначений = Новый Массив;
	
	ПараметрыРегистрации = Новый Структура;
	ПараметрыРегистрации.Вставить("Вид", "ДополнительнаяОбработка");
	ПараметрыРегистрации.Вставить("Назначение", МассивНазначений);
	ПараметрыРегистрации.Вставить("Наименование", "Тест веб-сервисов (SoapUI)");
	ПараметрыРегистрации.Вставить("Версия", "2020.01.27");
	ПараметрыРегистрации.Вставить("БезопасныйРежим", Ложь);
	ПараметрыРегистрации.Вставить("Информация", ИнформацияПоИсторииИзменений());
	ПараметрыРегистрации.Вставить("ВерсияБСП", "1.2.1.4");
	ТаблицаКоманд = ПолучитьТаблицуКоманд();
	ДобавитьКоманду(ТаблицаКоманд,
	                "Тест веб-сервисов (SoapUI)",
					"WebServiceTaskTestBuilder_SoapUI",
					"ОткрытиеФормы",
					Истина,
					);
	ПараметрыРегистрации.Вставить("Команды", ТаблицаКоманд);
	
	Возврат ПараметрыРегистрации;
	
КонецФункции

Функция ПолучитьТаблицуКоманд()
	
	Команды = Новый ТаблицаЗначений;
	Команды.Колонки.Добавить("Представление", Новый ОписаниеТипов("Строка"));
	Команды.Колонки.Добавить("Идентификатор", Новый ОписаниеТипов("Строка"));
	Команды.Колонки.Добавить("Использование", Новый ОписаниеТипов("Строка"));
	Команды.Колонки.Добавить("ПоказыватьОповещение", Новый ОписаниеТипов("Булево"));
	Команды.Колонки.Добавить("Модификатор", Новый ОписаниеТипов("Строка"));
	
	Возврат Команды;
	
КонецФункции

Процедура ДобавитьКоманду(ТаблицаКоманд, Представление, Идентификатор, Использование, ПоказыватьОповещение = Ложь, Модификатор = "")
	
	НоваяКоманда = ТаблицаКоманд.Добавить();
	НоваяКоманда.Представление = Представление;
	НоваяКоманда.Идентификатор = Идентификатор;
	НоваяКоманда.Использование = Использование;
	НоваяКоманда.ПоказыватьОповещение = ПоказыватьОповещение;
	НоваяКоманда.Модификатор = Модификатор;
	
КонецПроцедуры

Функция ИнформацияПоИсторииИзменений()
	Возврат
	"
	| <div style='text-indent: 25px;'>Создание задания для тестирования веб-сервисов с помощью инструмента SoapUI.</div>
	| <hr />
	| Подробную информацию смотрите по адресу интернет: <a target='_blank' href='https://github.com/ivanov660/TestingTool-3/wiki'>https://github.com/ivanov660/TestingTool-3/wiki</a>";
КонецФункции

#КонецОбласти
