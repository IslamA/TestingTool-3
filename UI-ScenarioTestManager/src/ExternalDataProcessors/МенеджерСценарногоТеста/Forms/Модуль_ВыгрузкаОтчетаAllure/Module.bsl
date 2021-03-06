
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	//Вставить содержимое обработчика
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Отказ = Истина; // форма не предназначена для открытия
КонецПроцедуры


&НаКлиенте
Функция ВыгрузитьОтчетВыполненияСценарногоТестированияФорматAllureXML(ПутьКаталога,ПутьКаталогСценария,ТестРезультатСтруктура) Экспорт 
	
	XMLСтрока = "";
	//ТестРезультатСтруктура = мСценСкрипт_ПолучитьДетальныйРезультатВыполненияСценария();	
	
	Попытка
		
		ИмяФайла = ПолучитьИмяВременногоФайла("xsd");
		СхемаAllure = ПолучитьМакетНаСервере("СхемаAllure");
		СхемаAllure.Записать(ИмяФайла);
		
		Фабрика = СоздатьФабрикуXDTO(ИмяФайла);
		
		ЗаписьXML = Новый ЗаписьXML;
		ЗаписьXML.УстановитьСтроку("UTF-8");
		ЗаписьXML.ЗаписатьОбъявлениеXML();
		
		// запишем объявления
		ТипTestSuiteResult = Фабрика.Тип("urn:model.allure.qatools.yandex.ru", "test-suite-result");
		Контейнер = Фабрика.Создать(ТипTestSuiteResult);
		
		Контейнер.name = ТестРезультатСтруктура.ИдентификаторТеста;
		Контейнер.title = ТестРезультатСтруктура.Представление;
		//Контейнер.description = "описание теста, комментарий";
		Контейнер.start = ТестРезультатСтруктура.start;
		Контейнер.stop = ТестРезультатСтруктура.stop;		
		//Контейнер.version = "1.1.1";
		
		Типlabels = Фабрика.Тип("urn:model.allure.qatools.yandex.ru", "labels");
		СписокМеток = Фабрика.Создать(Типlabels);
		СписокМеток.label.Добавить(Allure_ПолучитьМетку(Фабрика, "framework", "Scenario Testing Manager For 1C"));
		СписокМеток.label.Добавить(Allure_ПолучитьМетку(Фабрика, "version", ПолучитьВерсиюМенеджера()));
		СписокМеток.label.Добавить(Allure_ПолучитьМетку(Фабрика, "framework git", "https://github.com/ivanov660/TestingTool-3"));
		СписокМеток.label.Добавить(Allure_ПолучитьМетку(Фабрика, "framework lead developer", "Kruchkov Vladimir"));
		СписокМеток.label.Добавить(Allure_ПолучитьМетку(Фабрика, "language", "1С"));
		
		Контейнер.labels = СписокМеток;
		
		// Test cases папка
		ТипTestCasesResult = Фабрика.Тип("urn:model.allure.qatools.yandex.ru", "test-cases-result");
		НаборТестов  = Фабрика.Создать(ТипTestCasesResult);
		
		Контейнер.test_cases = НаборТестов;
		
		Для каждого стр из ТестРезультатСтруктура.ТестовыеСлучаи Цикл
			
			// Test cases данные
			ТипTestCaseResult = Фабрика.Тип("urn:model.allure.qatools.yandex.ru", "test-case-result");
			Тест = Фабрика.Создать(ТипTestCaseResult);
			
			// Тестовый случай для всего теста
			Тест.name = стр.Имя;
			Тест.title = стр.Представление;
			//Тест.description = "Описание "+ТестРезультатСтруктура.Имя;
			Тест.start = стр.start;
			Тест.stop  = стр.stop;
			Тест.status = Allure_ПолучитьСтатус(стр.РезультатВыполнения);
			Тест.severity = Allure_ПолучитьВажность(стр.Severity); 
			
			Если Тест.status = "broken" 
				ИЛИ Тест.status = "failed" Тогда
				
				СообщениеОбОшибке = УдалитьНедопустимыеСимволыXML(стр.ТекстОшибки);
				Тест.failure = Allure_ПолучитьОшибку(Фабрика, СообщениеОбОшибке);
				
				ТипParameters = Фабрика.Тип("urn:model.allure.qatools.yandex.ru", "parameters");
				НаборПараметров = Фабрика.Создать(ТипParameters);
				
				Тест.parameters = НаборПараметров;
				
			КонецЕсли;
			
			// вставляем шаги
			
			ТипSteps = Фабрика.Тип("urn:model.allure.qatools.yandex.ru", "steps");
			НаборШагов = Фабрика.Создать(ТипSteps);
			
			СформироватьНаборШагов(Фабрика,НаборШагов,стр.Шаги);
			
			Тест.steps = НаборШагов;			
			
			НаборТестов.test_case.Добавить(Тест);
			
			
		КонецЦикла;
		
		
		
		Фабрика.ЗаписатьXML(ЗаписьXML, Контейнер);
		
		XMLСтрока = ЗаписьXML.Закрыть();
		
		// удалим файл схемы
		Попытка
			УдалитьФайлы(ИмяФайла);
		Исключение
			// не смогли удалить файл
			Сообщить(ОписаниеОшибки());
		КонецПопытки;
		
	Исключение
		Сообщить(ОписаниеОшибки());
	КонецПопытки;
	
	Возврат XMLСтрока;
	
