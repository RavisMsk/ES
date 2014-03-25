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

# addQuestion do
# 	text "Interval testing question?"
# 	criterion "Test Interval"
# end

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