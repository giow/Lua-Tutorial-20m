-- Dois traços iniciam um comentário de uma linha.

--[[
     Adicionar dois '[]' faz com que seja um 
     comentário de várias linhas. 
--]]

----------------------------------------------------
-- 1. Variáveis e controle de fluxo.
----------------------------------------------------

num = 42  -- Todos os números são duplos.
-- NNão surte, duplos de 64 bits têm 52 bits para 
-- armazenar valores exatos de int; a precisão da máquina 
-- não é um problema para entradas que precisam de <52 bits.
s = 'walternate'  -- sequencias imutaveis como Python.
t = "double-quotes are also fine"
u = [[ Parênteses duplos
       começo e fim
       sequências de várias linhas.]]
t = nil  -- Nil é igual a false.

-- Blocos são indicados com palavras-chave como do / end: 
while num < 50 do
  num = num + 1  -- Nenhum operador do tipo ++ ou + =. 
end

-- Como usar IF
if num > 40 then
  print('over 40')
elseif s ~= 'walternate' then  -- ~= não é igual. 
  -- A verificação de igualdade é == como Python; ok para strings.
  io.write('not over 40\n')  -- O padrão é stdout. 
else
  -- As variáveis ​​são globais por padrão.
  thisIsGlobal = 5  -- O caso Camel é comum.

  -- Como tornar uma variável local:
  local line = io.read()  -- Lê a próxima linha stdin. 

  -- A concatenação de cadeias usa o operador ..
  print('Winter is coming, ' .. line)
end

-- Variáveis ​​indefinidas retornam nulo.
-- Isso não é um erro:
foo = anUnknownVariable  -- Agora foo = nil.

aBoolValue = false

-- Nulo e falso são falsas; 0 e 'nada são Verdadeiras!
if not aBoolValue then print('twas false') end

-- 'or' and 'and' estão em curto-circuito.
-- Isso é semelhante ao a?b:c operador em C/js:
ans = aBoolValue and 'yes' or 'no'  --> 'no'

karlSum = 0
for i = 1, 100 do  -- A gama inclui as duas extremidades.
  karlSum = karlSum + i
end

-- Use "100, 1, -1" como o intervalo para contagem regressiva:
fredSum = 0
for j = 100, 1, -1 do fredSum = fredSum + j end

-- Em geral, o intervalo é início, fim [, step].

-- Outra construção de loop:
repeat
  print('Fivem é toxico')
  num = num - 1
until num == 0


----------------------------------------------------
-- 2. Funçoes.
----------------------------------------------------

function fib(n)
  if n < 2 then return 1 end
  return fib(n - 2) + fib(n - 1)
end

-- Fechamentos e funções anônimas estão ok:
function adder(x)
  -- a função retornada é criada quando o somador é
  -- chamado e lembra o valor de x:
  return function (y) return x + y end
end
a1 = adder(9)
a2 = adder(36)
print(a1(16))  --> 25
print(a2(64))  --> 100

-- Devoluções, chamadas de funções e atribuições funcionam
-- com listas que podem ter tamanhos diferentes.
-- Receptores incomparáveis ​​são nulos;
-- remetentes incomparáveis ​​são descartados.

x, y, z = 1, 2, 3, 4
-- Now x = 1, y = 2, z = 3, and 4 is thrown away.

function bar(a, b, c)
  print(a, b, c)
  return 4, 8, 15, 16, 23, 42
end

x, y = bar('zaphod')  --> prints "zaphod  nil nil"
-- Agora x = 4, y = 8, os valores 15..42 são descartados.

-- As funções são de primeira classe, podem ser locais / globais.
-- Estes são os mesmos:
function f(x) return x * x end
f = function (x) return x * x end

-- E assim são estes:
local function g(x) return math.sin(x) end
local g; g  = function (x) return math.sin(x) end
-- o declínio 'local g' faz com que as auto-referências g sejam aceitáveis.

-- Função trigonométrica funcionam em radianos, a propósito.

-- As chamadas com um parâmetro de sequência não precisam de parênteses:
print 'Hello' - Funciona bem.


----------------------------------------------------
-- 3. Tabelas
----------------------------------------------------

-- Tabelas = única estrutura de dados composta de Lua;
-- eles são matrizes associativas.
-- Semelhante a arrays php ou objetos js, eles são
-- dutos de pesquisa de hash que também podem ser usados ​​como listas.

-- Usando tabelas como dicionários / mapas:

-- Literais têm chaves de string por padrão:
t = {key1 = 'value1', key2 = false}