КонецФункции

&НаКлиенте
Процедура СформироватьНаборШагов(Фабрика,НаборШагов,Шаги)
	
	Если НаборШагов=Неопределено Тогда
		ТипSteps = Фабрика.Тип("urn:model.allure.qatools.yandex.ru", "steps");
		НаборШагов = Фабрика.Создать(ТипSteps);
	КонецЕсли;
	
	Для каждого д_шаг из Шаги Цикл
		
		// делаем шаг
		ТипStep = Фабрика.Тип("urn:model.allure.qatools.yandex.ru", "step");
		Шаг = Фабрика.Создать(ТипStep);
		
		Шаг.name = "№"+СтрЗаменить(строка(д_шаг.НомерШага)," ","")+" Действие:"+д_шаг.Действие+" Команда:"+д_шаг.Команда;
		Шаг.title = д_шаг.title;
		Шаг.start = д_шаг.start;
		Шаг.stop = д_шаг.stop;
		Шаг.status = Allure_ПолучитьСтатус(д_шаг.РезультатВыполнения);
		
		Если д_шаг.Свойство("Attachments") Тогда
		// подключаем attachments
			ТипAttachments = Фабрика.Тип("urn:model.allure.qatools.yandex.ru", "attachments");
			Attachments = Фабрика.Создать(ТипAttachments);

			Для каждого влож из д_шаг.Attachments Цикл
				ТипAttach = Фабрика.Тип("urn:model.allure.qatools.yandex.ru", "attachment");
				Attach = Фабрика.Создать(ТипAttach);
				Attach.title = влож.title;
				Attach.source = влож.source;
				Attach.type = влож.type;

				Attachments.attachment.Добавить(Attach);
			КонецЦикла;

			Шаг.attachments = Attachments;
		КонецЕсли;
		
		Если д_шаг.Шаги.Количество()>0 Тогда
			
			НаборШагов2 = Неопределено;
			
			СформироватьНаборШагов(Фабрика,НаборШагов2,д_шаг.Шаги);
			
			Шаг.steps = НаборШагов2;
		КонецЕсли;
		
		НаборШагов.step.Добавить(Шаг);
		
	КонецЦикла;
	
КонецПроцедуры	

// Функция - Получить макет на сервере
//
// Параметры:
//  ИмяМакета	 - строка	 - имя макета
// 
// Возвращаемое значение:
// макет  - макет
//
&НаСервере
Функция ПолучитьМакетНаСервере(ИмяМакета)
	Макет = Неопределено;
	Попытка
		ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
		Макет = ОбработкаОбъект.ПолучитьМакет(ИмяМакета);
	Исключение
		Сообщить(ОписаниеОшибки());		
	КонецПопытки;
	Возврат Макет;
КонецФункции

