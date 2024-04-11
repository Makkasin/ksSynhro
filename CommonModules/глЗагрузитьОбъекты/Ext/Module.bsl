﻿
Процедура ЗагрузитьОбъекты(ВидОбъекта) Экспорт
	
	  Мета = Метаданные.Документы.Найти(ВидОбъекта);
	  Пар = Новый Структура();
	  
	  Если Мета<>Неопределено Тогда
		  Стк = Новый Структура("ВидДок,ВидДокПрм",ВидОбъекта,ВидОбъекта); 
		  Пар.Вставить("_ТблХЭШ",РегистрыСведений.ксРегИзмененийИзФормы.ПолучитьТБлХЭШ("Документ",ВидОбъекта));	  
	  Иначе
		  Стк = Новый Структура("видСпр,видСпрПрм",ВидОбъекта,ВидОбъекта); 
		  Пар.Вставить("_ТблХЭШ",РегистрыСведений.ксРегИзмененийИзФормы.ПолучитьТБлХЭШ("Справочник",ВидОбъекта));	  
	  КонецЕсли;
	  
	  Стк.Вставить("пар",пар);  
	  
	  итМас = СделатьЗапрос("SYNHRO",Стк);
	  ЗагрузитьОбк(итМас); 
	  
	  Сообщить("Загружено: "+ВидОбъекта+" - "+итМАс.Количество());
	
КонецПроцедуры


Функция СделатьЗапрос(Метод,Стк) 
	
	Соединение = глЛокализацияУсловияСинхронизации.СткПолучитьСоединение();
	
	Запрос = Новый HTTPЗапрос("/BP_Finans_work/hs/ksSynhro/"+Метод);
	                                           
	
	хр = Новый ХранилищеЗначения(Стк);
	Запрос.УстановитьТелоИзСтроки(XMLстрока(хр));
	
	Результат = Соединение.POST(Запрос);
	
	Если Результат.КодСостояния <> 200 Тогда 
		Сообщить("Ошибка отправки: "+Результат.КодСостояния);
		Сообщить(результат.ПолучитьТелоКакСтроку());
		Возврат Неопределено;
	КонецЕСЛИ;  
	
	Возврат XMLЗначение(Тип("ХранилищеЗначения"),результат.ПолучитьТелоКакСтроку()).Получить();
	
	
КонецФункции   


Процедура ЗагрузитьПоСсылке(масСС) Экспорт    
	
	мас = новый МАссив;
	Для каждого Эл из масСС Цикл
		мас.Добавить(эл.уникальныйИдентификатор());
	КонецЦикла;   
	
	п=XMLТипЗнч(масСС[0]).TypeName;  
	вид = Сред(п,найти(п,".")+1);
	Если Найти(п,"CatalogRef")<>0 Тогда 
		Стк = Новый Структура("ВидСпр",вид);  
	иначе	
		//Стк = ПолучитьСткВИдовДокументов(Вид);//Новый Структура("ВидДок",вид);  
		//Если Метаданные.Документы[Стк.ВидДокПрм].Реквизиты.Найти("Организация")<>Неопределено ТОгда
		//	Стк.Вставить("идОрг",масСС[0].Организация.УникальныйИдентификатор());                      
		//КонецЕСЛИ;                       
	КонецЕсли; 
	
	ЗагрузитьМасСС(мас,Стк);
	
Конецпроцедуры

Процедура ЗагрузитьМасСС(масСС,Стк) Экспорт 
	
	Пар = Новый Структура();
	Пар.Вставить("масGUID",масСС);   
	
	Если Стк.свойство("идОрг") Тогда 
		Пар.Вставить("идОрг",Стк.идОрг);   
	КонецеслИ;
	
	Стк.Вставить("пар",пар);   
	
	итМас = СделатьЗапрос("SYNHRO",Стк);  
	ЗагрузитьОбк(итМас); 
	
КонецПроцедуры

Процедура ЗагрузитьДоки(СпкВидДокументов,ГрузитьВсе=Неопределено) Экспорт 
	
	  Пар = Новый Структура();
	Для каждого эл из СпкВидДокументов Цикл  
		Если эл.Пометка = Ложь ТОгда ПродолжитЬ; КонецеСЛИ;
		
		//Пар.Вставить("Дт1",НачалоДня(Дт));
		//Пар.Вставить("Дт2",КонецДня(Дт1)+1); 
		//Если Метаданные.Документы[эл.Представление].Реквизиты.Найти("Организация")<>Неопределено ТОгда
		//	Пар.Вставить("идОрг",Организация.УникальныйИдентификатор());                      
		//КонецЕСЛИ;
		
		Стк = Новый Структура("ВидДок,ВидДокПрм",эл.Значение,эл.Представление); 
		Если ГрузитьВсе=Неопределено ТОгда 
		//	ПАр.Вставить("_ТблХЭШ",ПолучитьТблХЭШ(Стк.ВидДокПрм));
		КонецеСЛИ;
		Стк.Вставить("пар",пар);  
		//Стк.Вставить("хэш",РегистрыСведений.ксРегИзмененийИзФормы.ПолучитьХЭШ(Дт,дт1,эл.Представление));
		
		итМас = СделатьЗапрос("SYNHRO",Стк);
		ЗагрузитьОбк(итМас); 
		
		Сообщить("Загружено: "+эл.Значение+" - "+итМАс.Количество());
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьПоGUID(обкДок,Стк,СооОН,сооМетаОбк) 
	
	//Для ускорения список реквизитов положим в соответствие
	метаРек = сооМетаОбк.получить(Стк.ВидСпр);
	Если метаРек = Неопределено Тогда
		
		метаРек = Новый Массив;  
		мета = обкДок.Метаданные();
		Для каждого Рек из Мета.Реквизиты Цикл
			метаРек.Добавить(рек.имя);
		Конеццикла;
		Для каждого Рек из Мета.СтандартныеРеквизиты Цикл
			метаРек.Добавить(рек.имя);
		Конеццикла;  
		
		сооМетаОбк.Вставить(Стк.ВидСпр,метаРек);
	КонецЕсли;
	
	ДЛя каждого эл из Стк Цикл
		Если ТипЗнч(Эл.Значение) <> Тип("УникальныйИдентификатор") Тогда Продолжить; КонецеслИ;
		Если метаРек.Найти(эл.ключ)=Неопределено Тогда Продолжить; КонецеслИ;
		
		п=XMLТипЗнч(обкДок[эл.ключ]).TypeName; 
		Если Найти(п,"CatalogRef")=0 ТОгда Продолжить; КонецесЛИ;
		пТипСпр = Сред(п,Найти(п,".")+1);
		
		обкДок[эл.ключ] = Справочники[пТипСпр].ПолучитьСсылку(Эл.Значение);
		Если Найти(СокрЛП(обкДок[эл.ключ]),"не найден")<>0 Тогда
			сооОН.вставить(Эл.значение,пТипСпр);
		КонецеслИ;
	КонецЦикла;
	
КонецПроцедуры   


