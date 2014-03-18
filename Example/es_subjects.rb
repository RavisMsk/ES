# Erlang subjects
addSubject do
	title 'Chicago Boss'
	criterion 'Testing Framework', 'Встроенный'
	criterion 'Архитектура MVC', 'Есть'
	criterion 'Система шаблонов', 'Встроенная'
	criterion 'Наличие ORM', 'Отсутствует'
	criterion 'Производительная работа с WebSockets', 'Нет'
	criterion 'Routing система', 'RESTful'
	criterion 'Возможность написания внутреннего DSL', 'Нет'
	criterion 'Hot Code Upgrade', 'Поддерживается'
	criterion 'Необходимость стороннего front-end web-сервера', 'Есть полноценный встроенный web-сервер'
	criterion 'Язык программирования', 'Erlang'
end

addSubject do
	title 'N2O'
	criterions 'Testing Framework'=>'Отсутствует',
	 'Архитектура MVC' => 'Нет', 
	 'Система шаблонов' => 'Встроенная', 
	 'Наличие ORM' => 'Отсутствует',
	 'Производительная работа с WebSockets' => 'Да',
	 'Routing система' => 'RESTful',
	 'Возможность написания внутреннего DSL' => 'Нет',
	 'Hot Code Upgrade' => 'Поддерживается',
	 'Необходимость стороннего front-end web-сервера' => 'Необходим всегда',
	 'Язык программирования' => 'Erlang'
end

addSubject do
	title 'Zotonic'
	criterions 'Testing Framework'=>'Отсутствует',
	 'Архитектура MVC' => 'Есть', 
	 'Система шаблонов' => 'Встроенная', 
	 'Наличие ORM' => 'Отсутствует',
	 'Производительная работа с WebSockets' => 'Нет',
	 'Routing система' => 'RESTful',
	 'Возможность написания внутреннего DSL' => 'Нет',
	 'Hot Code Upgrade' => 'Поддерживается',
	 'Необходимость стороннего front-end web-сервера' => 'Необходим всегда',
	 'Язык программирования' => 'Erlang'
end

addSubject do
	title 'Nitrogen'
	criterions 'Testing Framework'=>'Отсутствует',
	 'Архитектура MVC' => 'Нет', 
	 'Система шаблонов' => 'Отсутствует', 
	 'Наличие ORM' => 'Отсутствует',
	 'Производительная работа с WebSockets' => 'Да',
	 'Routing система' => 'RESTful',
	 'Возможность написания внутреннего DSL' => 'Нет',
	 'Hot Code Upgrade' => 'Поддерживается',
	 'Необходимость стороннего front-end web-сервера' => 'Необходим всегда',
	 'Язык программирования' => 'Erlang'
end

# Ruby subjects
addSubject do
	title 'Sinatra'
	criterions 'Testing Framework'=>'Модульный',
	 'Архитектура MVC' => 'Нет', 
	 'Система шаблонов' => 'Модульная', 
	 'Наличие ORM' => 'Отсутствует',
	 'Производительная работа с WebSockets' => 'Да',
	 'Routing система' => 'RESTful+Regexp',
	 'Возможность написания внутреннего DSL' => 'Возможно',
	 'Hot Code Upgrade' => 'Нет',
	 'Необходимость стороннего front-end web-сервера' => 'Необходим всегда',
	 'Язык программирования' => 'Ruby'
end

addSubject do
	title 'Ruby on Rails'
	criterions 'Testing Framework'=>'Модульный',
	 'Архитектура MVC' => 'Есть', 
	 'Система шаблонов' => 'Встроенная', 
	 'Наличие ORM' => 'Встроенный',
	 'Производительная работа с WebSockets' => 'Нет',
	 'Routing система' => 'RESTful+Regexp',
	 'Возможность написания внутреннего DSL' => 'Возможно',
	 'Hot Code Upgrade' => 'Нет',
	 'Необходимость стороннего front-end web-сервера' => 'Есть полноценный встроенный web-сервер',
	 'Язык программирования' => 'Ruby'
end

addSubject do
	title 'Cramp'
	criterions 'Testing Framework'=>'Модульный',
	 'Архитектура MVC' => 'Нет', 
	 'Система шаблонов' => 'Отсутствует', 
	 'Наличие ORM' => 'Отсутствует',
	 'Производительная работа с WebSockets' => 'Да',
	 'Routing система' => 'RESTful',
	 'Возможность написания внутреннего DSL' => 'Возможно',
	 'Hot Code Upgrade' => 'Нет',
	 'Необходимость стороннего front-end web-сервера' => 'Есть полноценный встроенный web-сервер',
	 'Язык программирования' => 'Ruby'
end

# Python subjects
addSubject do
	title 'Flask'
	criterions 'Testing Framework'=>'Встроенный',
	 'Архитектура MVC' => 'Нет', 
	 'Система шаблонов' => 'Встроенная', 
	 'Наличие ORM' => 'Отсутствует',
	 'Производительная работа с WebSockets' => 'Нет',
	 'Routing система' => 'RESTful',
	 'Возможность написания внутреннего DSL' => 'Нет',
	 'Hot Code Upgrade' => 'Нет',
	 'Необходимость стороннего front-end web-сервера' => 'Есть dev-сервер',
	 'Язык программирования' => 'Python'
end

