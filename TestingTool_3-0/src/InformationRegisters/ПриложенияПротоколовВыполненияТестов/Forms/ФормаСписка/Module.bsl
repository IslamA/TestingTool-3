&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ИзменитьОформлениеОтображениеПриложения();
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьПриложение(Команда)
	
	ОтображатьПриложение = НЕ ОтображатьПриложение;
	
	ИзменитьОформлениеОтображениеПриложения();
	
КонецПроцедуры


&НаКлиенте
Процедура ИзменитьОформлениеОтображениеПриложения()
	Если ОтображатьПриложение=Истина Тогда
		Элементы.ПоказатьПриложение.Картинка=БиблиотекаКартинок.Screenshot_32х32;
		Элементы.ГруппаДополнительно.Видимость = Истина;
	Иначе
		Элементы.ПоказатьПриложение.Картинка=БиблиотекаКартинок.Screenshot_gray_32х32;
		Элементы.ГруппаДополнительно.Видимость = Ложь;
	КонецЕсли;
КонецПроцедуры


&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекущиеДанные=Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ОтображатьПриложение=Истина Тогда
		мОтбор = новый Структура("Проверка,ТестируемыйКлиент,Тест,ТестовыйСлучай,Шаг,Номер");
		ЗаполнитьЗначенияСвойств(мОтбор,ТекущиеДанные );
		ПолеHTML = ПолучитьПриложениеИзБазы(мОтбор);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьПриложениеИзБазы(Источник)
	СсылкаНаКартинку = Неопределено;
	Картинка="";
	
	Запрос = новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
	|	Т.Приложение,
	|	Т.ТипФайла,
	|	Т.Размер
	|ИЗ
	|	РегистрСведений.ПриложенияПротоколовВыполненияТестов КАК Т
	|ГДЕ
	|	Т.Проверка = &Проверка
	|	И Т.ТестируемыйКлиент = &ТестируемыйКлиент
	|	И Т.Тест = &Тест
	|	И Т.ТестовыйСлучай = &ТестовыйСлучай
	|	И Т.Шаг = &Шаг
	|	И Т.Номер = &Номер";
	Запрос.УстановитьПараметр("Проверка", Источник.Проверка);
	Запрос.УстановитьПараметр("ТестируемыйКлиент", Источник.ТестируемыйКлиент);
	Запрос.УстановитьПараметр("Тест", Источник.Тест);
	Запрос.УстановитьПараметр("ТестовыйСлучай", Источник.ТестовыйСлучай);
	Запрос.УстановитьПараметр("Шаг", Источник.Шаг);
	Запрос.УстановитьПараметр("Номер", Источник.Номер);
	
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
		Возврат "<html><head></head><body>"+Картинка+"</body></html>";
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	
	Если ТипЗнч(Выборка.Приложение)=Тип("ХранилищеЗначения") Тогда
		СсылкаНаКартинку = ПоместитьВоВременноеХранилище(Новый Картинка(Выборка.Приложение.Получить()),новый УникальныйИдентификатор);
		Картинка = Картинка+"<IMG style='' src='"+СсылкаНаКартинку+"'><br />";
	КонецЕсли;

	
	Возврат "<html><head></head><body>"+Картинка+"</body></html>";
КонецФункции