Функция ОстаткиТоваров(Обк,МасНом,ТекСклад=Неопределено)
	
	Если текСклад = Неопределено ТОгда
		текСклад = Обк.склад;
	КонецеслИ;
	
	Запрос = Новый Запрос;  
	Запрос.УстановитьПараметр("Орг",Обк.Организация);
	Запрос.УстановитьПараметр("Дт",КонецДня(Обк.дата));
	Запрос.УстановитьПараметр("Скл",текСклад);
	Запрос.УстановитьПараметр("МасНом",МасНом);  
	
	масСуб = Новый Массив;
	масСуб.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Номенклатура);
	масСуб.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Склады);
	Запрос.УстановитьПараметр("масСуб",масСуб);  
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	ХозрасчетныйОстатки.Счет КАК Счет,
	               |	ХозрасчетныйОстатки.Субконто1 КАК ном
	               |ИЗ
	               |	РегистрБухгалтерии.Хозрасчетный.Остатки(
	               |			&Дт,
	               |			Подстрока(Счет.РОдитель.Код,1,2) В (""10"", ""41"", ""43""),
	               |			&масСуб,
	               |			Организация = &Орг
	               |				И Субконто1 В (&МасНом)
	               |				И Субконто2 = &Скл) КАК ХозрасчетныйОстатки
				   |
				   |WHERE ХозрасчетныйОстатки.КоличествоОстаток > 0 
				   |"; 
	
	
	ТБл = Запрос.Выполнить().Выгрузить();
	
	Возврат Тбл;
	
	
КонецФункции 

Функция СчетТМЦСкладПоУмолчанию(Орг,ТекСкл)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация",Орг);
	Запрос.УстановитьПараметр("Склад",ТекСкл);
	Запрос.Текст = "
|ВЫБРАТЬ
|	СчетаУчетаНоменклатуры.СчетУчета КАК СчетУчета,
|	CASE WHEN СчетаУчетаНоменклатуры.Склад = &Склад THEN 0 ELSE 1 END КАК инд
|	
|ИЗ
|	РегистрСведений.СчетаУчетаНоменклатуры КАК СчетаУчетаНоменклатуры
|ГДЕ
|	СчетаУчетаНоменклатуры.Организация = &Организация
|	И СчетаУчетаНоменклатуры.Номенклатура = Значение(Справочник.Номенклатура.ПустаяСсылка)
|	И СчетаУчетаНоменклатуры.ВидНоменклатуры = Значение(Справочник.ВидыНоменклатуры.ПустаяСсылка)
//|	И СчетаУчетаНоменклатуры.Склад в (&Склад,Значение(Справочник.Склады.ПустаяСсылка))
|	И СчетаУчетаНоменклатуры.Склад в (&Склад)
|	
|ORDER BY инд 
|
|"; 
	
	Выб = Запрос.Выполнить().Выбрать();
	Если Выб.Следующий() ТОгда
		Возврат Выб.счетУчета;
	ИНаче
		Возврат Неопределено;
	КонецесЛИ;
	


КонецФункции


Процедура КоррТоварыДокПост(тбл)
	
	сч1903 = ПланыСчетов.Хозрасчетный.НДСпоПриобретеннымМПЗ;
	
	Для каждого Стр из ТБл Цикл  
		Стр.Коэффициент = 1;
		Стр.ОтражениеВУСН=Перечисления.ОтражениеВУСН.Принимаются;
		Стр.СпособУчетаНДС = Перечисления.СпособыУчетаНДС.ПринимаетсяКВычету;
		
		Стр.СчетУчетаНДС = сч1903;
		
	КонецЦикла;
	
КонецПроцедуры 


Процедура КоррТоварыДокРеал(тбл,обк)
	
	
	
	Стк41 = Новый Структура();
	Стк41.Вставить("СчетДоходов",ПланыСчетов.Хозрасчетный.ВыручкаНеЕНВД);
	Стк41.Вставить("СчетРасходов",ПланыСчетов.Хозрасчетный.СебестоимостьПродажНеЕНВД); 
	Стк41.Вставить("СчетУчетаНДСПоРеализации",ПланыСчетов.Хозрасчетный.Продажи_НДС);   
	Стк41.Вставить("Субконто",Справочники.НоменклатурныеГруппы.НайтиПоНаименованию("продажа",истина));
	
	СткСч = Новый Структура();
	СткСч.Вставить("СчетДоходов",ПланыСчетов.Хозрасчетный.ПрочиеДоходы);
	СткСч.Вставить("СчетРасходов",ПланыСчетов.Хозрасчетный.ПрочиеРасходы); 
	СткСч.Вставить("СчетУчетаНДСПоРеализации",ПланыСчетов.Хозрасчетный.ПрочиеРасходы);   
	СткСч.Вставить("Субконто",Справочники.ПрочиеДоходыИРасходы.НайтиПоНаименованию("Доходы (расходы), связанные с реализацией прочего имущества",истина));
	
	тбНом = ОстаткиТоваров(Обк,ТБл.ВыгрузитьКОлонку("Номенклатура"));  
	сч41 = Планысчетов.Хозрасчетный.ТоварыНаСкладах;
	
	
	Для каждого Стр из ТБл Цикл  
		Стр.Коэффициент = 1;   
		
		нс = тбНом.Найти(стр.номенклатура,"ном");
		Если нс<>Неопределено Тогда
			стр.счетучета = нс.счет;
		КонецеслИ;
		
		Если Стр.счетучета = сч41 ТОгда
			ЗаполнитьЗначенияСвойств(Стр,стк41);
		Иначе
			ЗаполнитьЗначенияСвойств(Стр,СткСч);
		КонецЕСлИ;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура КоррТоварыДокПерем(тбл,обк)
	
	новСчетУчета = СчетТМЦСкладПоУмолчанию(Обк.Организация,Обк.СкладОтправитель);
	
	тбНом = ОстаткиТоваров(Обк,ТБл.ВыгрузитьКОлонку("Номенклатура"),Обк.СкладОтправитель);  
	
	
	Для каждого Стр из ТБл Цикл  
		Стр.Коэффициент = 1;   
		
		нс = тбНом.Найти(стр.номенклатура,"ном");
		Если нс<>Неопределено Тогда
			стр.счетучета = нс.счет;
		КонецеслИ; 
		
		Если новСчетУчета<>Неопределено Тогда
			стр.НовыйСчетУчета = новСчетУчета; 
		Иначе
			стр.НовыйСчетУчета = стр.счетучета; 
		КонецеСЛИ;   
		
		Стр.СпособУчетаНДС = Перечисления.СпособыУчетаНДС.ПринимаетсяКВычету;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура КоррТоварыДокТребНакл(тбл,обк)
	
	
	тбНом = ОстаткиТоваров(Обк,ТБл.ВыгрузитьКОлонку("Номенклатура"),Обк.Склад);  
	
	
	Для каждого Стр из ТБл Цикл  
		Стр.Коэффициент = 1;   
		
		нс = тбНом.Найти(стр.номенклатура,"ном");
		Если нс<>Неопределено Тогда
			стр.счет = нс.счет;
		КонецеслИ; 
		
		Стр.СпособУчетаНДС = Перечисления.СпособыУчетаНДС.ПринимаетсяКВычету;
	КонецЦикла;
	
КонецПроцедуры