-- As chaves de sequência podem usar a notação de ponto semelhante a js:
print(t.key1)  -- Printa 'value1'.
t.newKey = {}  -- Adiciona um novo par de chave / valor.
t.key2 = nil   -- Remove key2 da tabela.
-- Notação literal para qualquer valor (não nulo) como chave:
u = {['@!#'] = 'qbert', [{}] = 1729, [6.28] = 'tau'}
print(u[6.28])  -- printa "tau"

-- A correspondência de teclas é basicamente pelo valor dos números
-- e strings, mas por identidade para tabelas.
a = u['@!#']  -- Agora = 'qbert'.
b = u[{}]     -- Podemos esperar 1729, mas é nulo:
-- b = nil desde que a pesquisa falhe. Falha
-- porque a chave que usamos não é o mesmo objeto
-- como aquele usado para armazenar o valor original.
-- então strings e números são mais teclas portáteis.

-- Uma chamada de função one-table-param não precisa de parênteses:
function h(x) print(x.key1) end
h{key1 = 'Sonmi~451'}  -- Printa 'Sonmi~451'.

for key, val in pairs(u) do  -- Interação de tabela.
  print(key, val)
end

-- _G é uma tabela especial de todos os globais.
print(_G['_G'] == _G)  -- Printa 'true'.

-- Usando tabelas como listas / matrizes:

-- Listar literais configurados implicitamente com int keys:
v = {'value1', 'value2', 1.21, 'gigawatts'}
for i = 1, #v do  -- #v é o tamanho de v para listas.
  print(v[i])  -- Os índices começam em 1 !
end
-- Uma 'lista' não é do tipo real. v é apenas uma mesa
-- com 'keys' inteiras consecutivas, tratadas como uma lista.

----------------------------------------------------
-- 3.1 Metatabelas e metamétodos.
----------------------------------------------------

-- Uma tabela pode ter uma meta-tabela que dê à tabela o 
--comportamento de sobrecarga do operador. Mais adiante veremos 
-- como as metatables suportam o comportamento js-prototypey.

f1 = {a = 1, b = 2}  -- Representa a fração a / b.
f2 = {a = 2, b = 3}

-- Isso falharia:
-- s = f1 + f2

metafraction = {}
function metafraction.__add(f1, f2)
  sum = {}
  sum.b = f1.b * f2.b
  sum.a = f1.a * f2.b + f2.a * f1.b
  return sum
end

setmetatable(f1, metafraction)
setmetatable(f2, metafraction)

s = f1 + f2  -- call __add(f1, f2) on f1's metatable

-- ff1, f2 não tem chave para seus metotipos, ao contrário de 
-- protótipos em js, portanto, você deve recuperá-lo como in 
-- getmetatable (f1). A meta-tabela é uma tabela normal 
-- com chaves que Lua conhece, como __add.

-- Mas a próxima linha falha, uma vez que s não tem meta-meta: 
-- t = s + s 
-- Os padrões de classe dados abaixo corrigem isso.

-- Um __index em uma sobrecarga metável carrega pesquisas de ponto:
defaultFavs = {animal = 'gru', food = 'donuts'}
myFavs = {food = 'pizza'}
setmetatable(myFavs, {__index = defaultFavs})
eatenBy = myFavs.animal  -- ISSO! obrigado, metatable

-- As pesquisas diretas da tabela que falharão tentarão novamente usando

-- o valor de __index  também pode ser uma função (tbl, key)
-- para pesquisas mais personalizadas.

-- Lista completa. Aqui está uma tabela com o metamethod.

-- __add(a, b)                     for a + b
-- __sub(a, b)                     for a - b
-- __mul(a, b)                     for a * b
-- __div(a, b)                     for a / b
-- __mod(a, b)                     for a % b
-- __pow(a, b)                     for a ^ b
-- __unm(a)                        for -a
-- __concat(a, b)                  for a .. b
-- __len(a)                        for #a
-- __eq(a, b)                      for a == b
-- __lt(a, b)                      for a < b
-- __le(a, b)                      for a <= b
-- __index(a, b)  <fn or a table>  for a.b
-- __newindex(a, b, c)             for a.b = c
-- __call(a, ...)                  for a(...)

----------------------------------------------------
-- 3.2 Tabelas e herança de classe.
----------------------------------------------------

-- As aulas não são integradas; existem maneiras diferentes
-- para fazê-los usar tabelas e metatables.

-- A explicação para este exemplo está abaixo.

Dog = {}                                   -- 1.

function Dog:new()                         -- 2.
  newObj = {sound = 'woof'}                -- 3.
  self.__index = self                      -- 4.
  return setmetatable(newObj, self)        -- 5.
end

function Dog:makeSound()                   -- 6.
  print('I say ' .. self.sound)
end

mrDog = Dog:new()                          -- 7.
mrDog:makeSound()  -- 'I say woof'         -- 8.