&НаСервере
Функция ПолучитьВерсиюМенеджера()
	Возврат РеквизитФормыВЗначение("Объект").СведенияОВнешнейОбработке().Версия;
КонецФункции

// { Helpers
&НаКлиенте
Функция УдалитьНедопустимыеСимволыXML(Знач Результат)
	Позиция = НайтиНедопустимыеСимволыXML(Результат);
	Пока Позиция > 0 Цикл
		Результат = Лев(Результат, Позиция - 1) + Сред(Результат, Позиция + 1);
		Позиция = НайтиНедопустимыеСимволыXML(Результат, Позиция);
	КонецЦикла;
	
	Возврат Результат;
КонецФункции

&НаКлиенте
Функция Allure_ПолучитьПреобразованнуюСтрокуXML(Знач Строка)

	Строка = СтрЗаменить(Строка,"<test-suite-result","<ns2:test-suite");
	Строка = СтрЗаменить(Строка,"</test-suite-result>","</ns2:test-suite>");
	Строка = СтрЗаменить(Строка,"xmlns=""urn:model.allure.qatools.yandex.ru""","xmlns:ns2=""urn:model.allure.qatools.yandex.ru""");
	
	Возврат Строка;

КонецФункции

&НаКлиенте
Функция Allure_ПолучитьМетку(Фабрика, Имя, Значение)

	Типlabel	= Фабрика.Тип("urn:model.allure.qatools.yandex.ru", "label");
	Метка		= Фабрика.Создать(Типlabel);
	Метка.name	= Имя;
	Метка.value = Значение;
	
	Возврат Метка;

КонецФункции

&НаКлиенте
Функция Allure_ПолучитьПараметр(Фабрика, Имя, Значение, Тип)

	ТипParameter 	= Фабрика.Тип("urn:model.allure.qatools.yandex.ru", "parameter");
	Параметр 		= Фабрика.Создать(ТипParameter);
	Параметр.name  	= Имя;
	Параметр.value 	= Значение;
	Параметр.kind 	= Тип;
	
	Возврат Параметр;

КонецФункции

&НаКлиенте
Функция Allure_ПолучитьОшибку(Фабрика, Знач СообщениеОбОшибке)

	ТипFailure		= Фабрика.Тип("urn:model.allure.qatools.yandex.ru", "failure");
	Ошибка			= Фабрика.Создать(ТипFailure);
	Ошибка.message	= СообщениеОбОшибке;	
	
	Возврат Ошибка;

КонецФункции

&НаКлиенте
Функция Allure_ПолучитьВажность(Значение="Значительная")

	Важность = "normal";
	
	Если Значение="Блокирующая" Тогда
		Важность = "blocker";
	ИначеЕсли Значение="Критическая" Тогда
		Важность = "critical";
	ИначеЕсли Значение="Значительная" Тогда
		Важность = "normal";
	ИначеЕсли Значение="Незначительная" Тогда
		Важность = "minor";
	ИначеЕсли Значение="Тривиальная" Тогда
		Важность = "trivial";
	КонецЕсли;
	
	Возврат Важность;

КонецФункции

&НаКлиенте
Функция Allure_ПолучитьСтатус(Значение="Пропущено")  

	Статус = "failed";
	
	Если ТипЗнч(Значение)=Тип("Число") Тогда
		Если Значение = 1 Тогда
			Статус = "passed";	
		ИначеЕсли Значение = 0 Тогда
			Статус = "canceled";
		ИначеЕсли Значение = 2 Тогда
			Статус = "broken";
		ИначеЕсли Значение = 3 Тогда
			Статус = "failed";
		КонецЕсли;		
	Иначе		
		Если Значение = "Успешно" Тогда
			Статус = "passed";	
		ИначеЕсли Значение = "Пропущено" ИЛИ Значение = "" Тогда
			Статус = "canceled";
		ИначеЕсли Значение = "Предупрежедение" Тогда
			Статус = "broken";
		ИначеЕсли Значение = "Ошибка" Тогда
			Статус = "failed";
		КонецЕсли;	
	КонецЕсли;
	
	Возврат Статус;

КонецФункции



// } Helpers