Процедура КоррТоварыВводВЭкспл(обк,Стк)
	
	пТбл = Стк.ТабЧасть.Спецодежда;
	Тбл = Обк.Спецодежда.выгрузить();
	тбНом = ОстаткиТоваров(Обк,Тбл.ВыгрузитьКолонку("Номенклатура"));  
	
	Обк.Спецодежда.Очистить();
	Обк.ИнвентарьИХозяйственныеПринадлежности.Очистить(); 
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
|ВЫБРАТЬ
|	ВидыНоменклатуры.Ссылка КАК Ссылка
|ИЗ
|	Справочник.ВидыНоменклатуры КАК ВидыНоменклатуры
|ГДЕ
|	ВидыНоменклатуры.Наименование LIKE ""%спецодежд%""
|";
	масСО = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	сч1010 = ПланыСчетов.Хозрасчетный.СпецоснасткаИСпецодеждаНаСкладе;
	
	текСпособСО  = неопределено;
	текСпособМБП = неопределено;
	Для а=1 по Тбл.Количество() Цикл
		Стр  =  Тбл[а-1];
	  
		нс = тбНом.Найти(стр.номенклатура,"ном");
		Если нс<>Неопределено Тогда
			стр.счетучета = нс.счет;
		КонецеслИ; 
		
		Если Стр.счетУчета = сч1010 или масСО.Найти(стр.номенклатура.ВидНоменклатуры)<>Неопределено Тогда
			новстр = Обк.Спецодежда.Добавить(); 
			пСтр = пТбл[а-1];
			новстр.НазначениеИспользования = НайтиНазначениеИспользованияНом(Стр.Номенклатура,пстр.СрокЭкспл); 
			стрИсклКол = "НазначениеИспользования,СпособОтраженияРасходов";       
			
			Если текСпособСО=Неопределено Тогда текСпособСО  = НайтиСпособОтраженияМБП(обк.Дата,Обк.ПодразделениеОрганизации); КонецЕсли;
			новСтр.СпособОтраженияРасходов = текСпособСО;
		Иначе
			новстр = Обк.ИнвентарьИХозяйственныеПринадлежности.Добавить();
			стрИсклКол = "СпособОтраженияРасходов";
			
			Если текСпособМБП=Неопределено Тогда текСпособМБП  = НайтиСпособОтраженияМБП(обк.Дата,Обк.ПодразделениеОрганизации,Истина); КонецЕсли;
			новСтр.СпособОтраженияРасходов = текСпособМБП;
		КонецЕсли;  
		ЗаполнитьЗначенияСвойств(новстр,Стр,,стрИсклКол);
		
		
	КонецЦикла;
	
КонецПроцедуры 

Функция НайтиСпособОтраженияМБП(пДт,Подр,ЭтоИнвентарь=Ложь)
	Если ЗначениеЗаполнено(Подр)=Ложь Тогда Возврат Справочники.СпособыОтраженияРасходовПоАмортизации.ПустаяСсылка(); КонецЕСЛИ;
	
	
	Запрос = новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ  TOP 1
	               |	ПередачаМатериаловВЭксплуатациюСпецодежда.СпособОтраженияРасходов КАК СпособОтраженияРасходов
	               |ИЗ
	               |	Документ.ПередачаМатериаловВЭксплуатацию.Спецодежда КАК ПередачаМатериаловВЭксплуатациюСпецодежда
	               |ГДЕ
	               |	ПередачаМатериаловВЭксплуатациюСпецодежда.Ссылка.Дата <= &Дата
	               |	И ПередачаМатериаловВЭксплуатациюСпецодежда.Ссылка.Проведен = true
	               |	И ПередачаМатериаловВЭксплуатациюСпецодежда.Ссылка.ПодразделениеОрганизации = &Подр
	               |    и СпособОтраженияРасходов <> Значение(Справочник.СпособыОтраженияРасходовПоАмортизации.ПустаяСсылка)
	               |УПОРЯДОЧИТЬ ПО
	               |	ПередачаМатериаловВЭксплуатациюСпецодежда.Ссылка.Дата УБЫВ";                       
	Запрос.УстановитьПараметр("Дата",пДт);
	Запрос.УстановитьПараметр("Подр",Подр); 
	
	Если ЭтоИнвентарь Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст,"Документ.ПередачаМатериаловВЭксплуатацию.Спецодежда","Документ.ПередачаМатериаловВЭксплуатацию.ИнвентарьИХозяйственныеПринадлежности");
	Конецесли;
	
	Выб =Запрос.Выполнить().Выбрать();
	Если ВЫб.Следующий() ТОгда
		Возврат Выб.СпособОтраженияРасходов;	
	КонецЕсли;

	Возврат Справочники.СпособыОтраженияРасходовПоАмортизации.ПустаяСсылка();
	
КонецФункции

Функция НайтиНазначениеИспользованияНом(Ном,Срок)
	
	Если ЗначениеЗаполнено(ном)=Ложь или ЗначениеЗаполнено(Срок)=Ложь ТОгда
		Возврат Неопределено;
	КонецЕсли;
	
	Запрос = Новый ЗАпрос;    
	Запрос.УстановитьПараметр("Владелец",Ном);
	Запрос.УстановитьПараметр("срок",срок);
	Запрос.УстановитьПараметр("СпособПогашенияСтоимости",Перечисления.СпособыПогашенияСтоимости.Линейный);
	Запрос.Текст = "ВЫБРАТЬ top 1
	               |	НазначенияИспользования.Ссылка КАК Ссылка,
				   | CASE WHEN СпособПогашенияСтоимости = &СпособПогашенияСтоимости THEN 0 ELSE 1 END ind
	               |ИЗ
	               |	Справочник.НазначенияИспользования КАК НазначенияИспользования
	               |ГДЕ
	               |	НазначенияИспользования.Владелец = &Владелец
	               |	И НазначенияИспользования.СрокПолезногоИспользования = &срок
	               |ORDER BY ind	
				   |  ";          
	
	Выб =ЗАпрос.Выполнить().Выбрать();	
	Если Выб.Следующий() ТОгда
		Возврат Выб.ссылка;
	КонецЕсли;  
	
	Обк = Справочники.НазначенияИспользования.СоздатьЭлемент();
	Обк.Владелец = ном;             
	
	п = СтрПОлучитьСтроку(СтрЗаменить(ЧислоПрописью(Срок,"","месяц, месяца, месяцев, м, день, дня, дней, м, 0")," ",Символы.ПС),2);
	Обк.Наименование = ""+Срок+" "+п;   
	Обк.СрокПолезногоИспользования = Срок;
	Обк.Количество = 1; 
	обк.СпособПогашенияСтоимости = Перечисления.СпособыПогашенияСтоимости.Линейный;
	Обк.Записать();
	
	Возврат Обк.ссылка;
	
	
	
КонецФункции

Процедура КоррСткРек(Стк)

	Если Стк.свойство("ЦенаВключаетНДС") Тогда
		Стк.вставить("СуммаВключаетНДС",Стк.ЦенаВключаетНДС);
	КонецЕсЛИ;   
	Стк.удалить("БанковскийСчетОрганизации");
	
КонецПроцедуры

