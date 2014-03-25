# The MIT License (MIT)
# 
# Copyright (c) 2014 Anisimov Nikita <ravis.bmstu(at)gmail.com>
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

# Test Interval Subject

# addSubject do
# 	title 'Intervaller'
# 	criterion 'Test Interval', 93.5
# end

# addSubject do
# 	title 'Intervaller#2'
# 	criterion 'Test Interval', 75.0
# end

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
	link 'https://github.com/5HT/n2o'
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