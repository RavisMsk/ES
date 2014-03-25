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

# addCriterion 'Test Interval' do
# 	interval
# end

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