Процедура ПометитьНаУдалениеДокумент(видДок,идДок)
	
	сс = Документы[видДок].Получитьссылку(ИдДок); 
	Если Найти(СокрлП(сс),"не найден")=0 Тогда  
		Если сс.ПометкаУдаления =Ложь ТОгда
			Обк = сс.ПолучитьОбъект();
			Обк.установитьПометкуУдаления(Истина);
		КонецЕСлИ;
	КонецЕСЛИ;

КонецПроцедуры

Процедура ПроверкаВидДОк(Стк) 
	
	Если нрег(Стк.ВидДок) = "списаниетоваров" Тогда
		Если стк.ВидХозОПерации = "Передача в эксплуатацию" Тогда
			Стк.вставить("ВидДОк","ПередачаМатериаловВЭксплуатацию");
			ПометитьНаУдалениеДокумент("ТребованиеНакладная",Стк.ИдДок);
			
			Стк.ТабЧасть.вставить("Спецодежда",Стк.ТабЧасть.Товары); 
			текТабЧсть = Стк.ТабЧасть.Спецодежда;
			
		Иначе
			Стк.вставить("ВидДОк","ТребованиеНакладная");
			ПометитьНаУдалениеДокумент("ПередачаМатериаловВЭксплуатацию",Стк.ИдДок);
			
			Стк.ТабЧасть.вставить("Материалы",Стк.ТабЧасть.Товары); 
			текТабЧсть = Стк.ТабЧасть.Материалы;
			
		КонецеСЛИ; 
		
		текТабЧсть.Колонки.ФизическоеЛицо.Имя 	  = "Физлицо";
		текТабЧсть.Колонки.ФизическоеЛицо_Имя.Имя = "Физлицо_Имя";
		текТабЧсть.Колонки.ФизическоеЛицо_Код.Имя = "Физлицо_Код";
		
	КонецеслИ;
		
	
КонецПроцедуры

Процедура ЗагрузитьОбк(итМас,ЗагружатьТолькоНовые=Ложь)  
	
	УстановитьПривилегированныйРежим(Истина);
	
	СооОН = Новый Соответствие; //Объект не найден, чтобы догрузить   
	сооМетаОбк  = Новый Соответствие; //список реквизитов по видам объектов
	
	для каждого Стк из итМас Цикл
		
		
		ЭтоГРп = Неопределено;
		Если Стк.свойство("ВидДок") Тогда  
			ПроверкаВидДок(Стк); 
			
			Стк.вставить("ВидОбк",стк.виддок);
			
			сс = Документы[Стк.видДок].Получитьссылку(Стк.ИдДок);
			Если Найти(СокрлП(сс),"не найден")<>0 Тогда
				ОбкДок = Документы[Стк.видДок].СоздатьДокумент();
				ОбкДок.УстановитьСсылкуНового(сс);
			ИНачеЕсли ЗагружатьТолькоНовые ТОгда
				продолжить;
			ИначеЕсли РегистрыСведений.ксДокументПроверен.ПолучитьСостояниеПроверкиДокумента(сс,Истина) Тогда
				Сообщить("Не загружен документ: "+сс+" установлен статус проверен.");
				продолжить;
			ИНаче   
				обкДок = сс.ПолучитьОбъект();  
				если обкдок.пометкаудаления = истина тогда
					обкдок.УстановитьПометкуУдаления(ложь);	
				конецесли;
			КонецЕсЛИ;    
			ОбкДок.Проведен 			= Ложь; 
		ИНачеЕсли Стк.свойство("ВидСпр") Тогда
			Стк.вставить("ВидОбк",стк.ВидСпр);
			
			Если нрег(Стк.ВидСпр) = "номенклатура" ТОгда 
				сс = НайтиНоменклатуру(Стк.ИдДок,стк.наименование);
			ИНаче
				сс = Справочники[Стк.ВидСпр].Получитьссылку(Стк.ИдДок);
			КонецЕСЛИ;
			
				Стк.Свойство("ЭтоГруппа",ЭтоГРп);
			Если Найти(СокрлП(сс),"не найден")<>0 Тогда 
				Если ЭтоГРп=Неопределено или ЭтоГРп = Ложь ТОгда
					ОбкДок = Справочники[Стк.ВидСпр].СоздатьЭлемент();
				ИНаче
					ОбкДок = Справочники[Стк.ВидСпр].СоздатьГруппу();
				КонецеслИ;
				ОбкДок.УстановитьСсылкуНового(сс);
			ИНачеЕсли ЗагружатьТолькоНовые ТОгда
				продолжить;
			ИНаче
				обкДок = сс.ПолучитьОбъект();
			КонецЕсЛИ;  
			
		КонецЕсли;   
		
		Если ЭтоГРп = Истина Тогда  
			грпСтк = Новый Структура("Наименование,Код,Родитель,ВидСпр");
			ЗаполнитьЗначенияСвойств(грпСтк,Стк);
			
			ЗаполнитьЗначенияСвойств(ОбкДОк,грпСтк); 
			ЗаполнитьПоGUID(обкДок,грпСтк,СооОН,сооМетаОбк);
			
		ИНаче
			КоррСткРек(Стк);
			
			ЗаполнитьЗначенияСвойств(ОбкДОк,Стк); 
			ЗаполнитьПоGUID(обкДок,Стк,СооОН,сооМетаОбк);
			
			//Контрагенты - партнеры
			Если Стк.Свойство("Контрагент") Тогда  
				Если ОбкДок.МЕтаданные().Реквизиты.Найти("Контрагент")<>Неопределено Тогда
					ЕСли Найти(СокрлП(ОбкДОк.Контрагент),"не найден")<>0 Тогда
						обкДок.Контрагент = НайтиКонтрагента(ОбкДОк.Контрагент,Стк.КонтрагентИНН,Стк.КонтрагентКПП,Стк.КонтрагентИмя,СооОН);	
					КонецеСЛИ;      
				КонецеСЛИ;      
			КонецесЛИ;   
			
			
			Если Стк.свойство("ТабЧасть") Тогда
				
				ДЛя каждого эл из Стк.ТабЧасть Цикл                                                                  
					Если обкДок.метаданные().ТабличныеЧасти.Найти(Эл.Ключ)=Неопределено Тогда ПродолжитЬ; КонецесЛИ;
					КоррТабЧасть(Эл.Значение,Эл.Ключ,сооОН);
					обкДок[Эл.Ключ].Загрузить(Эл.Значение);
				КонецЦикла; 
				
				ДопКорТабЧасть(ОбкДок,Стк);
				
			КонецеслИ;  
			
			ДопКоррРеквизитыОбъекта(ОбкДок,Стк);
			
		КонецЕсли; //ЭтоГруппа
		
		ОбкДок.ОбменДанными.Загрузка = Истина;
		ОбкДок.Записать();  
		
		ДобавитьВСписокЗагруженныхОБк(сс);
		//Если Стк.Свойство("Лог") ТОгда 
			РегистрыСведений.ксРегИзмененийИзФормы.ЗаписатьЛогЗагрузкиИзДругойБазы(сс,стк.идДок,стк.хэш,стк.лог);	
		//КонецЕСЛИ;
		Сообщить(обкДок.ссылка);
		
		
		Если Стк.ПометкаУдаления<>ОбкДок.ПометкаУдаления ТОгда
			ОбкДок.УставитьПометкуУдаления(Стк.ПометкаУдаления);
		КонецеслИ;
		
		
		//Если Стк.свойство("ВидДок") Тогда  
		//	Если ОбкДок.Проведен Тогда
		//		ОбкДок.Записать(РежимЗаписиДокумента.ОтменаПроведения);
		//	КонецеслИ;
		//КонецеСЛИ;
		
		
		ЕСли Стк.Свойство("РегБух") ТОгда
			обкДок.Движения.Хозрасчетный.Загрузить(Стк.РегБух);
			
			обкДок.Движения.Хозрасчетный.Записать();
		КонецеслИ;
		
	КонецЦикла;
	
	
	ЗагрузитьСооОН(сооОН);
	
	
