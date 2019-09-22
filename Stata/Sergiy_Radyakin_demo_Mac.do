* AAL Stata 14 Mac
*** ===== beginning of file =======

*** Please do not modify the program. Run as is.
*** I am aware that there are two compress statements here and
**  they are not in the end of the program. This is intended.

version 14.0

clear
set obs 10
generate s1="abcdefghijklmnopqrstuvwxyz"
generate s2=s1*10
generate byte region=_n

label define регион 1 "Север" 2 "Запад" 3 "Юг" 4 "Восток" ///
                    5 "Центр" 6 "Все остальные" 7 "яΕἲς Ἑρμῆνя" ///
                    8 "東京、日本の首都" 9 "Не определено"

label values region регион

generate s3=s1+"Εἲς Ἑρμῆν"+"абвгдежзийклмнопрстуфхцчшщъыьэюя"+"Εἲς Ἑρμῆν"
generate strL s4="АБВГДЕЖЗ"*500
compress

replace s4="Alpha & Omega" if mod(_n,2)==1
char s4[комментарий] <<<Ἑρμῆν ὕμνει, Μοῦσα, Διὸς καὶ Μαιάδος υἱόν>>>
compress

replace s3="" in 5

generate float regionfloat = 11-region
label values regionfloat регион

set seed 201781
generate double ПеременнаяХранящаяСлучайноеЧисло=floor(runiform()*10000)/100
format ПеременнаяХранящаяСлучайноеЧисло %6.2f

char ПеременнаяХранящаяСлучайноеЧисло[комментарий] <<<Простой, понятный и хорошо заметный комментарий>>>

note s1: First
note s1: Second
note s1: Третья
note s1: 4th
note s2: А-Я-а-я

label variable s1 "東京、日本の首都"
label variable s3 "Εἲς Ἑρμῆνабвгдежз東京、日本の首都"
label variable region "РЕГИОН"
label variable regionfloat "ТОЖЕ РЕГИОН"
label variable ПеременнаяХранящаяСлучайноеЧисло "Метка переменной, которая хранит случайное число"
label data "Проверка данных"

*** ===== end of file ===========