--1. O cachorro age como uma classe; é realmente uma mesa. 
-- 2. function tablename: fn (...) é o mesmo que 
-- function tablename.fn (self, ...) 
-- O: apenas adiciona um primeiro argumento chamado self. 
-- Leia 7 e 8 abaixo para saber como o eu obtém seu valor. 
-- 3. newObj será uma instância da classe Dog. 
-- 4. self = a classe que está sendo instanciada. Muitas vezes 
-- self = Dog, mas a herança pode mudar isso. 
-- newObj obtém as funções de si quando definimos as duas 
-- metável de newObj e __índice de self como self. 
-- 5. Lembrete: setmetatable retorna seu primeiro argumento. 
-- 6. O: funciona como em 2, mas desta vez esperamos 
--que seja uma instância em vez de uma classe. 
-- 7. O mesmo que Dog.new (Dog), então self = Dog em new ().
-- 8. O mesmo que mrDog.makeSound (mrDog); self = mrDog.

----------------------------------------------------

-- Exemplo de herança:

LoudDog = Dog:new()                           -- 1.

function LoudDog:makeSound()
  s = self.sound .. ' '                       -- 2.
  print(s .. s .. s)
end

seymour = LoudDog:new()                       -- 3.
seymour:makeSound()  -- 'woof woof woof'      -- 4.

-- 1. O LoudDog obtém os métodos e variáveis ​​de Dog.
-- 2. self possui uma tecla 'sound' de new (), veja 3.
-- 3. Igual ao LoudDog.new (LoudDog) e convertido em
-- Dog.new (LoudDog), pois o LoudDog não possui uma chave 'nova',
-- mas tem __index = Dog em sua meta-tabela.
-- Resultado: o metatable do seymour é o LoudDog e
-- LoudDog .__ index = LoudDog. Então, seymour.key
-- = seymour.key, LoudDog.key, Dog.key, o que for
-- tabela é a primeira com a chave fornecida.
-- 4. A tecla 'makeSound' é encontrada no LoudDog; esta
-- é o mesmo que LoudDog.makeSound (seymour).

-- Se necessário, o new () de uma subclasse é como o da base:
function LoudDog:new()
  newObj = {}
  -- configurar  newObj
  self.__index = self
  return setmetatable(newObj, self)
end

----------------------------------------------------
-- 4. Modulos.
----------------------------------------------------


-- [[Estou comentando esta seção, então o resto
-- este script permanece rodável.
-- Suponha que o arquivo mod.lua seja assim:
local M = {}

local function sayMyName()
  print('Hrunkner')
end

function M.sayHello()
  print('Why hello there')
  sayMyName()
end

return M

-- Outro arquivo pode usar a funcionalidade de mod.lua:
local mod = require('mod')  --Executa o arquivo mod.lua

-- exigir é a maneira padrão de incluir módulos.
-- requer ações como: (se não estiver em cache; veja abaixo)
local mod = (function ()
  <contents of mod.lua>
end)()
-- É como mod.lua é um corpo funcional, para que
-- locais dentro do mod.lua são invisíveis fora dele.

-- Isso funciona porque mod here = M no mod.lua:
mod.sayHello()  -- Diz olá para Hrunkner.

-- This is wrong; sayMyName only exists in mod.lua:
mod.sayMyName()  -- erro

-- Os valores de retorno de require são armazenados em cache para que um arquivo seja
-- execute no máximo uma vez, mesmo quando necessário várias vezes.

-- Suponha que mod2.lua contenha "print ('OLA!')".
local a = require('mod2')  -- Printa OLA!
local b = require('mod2')  -- não printa; a=b.

-- dofile é como exigir sem armazenar em cache:
dofile('mod2.lua')  --> OLA!
dofile('mod2.lua')  --> OLA! (executa denovo)

-- O loadfile carrega um arquivo lua, mas ainda não o executa.
f = loadfile('mod2.lua')  -- 'call' f () para executá-lo.

-- loadstring é loadfile para strings.
g = loadstring('print(343)')  -- Retorna uma função.
g()  -- Printa 343; nada 'impresso' antes de agora.

--]]

----------------------------------------------------
-- 5. Referencias
----------------------------------------------------

--[[
Eu ! Noah#7706 traduzi um aquivo que eu estava estudando sobre lua,
o link do arquivo é http://tylerneylon.com/a/learn-lua/ .


Os principais tópicos não abordados são bibliotecas padrão:
 * string library
 * table library
 * math library
 * io library
 * os library

A propósito, esse arquivo inteiro é Lua válido; Salve isso
como learn.lua e execute-o com "lua learn.lua"!

--]]