КонецПроцедуры  

Процедура ДобавитьВСписокЗагруженныхОБк(сс)
	//НовСтр = ЗагруженнныеОбъекты.Добавить();
	//новСтр.ЗагрОбк = сс;
	//новСтр.ДатаЗагрузки = ТекущаяДата();
	
КонецПроцедуры

Процедура ДопКорТабЧасть(ОбкДок,Стк)
	
	Если Стк.ВидОбк = "ПоступлениеТоваровУслуг" Тогда
		КоррТоварыДокПост(ОбкДок.ТОвары);
	ИначеЕсли Стк.ВидОбк = "РеализацияТоваровУслуг" Тогда
		КоррТоварыДокРеал(ОбкДок.ТОвары,ОбкДок);
	ИначеЕсли Стк.ВидОбк = "ПеремещениеТоваров" Тогда
		КоррТоварыДокПерем(ОбкДок.ТОвары,ОбкДок);
	ИначеЕсли Стк.ВидОбк = "ТребованиеНакладная" Тогда
		КоррТоварыДокТребНакл(ОбкДок.Материалы,ОбкДок);
	ИначеЕсли Стк.ВидОбк = "ПередачаМатериаловВЭксплуатацию" Тогда
		КоррТоварыВводВЭкспл(ОбкДок,Стк);
	КонецЕСЛИ;
	
КонецПроцедуры

Процедура ДопКоррРеквизитыОбъекта(ОбкДок,Стк)
	
	//ЗаполнитьПодрПоСкладу(ОбкДок);
	
	Если нрег(Стк.ВидОбк) = "поступлениетоваровуслуг" Тогда
		РеквизитыДОкПост(ОбкДок,Стк);
	ИначеЕсли нрег(Стк.ВидОбк) = "реализациятоваровуслуг" Тогда
		РеквизитыДОкРеал(ОбкДок,Стк);
	ИначеЕсли нрег(Стк.ВидОбк) = "номенклатура" Тогда
		РеквизитыНоменклатура(ОбкДок,Стк);     
	ИначеЕсли нрег(Стк.ВидОбк) = "склады" Тогда
		РеквизитыСклад(ОбкДок,Стк);
	ИначеЕсли нрег(Стк.ВидОбк) = "перемещениетоваров" Тогда
		РеквизитыДОкПерем(ОбкДок,Стк);
	КонецесЛИ;
	
	
КонецПроцедуры  

//=======================================================
Функция НайтиРелевантныйДоговор(Контрагент,Склад,Дт=Неопределено,Вид = "Документ.ПоступлениеТоваровУслуг") Экспорт
	
	Если ЗначениеЗаполнено(Контрагент)=Ложь ТОгда Возврат Справочники.ДоговорыКонтрагентов.ПустаяСсылка(); КонецЕсли;
	
	Запрос = новый Запрос;
	Запрос.УстановитьПараметр("Контрагент",Контрагент);
	Запрос.УстановитьПараметр("Склад",Склад);
	Если Дт=Неопределено Тогда
		Дт = ТекущаяДАта();
	КонецеСЛИ;
	Запрос.УстановитьПараметр("Дт",Дт);
	
	Запрос.Текст = "ВЫБРАТЬ TOP 1
	               |	ПоступлениеТоваровУслуг.ДоговорКонтрагента КАК ДоговорКонтрагента
	               |ИЗ
	               |	Документ.ПоступлениеТоваровУслуг КАК ПоступлениеТоваровУслуг
	               |INNER JOIN Справочник.ДоговорыКонтрагентов СпрДог ON  СпрДог.ссылка = ПоступлениеТоваровУслуг.ДоговорКонтрагента
				   |                                                 and (СпрДог.СрокДействия >= &Дт or СпрДог.СрокДействия = ДатаВремя(1,1,1)) 
	               |ГДЕ
	               |	ПоступлениеТоваровУслуг.Проведен = Истина
	               |	И ПоступлениеТоваровУслуг.Контрагент = &Контрагент
	               |	И ПоступлениеТоваровУслуг.Склад = &Склад или &Склад = Неопределено
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	ПоступлениеТоваровУслуг.Дата УБЫВ";
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст,"Документ.ПоступлениеТоваровУслуг",Вид);
	
	Выб = Запрос.Выполнить().Выбрать();
	Если Выб.Следующий() Тогда
		Возврат Выб.ДоговорКонтрагента;
	КонецЕсли;  
	
	
	//Любой по виду
	Если Вид = "Документ.ПоступлениеТоваровУслуг" ТОгда
		Запрос.УстановитьПараметр("ВидДоговора",Перечисления.ВидыДоговоровКонтрагентов.СПоставщиком);
	ИНаче
		Запрос.УстановитьПараметр("ВидДоговора",Перечисления.ВидыДоговоровКонтрагентов.СПокупателем);
	КонецеслИ;
	
	Запрос.Текст = "ВЫБРАТЬ
	|	ДоговорыКонтрагентов.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
	|ГДЕ
	|	ДоговорыКонтрагентов.Владелец = &Контрагент
	|	И ДоговорыКонтрагентов.ВидДоговора = &ВидДоговора";
	
	
	Выб = Запрос.Выполнить().Выбрать();
	Если Выб.Следующий() Тогда
		Возврат Выб.Ссылка;
	КонецЕсли;  
	
	
	//Ничего не нашли	
	Возврат Справочники.ДоговорыКонтрагентов.ПустаяСсылка(); 
	
КонецФункции
//=======================================================

Процедура РеквизитыДОкПост(Обк,стк)
	
	Обк.ВидОперации = Перечисления.ВидыОперацийПоступлениеТоваровУслуг.Товары;
	Обк.ВалютаДокумента = Справочники.Валюты.НайтиПоКоду("643"); 
	Обк.СпособЗачетаАвансов = Перечисления.СпособыЗачетаАвансов.Автоматически;
	Обк.СчетУчетаРасчетовСКонтрагентом = ПланыСчетов.Хозрасчетный.РасчетыСПоставщиками;
	Обк.СчетУчетаРасчетовПоАвансам     = ПланыСчетов.Хозрасчетный.РасчетыПоАвансамВыданным;  
	
	Если Обк.ДоговорКонтрагента.Владелец <> Обк.Контрагент Тогда
		Обк.ДоговорКонтрагента = Неопределено;	
	КонецЕсЛИ;   
	Если ЗначениеЗаполнено(Обк.ДоговорКонтрагента)=Ложь Тогда
		 Обк.ДоговорКонтрагента = НайтиРелевантныйДоговор(Обк.Контрагент,Обк.склад,Обк.Дата);
	КонецеСЛИ;
	
