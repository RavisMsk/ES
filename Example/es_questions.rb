# Questions

startQuestionChain

addQuestion do
	text 'Необходим ли framework для проведения тестов?'
	criterion 'Testing Framework'
	answer 'Да', :chain1
	answer 'Нет', 'Отсутствует'
end

addQuestion do
	chained :chain1
	text 'Должны они быть встроенными или допускается модульный вариант?'
	criterion 'Testing Framework'
	answer 'Встроенные', 'Встроенный'
	answer 'Модульный', 'Модульный'
end

endQuestionChain

addQuestion do
	text 'Необходима ли полноценная поддержка архитектуры MVC?'
	criterion 'Архитектура MVC'
	answer 'Да', 'Есть'
	answer 'Нет', 'Нет'
end

startQuestionChain

addQuestion do
	text 'Нужен ли при работе ORM или допускается возможность разработки сервера без его использования?'
	criterion 'Наличие ORM'
	answer 'Требуется ORM', :chain2
	answer 'Не требуется', 'Отсутствует'
end	

addQuestion do
	chained :chain2
	text 'Необходимо ли наличие встроенного ORM?'
	criterion 'Наличие ORM'
	answer 'Необходимо', 'Встроенный'
	answer 'Не нужен', 'Модульный'
end

endQuestionChain

startQuestionChain

addQuestion do
	text 'Нужна ли система шаблонов?'
	criterion 'Система шаблонов'
	answer 'Да', :chain3
	answer 'Нет', 'Отсутствует'
end

addQuestion do
	chained :chain3
	text 'Должна ли она быть встроена в framework или может подключаться в виде стороннего модуля?'
	criterion 'Система шаблонов'
	answer 'Встроенная', 'Встроенная'
	answer 'Модульная', 'Модульная'
end

endQuestionChain

addQuestion do
	text 'Сервер будет работать с долго-живущими соединениями?(WebSockets)'
	criterion 'Производительная работа с WebSockets'
	answer 'Да', 'Да'
	answer 'Нет', 'Нет'
end