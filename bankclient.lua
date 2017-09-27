-- координаты высоты (1..40), ширины (1..80)
-- использовать только с алмазными мониторами
-- data_example == cardnumber & name & type & pin
-- все компоненты максимального уровня, сетевая карта,
-- рядом с компьютером должен стоять считыватель магнитных карт,

--- INITIALISATION BEGIN ---

local component = require("component")
local uni = require("unicode")
local event = require("event")
local term = require("term")
local gpu = component.gpu
local net = component.tunnel
local magRead = component.os_magreader

VERT = uni.char(9475) -- символы юникода для отрисовки псевдографона
HORIZ = uni.char(9473)
LU_CORNER = uni.char(9487)
LD_CORNER = uni.char(9495)
RU_CORNER = uni.char(9491)
RD_CORNER = uni.char(9499)
BLOCK = uni.char(9608)

COLOR_GREEN = 0x228B22 -- зеленый
COLOR_BLACK = 0x000000 -- черный
COLOR_GOLDEN = 0xFFD700 -- желтый

local info = {} -- массив для хранения информации с карты
COORD_TABLE = {34, 20, 40, 20, 46, 20, 34, 23, 40, 23, 46, 23, 34, 26, 40, 26, 46, 26, 40, 29} -- массив с координатами каждой цифры
NUMTABLE = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "0"}                                  -- для функции SecurityCheck().

function DrawBackground() -- рисуем задний фон

	gpu.fill(1, 1, 80, 40, " ")

	gpu.fill(2, 1, 78, 1, horiz) -- рамка
	gpu.fill(2, 40, 78, 1, horiz)
	gpu.fill(1, 2, 1, 78, VERT)
	gpu.fill(80, 2, 1, 78, VERT)
	gpu.fill(1, 1, 1, 1, LU_CORNER)
	gpu.fill(1, 40, 1, 1, LD_CORNER)
	gpu.fill(80, 1, 1, 1, RU_CORNER)
	gpu.fill(80, 40, 1, 1, RD_CORNER)

	gpu.fill(29, 4, 4, 10, BLOCK) -- логотип
	gpu.fill(33, 5, 2, 1, BLOCK)
	gpu.fill(33, 6, 4, 2, BLOCK)
	gpu.fill(37, 7, 6, 2, BLOCK)
	gpu.fill(39, 9, 2, 1, BLOCK)
	gpu.fill(43, 6, 4, 2, BLOCK)
	gpu.fill(45, 5, 2, 1, BLOCK)
	gpu.fill(47, 4, 4, 10, BLOCK)
	gpu.fill(25, 7, 30, 1, BLOCK)
	gpu.fill(25, 11, 30, 1, BLOCK)
end

function DrawPinNum() -- выводим экран ввода пина

	gpu.fill(2, 16, 78, 23, " ")
	gpu.set(32, 16, "Введите Pin-код:")
	gpu.set(36, 18, "[    ]")

	gpu.fill(32, 20, 1, 1, VERT)
	gpu.fill(32, 21, 1, 1, LD_CORNER)
	gpu.fill(33, 21, 3, 1, horiz)
	gpu.fill(34, 20, 1, 1, "1")

	gpu.fill(38, 20, 1, 1, VERT)
	gpu.fill(38, 21, 1, 1, LD_CORNER)
	gpu.fill(39, 21, 3, 1, horiz)
	gpu.fill(40, 20, 1, 1, "2")

	gpu.fill(44, 20, 1, 1, VERT)
	gpu.fill(44, 21, 1, 1, LD_CORNER)
	gpu.fill(45, 21, 3, 1, horiz)
	gpu.fill(46, 20, 1, 1, "3")

	gpu.fill(32, 23, 1, 1, VERT)
	gpu.fill(32, 24, 1, 1, LD_CORNER)
	gpu.fill(33, 24, 3, 1, horiz)
	gpu.fill(34, 23, 1, 1, "4")

	gpu.fill(38, 23, 1, 1, VERT)
	gpu.fill(38, 24, 1, 1, LD_CORNER)
	gpu.fill(39, 24, 3, 1, horiz)
	gpu.fill(40, 23, 1, 1, "5")

	gpu.fill(44, 23, 1, 1, VERT)
	gpu.fill(44, 24, 1, 1, LD_CORNER)
	gpu.fill(45, 24, 3, 1, horiz)
	gpu.fill(46, 23, 1, 1, "6")

	gpu.fill(32, 26, 1, 1, VERT)
	gpu.fill(32, 27, 1, 1, LD_CORNER)
	gpu.fill(33, 27, 3, 1, horiz)
	gpu.fill(34, 26, 1, 1, "7")

	gpu.fill(38, 26, 1, 1, VERT)
	gpu.fill(38, 27, 1, 1, LD_CORNER)
	gpu.fill(39, 27, 3, 1, horiz)
	gpu.fill(40, 26, 1, 1, "8")

	gpu.fill(44, 26, 1, 1, VERT)
	gpu.fill(44, 27, 1, 1, LD_CORNER)
	gpu.fill(45, 27, 3, 1, horiz)
	gpu.fill(46, 26, 1, 1, "9")

	gpu.fill(38, 29, 1, 1, VERT)
	gpu.fill(38, 30, 1, 1, LD_CORNER)
	gpu.fill(39, 30, 3, 1, horiz)
	gpu.fill(40, 29, 1, 1, "0")

	gpu.fill(44, 29, 1, 1, VERT)
	gpu.fill(44, 30, 1, 1, LD_CORNER)
	gpu.fill(45, 30, 3, 1, horiz)
	gpu.fill(46, 29, 1, 1, "X")
end

function DrawMainMenu() -- основное меню операций

	gpu.fill(2, 16, 78, 23, " ")
	gpu.set(31, 18, "Выберете операцию:")

	gpu.fill()
	gpu.fill()
	gpu.fill()
	gpu.set(, "Осуществить перевод")

	gpu.fill()
	gpu.fill()
	gpu.fill()
	gpu.set()
end

---  INITIALISATION END  ---

gpu.setResolution(80, 40)
gpu.setBackground(COLOR_GREEN)
gpu.setForeground(COLOR_GOLDEN)
DrawBackground()
gpu.setForeground(COLOR_BLACK)

gpu.set(32, 16, "Добро пожаловать") -- приветственный экран
gpu.set(27, 18, "Считайте карту для начала.")

_, _, user, data, _ = event.pull("magData")

for i = 1, 3 do -- превращаем данные карты в удобноваримый формат

	sep_pos = string.find(data, "&")
	info[i] = string.sub(data, 1, sep_pos - 1)
	data = string.sub(data, sep_pos + 1)

end
info[4] = data

DrawPinNum()

--- ПРОВЕРКА ПИН-КОДА ---
repeat -- повторяем пока не получим верный пин

	for i = 1, 4 do -- получаем строку с пином

		m, n = 1, 2
		_, _, x, y = event.pull("touch")

		for l = 1, 10 do
			if x == coord_table[m] and y == coord_table[n] then

				input_pin = input_pin .. numtable[m]
				gpu.set(1, 1, input_pin)
				m = m + 2
				n = n + 2
				pass = pass .. "X"
				gpu.set(37, 18, pass)
			end
		end
	end

	if input_pin ~= card_pin then
		gpu.set(28, 16, "Неверный ПИН, повторите.")
		os.sleep(3)
		gpu.set(28, 16, "    Введите Pin-код:    ")
	end

until input_pin == card_pin
--- === ---

os.sleep(3)
gpu.setBackground(COLOR_BLACK)
gpu.setForeground(0xFFFFFF)
term.clear()