КонецПроцедуры

Процедура РеквизитыДОкПерем(Обк,стк)
	
	
	Если ЗначениеЗаполнено(Обк.ПодразделениеОтправитель) = Ложь Тогда
		Обк.ПодразделениеОтправитель = Обк.СкладОтправитель.ПодразделениеОрганизации;	
	КонецесЛИ;  
	
	Если ЗначениеЗаполнено(Обк.ПодразделениеПолучатель) = Ложь Тогда
		Обк.ПодразделениеПолучатель = Обк.СкладПолучатель.ПодразделениеОрганизации;	
	КонецесЛИ;  
	
	
КонецПроцедуры

Процедура РеквизитыДОкРеал(Обк,стк)
	
	Обк.ВидОперации = Перечисления.ВидыОперацийРеализацияТоваров.Товары;
	Обк.ВалютаДокумента = Справочники.Валюты.НайтиПоКоду("643"); 
	Обк.СпособЗачетаАвансов = Перечисления.СпособыЗачетаАвансов.Автоматически;
	
	
	Если Обк.ДоговорКонтрагента.Владелец <> Обк.Контрагент Тогда
		Обк.ДоговорКонтрагента = Неопределено;	
	КонецЕсЛИ;   
	Если ЗначениеЗаполнено(Обк.ДоговорКонтрагента)=Ложь Тогда
		Обк.ДоговорКонтрагента = НайтиРелевантныйДоговор(Обк.Контрагент,Обк.склад,Обк.Дата,"Документ.РеализацияТоваровУслуг");
	КонецеСЛИ;
	
	Если ЗначениеЗаполнено(Обк.ПодразделениеОрганизации) = Ложь Тогда
		Обк.ПодразделениеОрганизации = Обк.склад.ПодразделениеОрганизации;	
	КонецесЛИ;  
	
	//Если ЭтоНашСотрудник(Обк.Контрагент) ТОгда
	//	Обк.СчетУчетаРасчетовСКонтрагентом = ПланыСчетов.Хозрасчетный.РасчетыПоПрочимОперациям;
	//	Обк.СчетУчетаРасчетовПоАвансам     = ПланыСчетов.Хозрасчетный.РасчетыПоПрочимОперациям; 
	//ИНАче
		Обк.СчетУчетаРасчетовСКонтрагентом = ПланыСчетов.Хозрасчетный.РасчетыСПокупателями;
		Обк.СчетУчетаРасчетовПоАвансам     = ПланыСчетов.Хозрасчетный.РасчетыПоАвансамПолученным; 
	//КонецесЛИ;
	
КонецПроцедуры

Процедура РеквизитыНоменклатура(Обк,Стк)  
	
	Если ЗначениеЗаполнено(Обк.ссылка)=ЛОжь 
		или Найти(СокрлП(Обк.ссылка),"не найден")<>0 Тогда
		пСс = Справочники.Номенклатура.НайтиПоКоду(Обк.Код);
		Если пСС.Пустая()=Ложь Тогда
			Обк.код = "";
		КонецеСЛИ;
	КонецеСЛИ;
	
	Соо = Новый Соответствие;
	Если ЗначениеЗаполнено(Обк.ВидСтавкиНДС)=Ложь Тогда
		Обк.ВидСтавкиНДС = Перечисления.ВидыСтавокНДС.Общая;	                               
	КонецесЛИ;             
	
	Если Стк.свойство("ЕдИзм") Тогда
		Обк.ЕдиницаИзмерения = НАйтиЕдИзм(Стк.ЕдИзм,Стк.ЕдИзмКод,соо);
	КонецЕслИ;
	Если ЗначениеЗаполнено(Обк.ЕдиницаИзмерения)=Ложь Тогда 
		Обк.ЕдиницаИзмерения = НАйтиЕдИзм("шт","796",соо);
	КонецесЛИ;  
	
	Если Стк.Свойство("ВидНоменклатуры") и стк.ВидНоменклатуры = "Запчасти и материалы" Тогда
		обк.ВидНоменклатуры = Справочники.ВидыНоменклатуры.НайтиПоНаименованию("Запчасти",истина);	
	КонецесЛи; 
	Если ЗначениеЗаполнено(Обк.ВидНоменклатуры) = Ложь Тогда
		Обк.ВидНоменклатуры = Справочники.ВидыНоменклатуры.НайтиПоНаименованию("Прочие ТМЦ",истина);
	КонецесЛИ;
	
КонецПроцедуры

Процедура РеквизитыСклад(Обк,Стк)  
	
	Если ЗначениеЗаполнено(Обк.ТипСклада)=Ложь Тогда
		Обк.ТипСклада = Перечисления.ТипыСкладов.ОптовыйСклад;	                               
	КонецесЛИ;             
	
	Если ЗначениеЗаполнено(Обк.ТипЦенРозничнойТорговли)=Ложь Тогда       
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ TOP 1
		|	
		|	Склады.ТипЦенРозничнойТорговли КАК ТипЦенРозничнойТорговли,
		|	СУММА(1) КАК кол
		|ИЗ
		|	Справочник.Склады КАК Склады
		|ГДЕ
		|	Склады.ТипЦенРозничнойТорговли <> Значение(Справочник.ТипыЦенНоменклатуры.Пустаяссылка)
		|
		|СГРУППИРОВАТЬ ПО
		|	Склады.ТипЦенРозничнойТорговли
		|
		|УПОРЯДОЧИТЬ ПО
		|	 кол
	 	|";
		Выборка = Запрос.Выполнить().Выбрать(); 
		Если Выборка.Следующий() Тогда
			Обк.ТипЦенРозничнойТорговли = Выборка.ТипЦенРозничнойТорговли;
		КонецеслИ;
	КонецесЛИ;  
	
КонецПроцедуры

//=======================================================

Процедура ЗагрузитьСооОН(сооОН) Экспорт  
	
	сткВид = Новый Структура;
	Для каждого элСоо из сооОН Цикл  
		Если нрег(элСоо.значение) = "банковскиесчета" 
		или  нрег(элСоо.значение) = "пользователи" Тогда
			Продолжить; 
		КонецеСЛИ;
		
		сткВид.Вставить(элСоо.значение);
	Конеццикла;                       
	
	для каждого элВид из сткВид Цикл
		
		мас = новый Массив;
		Для каждого элСоо из сооОН Цикл 
			Если элВид.ключ <>элСоо.Значение Тогда ПродолжитЬ; КонецЕсли;
			мас.Добавить(элСоо.ключ);
		Конеццикла;    
		
		Стк = Новый Структура("ВидСпр",элВид.ключ);  
		ЗагрузитьМасСС(мас,Стк);
		
	КонецЦикла;	
	
КонецПроцедуры

