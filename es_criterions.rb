addCriterion 'Testing Framework' do
	variant 'Встроенный'
	variant 'Модульный'
	variant 'Отсутствует'
end

addCriterion 'Архитектура MVC' do
	variant 'Есть'
	variant 'Нет'
end

addCriterion 'Система шаблонов' do
	variant 'Встроенная'
	variant 'Модульная'
	variant 'Отсутствует'
end

addCriterion 'Наличие ORM' do
	variant 'Встроенный'
	variant 'Модульный'
	variant 'Отсутствует'
end

addCriterion 'Производительная работа с WebSockets' do
	variant 'Да'
	variant 'Нет'
end

addCriterion 'Routing система' do
	variant 'RESTful+Regexp'
	variant 'RESTful'
	variant 'Regexp'
	variant 'None'
end

addCriterion 'Возможность написания внутреннего DSL' do
	variant 'Возможно'
	variant 'Нет'
end

addCriterion 'Hot Code Upgrade' do
	variant 'Поддерживается'
	variant 'Нет'
end

addCriterion 'Необходимость стороннего front-end web-сервера' do
	variant 'Необходим всегда'
	variant 'Есть dev-сервер'
	variant 'Есть полноценный встроенный web-сервер'
end

addCriterion 'Язык программирования' do
	variant 'Javascript'
	variant 'Ruby'
	variant 'Python'
	variant 'Erlang'
	variant 'Java'
	variant 'PHP'
end