addSubject do
	title 'Django'
	criterions 'Testing Framework'=>'Встроенный',
	 'Архитектура MVC' => 'Есть', 
	 'Система шаблонов' => 'Встроенная', 
	 'Наличие ORM' => 'Встроенный',
	 'Производительная работа с WebSockets' => 'Нет',
	 'Routing система' => 'RESTful+Regexp',
	 'Возможность написания внутреннего DSL' => 'Нет',
	 'Hot Code Upgrade' => 'Нет',
	 'Необходимость стороннего front-end web-сервера' => 'Есть полноценный встроенный web-сервер',
	 'Язык программирования' => 'Python'
end

addSubject do
	title 'Tornado'
	criterions 'Testing Framework'=>'Модульный',
	 'Архитектура MVC' => 'Нет', 
	 'Система шаблонов' => 'Отсутствует', 
	 'Наличие ORM' => 'Отсутствует',
	 'Производительная работа с WebSockets' => 'Да',
	 'Routing система' => 'RESTful',
	 'Возможность написания внутреннего DSL' => 'Нет',
	 'Hot Code Upgrade' => 'Нет',
	 'Необходимость стороннего front-end web-сервера' => 'Есть dev-сервер',
	 'Язык программирования' => 'Python'
end

# JS subjects
addSubject do
	title 'Express.js'
	criterions 'Testing Framework'=>'Модульный',
	 'Архитектура MVC' => 'Нет', 
	 'Система шаблонов' => 'Модульная', 
	 'Наличие ORM' => 'Модульный',
	 'Производительная работа с WebSockets' => 'Нет',
	 'Routing система' => 'RESTful',
	 'Возможность написания внутреннего DSL' => 'Нет',
	 'Hot Code Upgrade' => 'Нет',
	 'Необходимость стороннего front-end web-сервера' => 'Есть полноценный встроенный web-сервер',
	 'Язык программирования' => 'Javascript'
end

addSubject do
	title 'Socket.io'
	criterions 'Testing Framework'=>'Модульный',
	 'Архитектура MVC' => 'Нет', 
	 'Система шаблонов' => 'Отсутствует', 
	 'Наличие ORM' => 'Модульный',
	 'Производительная работа с WebSockets' => 'Да',
	 'Routing система' => 'RESTful',
	 'Возможность написания внутреннего DSL' => 'Нет',
	 'Hot Code Upgrade' => 'Нет',
	 'Необходимость стороннего front-end web-сервера' => 'Есть полноценный встроенный web-сервер',
	 'Язык программирования' => 'Javascript'
end

addSubject do
	title 'Geddy.js'
	criterions 'Testing Framework'=>'Модульный',
	 'Архитектура MVC' => 'Есть', 
	 'Система шаблонов' => 'Модульная', 
	 'Наличие ORM' => 'Модульный',
	 'Производительная работа с WebSockets' => 'Нет',
	 'Routing система' => 'RESTful',
	 'Возможность написания внутреннего DSL' => 'Нет',
	 'Hot Code Upgrade' => 'Нет',
	 'Необходимость стороннего front-end web-сервера' => 'Есть полноценный встроенный web-сервер',
	 'Язык программирования' => 'Javascript'
end

addSubject do
	title 'Meteor'
	criterions 'Testing Framework'=>'Модульный',
	 'Архитектура MVC' => 'Есть', 
	 'Система шаблонов' => 'Модульная', 
	 'Наличие ORM' => 'Модульный',
	 'Производительная работа с WebSockets' => 'Да',
	 'Routing система' => 'RESTful',
	 'Возможность написания внутреннего DSL' => 'Нет',
	 'Hot Code Upgrade' => 'Поддерживается',
	 'Необходимость стороннего front-end web-сервера' => 'Есть полноценный встроенный web-сервер',
	 'Язык программирования' => 'Javascript'
end

# Java subjects
addSubject do
	title 'Play'
	criterions 'Testing Framework'=>'Встроенный',
	 'Архитектура MVC' => 'Есть', 
	 'Система шаблонов' => 'Встроенная', 
	 'Наличие ORM' => 'Модульный',
	 'Производительная работа с WebSockets' => 'Нет',
	 'Routing система' => 'RESTful',
	 'Возможность написания внутреннего DSL' => 'Нет',
	 'Hot Code Upgrade' => 'Нет',
	 'Необходимость стороннего front-end web-сервера' => 'Есть полноценный встроенный web-сервер',
	 'Язык программирования' => 'Java'
end

addSubject do
	title 'Spring'
	criterions 'Testing Framework'=>'Отсутствует',
	 'Архитектура MVC' => 'Есть', 
	 'Система шаблонов' => 'Встроенная', 
	 'Наличие ORM' => 'Модульный',
	 'Производительная работа с WebSockets' => 'Нет',
	 'Routing система' => 'RESTful',
	 'Возможность написания внутреннего DSL' => 'Нет',
	 'Hot Code Upgrade' => 'Нет',
	 'Необходимость стороннего front-end web-сервера' => 'Есть dev-сервер',
	 'Язык программирования' => 'Java'
end

addSubject do
	title 'Netty'
	criterions 'Testing Framework'=>'Отсутствует',
	 'Архитектура MVC' => 'Нет', 
	 'Система шаблонов' => 'Отсутствует', 
	 'Наличие ORM' => 'Модульный',
	 'Производительная работа с WebSockets' => 'Да',
	 'Routing система' => 'RESTful',
	 'Возможность написания внутреннего DSL' => 'Нет',
	 'Hot Code Upgrade' => 'Нет',
	 'Необходимость стороннего front-end web-сервера' => 'Есть полноценный встроенный web-сервер',
	 'Язык программирования' => 'Java'
end