Функция НайтиКонтрагента(КА,иннКА,кппКА,имяКА,сооОН)   
	
	Если Найти(СокрлП(КА),"не найден")=0 ТОгда
		Возврат КА;
	КонецесЛИ;
	
	сооОН.удалить(КА.уникальныйИдентификатор());
	Запрос = новый Запрос;    
	Запрос.УстановитьПараметр("ИНН",	иннКА);
	Запрос.УстановитьПараметр("КПП",	кппКА);   
	Запрос.УстановитьПараметр("имяКА",	имяКА);   
	
	Если СокрЛП(иннКА)<>"" Тогда
		Запрос.Текст = "ВЫБРАТЬ TOP 1
		|	Контрагенты.Ссылка КАК Ссылка,
		|    CASE WHEN Контрагенты.КПП = &КПП THEN 0 ELSE 1 END indKPP
		|ИЗ
		|	Справочник.Контрагенты КАК Контрагенты
		|ГДЕ
		|	Контрагенты.ИНН = &ИНН
		|и  Контрагенты.ПометкаУдаления = Ложь
		|
		|УПОРЯДОЧИТЬ ПО
		|	indKPP";
		
		
		Выб = ЗАпрос.Выполнить().Выбрать();
		Если Выб.Следующий() Тогда  
			Возврат Выб.ссылка;
		КонецЕСЛИ;                  
	КонецеслИ;
	
	Если СокрЛП(имяКА)<>"" Тогда
		Запрос.Текст = "ВЫБРАТЬ TOP 1
		|	Контрагенты.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.Контрагенты КАК Контрагенты
		|ГДЕ
		|	Контрагенты.Наименование = &имяКА
		|и  Контрагенты.ПометкаУдаления = Ложь
		|
		|";
		
		Выб = ЗАпрос.Выполнить().Выбрать();
		Если Выб.Следующий() Тогда  
			Возврат Выб.ссылка;
		КонецЕСЛИ;  
		
		
		Обк = Справочники.Контрагенты.СоздатьЭлемент();
		Обк.УстановитьСсылкуНового(КА);
		Обк.Наименование = имяКА;
		обк.НаименованиеПолное = имяКА;
		Если СтрДлина(иннКА) = 10 ТОгда
			Обк.ЮридическоеФизическоеЛицо=Перечисления.ЮридическоеФизическоеЛицо.ЮридическоеЛицо;
		ИНАче
			Обк.ЮридическоеФизическоеЛицо=Перечисления.ЮридическоеФизическоеЛицо.ФизическоеЛицо;
		КонецеслИ;   
		Обк.ИНН = иннКА;
		обк.кпп = кппКА;
		Обк.Записать(); 
		Сообщить("Записан новый контрагент "+обк.ссылка);
		Возврат ОБк.ссылка;
		
		
	КонецеслИ;  
	
	Возврат КА;
	
	//--
	//Стк = Новый Структура("ВидСпр","Контрагенты");  
	//ПАр = Новый Структура();
	//Пар.Вставить("Ссылка",КА);
	//Стк.Вставить("пар",пар);   
	//
	//итМАс = СделатьЗапрос("SYNHRO",Стк);  
	//ЗагрузитьОбк(итМас);
	
КонецФункции

Функция НайтиСпр(ссСпр,имяОбк=Неопределено)
	
	Если имяОбк<>Неопределено Тогда  
		пТип = СтрЗаменить(XMLТипЗнч(ссСпр).ИмяТипа,".",Символы.ПС);
		видСпр = СтрПолучитьСтроку(пТип,2);
		
		//Планы Видов характеристик
		Если СтрПолучитьСтроку(пТип,1) = "ChartOfCharacteristicTypesRef" Тогда
			Возврат ПланыВидовХарактеристик[видСпр].НАйтиПоНаименованию(имяОбк,Истина);
		КонецЕслИ;	
			
		сс = Справочники[видСпр].НАйтиПоНаименованию(имяОбк,Истина);
		Если сс.Пустая()=ЛОжь Тогда
			Возврат сс;
		КонецеслИ;
	КонецЕсли;
	

	Возврат Неопределено;
	
	//--
	//Стк = Новый Структура("ВидСпр",ссСпр.Метаданные().Имя);  
	//ПАр = Новый Структура();
	//Пар.Вставить("Ссылка",ссСпр);
	//Стк.Вставить("пар",пар);   
	//
	//итМАс = СделатьЗапрос("SYNHRO",Стк);  
	//ЗагрузитьОбк(итМас); 
	//
	//Возврат ссСпр;
	
КонецФункции  

Функция НАйтиЕдИзм(Имя,Код,соо)
	
	п = Соо.Получить(Имя);
	Если п <> Неопределено Тогда
		Возврат п;
	КонецеСЛИ;
	
	
	сс = Справочники.КлассификаторЕдиницИзмерения.НайтиПоНаименованию(имя,истина);
	Если сс.Пустая() Тогда
		сс = Справочники.КлассификаторЕдиницИзмерения.НайтиПоКоду(Код);
		Если сс.Пустая() Тогда
			
			обк = Справочники.КлассификаторЕдиницИзмерения.СоздатьЭлемент();
			обк.Наименование=Имя;
			обк.Код = Код;
			обк.НаименованиеПолное = имя;
			Обк.Записать();
			
			сс = Обк.ссылка;
			
		КонецесЛИ;  
	КонецесЛИ;  
	
	
	Соо.вставить(Имя,сс);
	Возврат сс;
	
	
КонецФункции

Функция НайтиСтавкуНДС(перНДС,Соо)
	п = Соо.Получить(перНДС);
	ЕСли п=Неопределено Тогда
		п =  XMLЗначение(Тип("ПеречислениеСсылка.СтавкиНДС"),перНДС);                 
		Соо.Вставить(перНДС,п);
	КонецЕСЛИ;   
	
	Возврат п;
	
КонецФункции

Процедура ТблНайтиНоменклатуру(Тбл,СооОН)      
	
	
	УстановитьПривилегированныйРежим(Истина);  
	
	ЕстьВидНоменклатуры = Тбл.Колонки.НАйти("ВидНоменклатуры")<>Неопределено;
	ЕстьКодНоменклатуры = Тбл.Колонки.НАйти("КодНом")<>Неопределено;
	
	
	сч1005 = ПланыСчетов.Хозрасчетный.ЗапасныеЧасти;
	сч1006 = ПланыСчетов.Хозрасчетный.ПрочиеМатериалы; 
	
	
	Для каждого Стр из Тбл Цикл  
		Стр.номенклатура = СокрлП(Стр.Номенклатура);
	КонецЦикла;
	
	
	Запрос = Новый Запрос; 
	Запрос.УстановитьПараметр("Мас",Тбл.выгрузитьКОлонку("Номенклатура"));
	Запрос.Текст = "ВЫБРАТЬ
	               |	ПубличныеИдентификаторыСинхронизируемыхОбъектов.Ссылка КАК Ссылка,
				   |    СпрНом.Код кодНом,
				   |    Идентификатор
	               |ИЗ
	               |	РегистрСведений.ПубличныеИдентификаторыСинхронизируемыхОбъектов КАК ПубличныеИдентификаторыСинхронизируемыхОбъектов
				   |INNER JOIN Справочник.Номенклатура СпрНом ON СпрНом.ссылка = ПубличныеИдентификаторыСинхронизируемыхОбъектов.Ссылка
	               |ГДЕ
	               |	ПубличныеИдентификаторыСинхронизируемыхОбъектов.Идентификатор В(&мас)
				   |
				   |
				   |";
	
	тбНом = Запрос.Выполнить().выгрузить();   
	тбНом.Индексы.Добавить("Идентификатор"); 
	
	Для каждого Стр из ТБл Цикл
		нс = тбНом.Найти(стр.номенклатура,"Идентификатор");
		Если нс <> Неопределено Тогда //и Найти(СокрлП(нс.ссылка),"не найден")=0 Тогда
			Стр.Номенклатура = нс.ссылка;
			Если ЕстьКодНоменклатуры ТОгда
				Стр.кодНом = нс.кодНом;
			Конецесли;
		ИНаче                  
			пНом = Новый УникальныйИдентификатор(Стр.номенклатура); 
			сооОН.вставить(пНом,"Номенклатура");
			Стр.номенклатура = Справочники.Номенклатура.ПолучитьСсылку(пНом);  
		КонецЕсли;   
		
		ЕСли ЕстьВидНоменклатуры=Ложь Тогда Продолжить; КонецЕсли;
		
		ЕСли Стр.ВидНоменклатуры = "Запчасти и материалы" Тогда
			Стр.счетУчета = сч1005;
		ИНаче
			Стр.счетУчета = сч1006;
		КонецЕслИ;  
		
	КонецЦикла;
	
	
	
	
КонецПроцедуры  

Функция НайтиНоменклатуру(ГУИД,имя)
	
	УстановитьПривилегированныйРежим(Истина);  
	
	Запрос = Новый Запрос; 
	Запрос.УстановитьПараметр("Мас",СокрлП(ГУИД));
	Запрос.Текст = "ВЫБРАТЬ
	               |	ПубличныеИдентификаторыСинхронизируемыхОбъектов.Ссылка КАК Ссылка,
				   |    Идентификатор
	               |ИЗ
	               |	РегистрСведений.ПубличныеИдентификаторыСинхронизируемыхОбъектов КАК ПубличныеИдентификаторыСинхронизируемыхОбъектов
	               |ГДЕ
	               |	ПубличныеИдентификаторыСинхронизируемыхОбъектов.Идентификатор В(&мас)";  
	Выб = Запрос.Выполнить().Выбрать();
	Если Выб.Следующий() ТОгда  
		Если  Найти(СокрЛП(Выб.ссылка),"не найден")=0 Тогда
			Возврат Выб.ссылка;  
		КонецЕслИ;
	КонецЕСЛИ;
	
	
	сс = Справочники.Номенклатура.ПолучитьСсылку(ГУИД); 
	Если Найти(СокрЛП(сс),"не найден")=0 Тогда
		Тексс = сс;
	Иначе
		п = Справочники.Номенклатура.НайтиПоНаименованию(имя,истина); 
		Если п.Пустая() ТОгда
			тексс = сс;
		ИНаче
			тексс = п;
		КонецесЛИ;
	КонецесЛИ;    
	
	
	зап = РегистрыСведений.ПубличныеИдентификаторыСинхронизируемыхОбъектов.СоздатьМенеджерЗаписи();
	зап.Идентификатор = ГУИД;
	зап.ссылка = тексс;
	зап.УзелИнформационнойБазы = ПланыОбмена.СинхронизацияДанныхЧерезУниверсальныйФормат.НайтиПоНаименованию("ERP");
	зап.Записать();
	
	 Возврат тексс;  
	
КонецФункции  

Процедура ПроверитьНаличиеКолонок(ТБл,СтрКол)
	
	стрКол = СтрЗаменить(стрКол,",",Символы.ПС);
	
	Для а=1 по СтрЧислоСтрок(стрКол) Цикл
		п = СтрПолучитьСтроку(стрКол,а);
		Если тбл.Колонки.НАйти(п)=Неопределено Тогда
			тбл.Колонки.Добавить(п);
		КонецЕслИ;
	Конеццикла;
	
КонецПроцедуры

Процедура КоррТабЧасть(Тбл,имяТаб,СооОН)    
	 
	Если Тбл.колонки.Найти("Номенклатура")<>Неопределено Тогда  
		
		ПроверитьНаличиеКолонок(ТБл,"ЕдиницаИзмерения,ставкаНДС,счетучета");
		
		ТБлНайтиНоменклатуру(Тбл,СооОН);
		
		Соо = Новый Соответствие;
		ЕстьЕД = Тбл.колонки.Найти("ЕдИзм")<>Неопределено; 
		ЕстьСтавкаНДС = Тбл.колонки.Найти("стНДС")<>Неопределено;
		
		Для каждого Стр из Тбл Цикл
			Если ЕстьЕД ТОгда   
				Стр.ЕдиницаИзмерения = НАйтиЕдИзм(Стр.ЕдИзм,Стр.ЕдИзмКод,соо);
			КонецеСЛИ;  
			Если ЕстьСтавкаНДС Тогда
				Стр.ставкаНДС = НайтиСтавкуНДС(Стр.стНДС,Соо); 
			КонецеслИ;
		КонецЦикла; 
		
		Если  Тбл.колонки.Найти("Партия")<>Неопределено Тогда
			ТБл.ЗаполнитьЗначения(Неопределено,"Партия");
		КонецесЛИ;
		
	КонецЕсли;  
	
	
	
	//Проверка поиск по наименованию
	масКол = новый МАссив;
	Для каждого Кол из Тбл.Колонки Цикл
		Если прав(нрег(Кол.Имя),4)= "_имя" Тогда
			масКол.Добавить(СтрЗаменить(нрег(кол.имя),"_имя",""));
		КонецЕсли;
	КонецЦикла; 
	
	Если масКол.Количество() <> 0 ТОгда
		Для каждого Стр из Тбл Цикл 
			Для каждого элИмя из масКол Цикл  
				
				Если элИмя = "физлицо" Тогда
					Стр.физлицо = Справочники.ФизическиеЛица.ПолучитьСсылку(Стр.физлицо);
				КонецЕслИ;
				
				Если НАйти(Сокрлп(Стр[элИмя]),"не найден")<>0 или ЗначениеЗаполнено(Стр[элИмя])=Ложь Тогда
					Стр[элИмя] = НайтиСпр(Стр[элИмя],Стр[элИмя+"_имя"]);
				КонецеслИ;                      
			КонецЦикла;
		КонецЦикла;     
	КонецеСЛИ;    
	
	
	
	
	
	
	
	
	//Если имяТаб = "КонтактнаяИнформация" Тогда
	//	Для каждого Стр из Тбл Цикл
	//		Если НАйти(Сокрлп(Стр.Вид),"не найден")<>0 Тогда
	//			Стр.Вид = НайтиСпр(Стр.Вид,Стр.ВидИмя);
	//		КонецеслИ;
	//		Если НАйти(Сокрлп(Стр.ВидДляСписка),"не найден")<>0 Тогда
	//			Стр.ВидДляСписка = НайтиСпр(Стр.ВидДляСписка,Стр.ВидИмя);
	//		КонецеслИ;
	//	КонецЦикла;     
	//КонецЕсли;    
	
КонецПроцедуры


