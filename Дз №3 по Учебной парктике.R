install.packages("devtools")
devtools::install_github("bdemeshev/rlms")

library("lmtest")
library("rlms")
library("dplyr")
library("GGally")
library("car")
library("sandwich")

data <- rlms_read("C:\\Users\\dimab\\Downloads\\r24i_os26c.sav")
glimpse(data)
data_1 = select(data, tj13.2, t_age, th5, t_educ, status, tj6.2, t_marst)

#Исключим из рассмотрения строки с отсутствующими значениями NA
data_1 = na.omit(data_1)
glimpse(data_1)

#Зарплата c элементами нормализации
data_1$tj13.2
sal = as.numeric(data_1$tj13.2)
sal1 = as.character(data_1$tj13.2)
sal2 = lapply(sal1, as.integer)
sal = as.numeric(unlist(sal2))
mean(sal)
data_1["salary"] = (sal - mean(sal)) / sqrt(var(sal))
data_1["salary"]

#Возраст c элементами нормализации
age1 = as.character(data_1$t_age)
age2 = lapply(age1, as.integer)
age3 = as.numeric(unlist(age2))
data_1["age"]= (age3 - mean(age3)) / sqrt(var(age3))
data_1["age"]

#Пол
data_1["sex"]=data_1$th5
#data_1["sex"] = lapply(data_1$th5, as.character)
data_1$sex[which(data_1$sex!=1)] <- 0
data_1$sex[which(data_1$sex==1)] <- 1
data_1$sex = as.numeric(data_1$sex)

#Образование
data_1["t_educ"] = data_1$t_educ
#data_1["t_educ"] = lappy(data_1$t_educ, as.character)
data_1["higher_educ"] = data_1$t_educ
data_1["higher_educ"] = 0 # Нет высшего образования
data_1$higher_educ[which(data_1$t_educ==21)] <- 1 
data_1$higher_educ[which(data_1$t_educ==22)] <- 1 
data_1$higher_educ[which(data_1$t_educ==23)] <- 1

#Населенный пункт
data_1["status1"]=data_1$status
#data_1["status1"] = lapply(data_1$status, as.character)
data_1["status2"] = 0
data_1$status2[which(data_1$status1==1)] <- 1 # Область
data_1$status2[which(data_1$status1==2)] <- 1 # Город
data_1$status2 = as.numeric(data_1$status2)

#Продолжительность рабочей недели
data_1["dur123"]=data_1$tj6.2
#data_1["dur123"] = lapply(data_1$tj6.2, as.character)
data_1["dur123"]
dur1 = as.character(data_1$tj6.2)
dur2 = lapply(dur1, as.integer)
dur3 = as.numeric(unlist(dur2))
mean(dur3)
data_1["dur"] = (dur3 - mean(dur3)) / sqrt(var(dur3))
data_1["dur"]

#Семейное положение:
# 1)Состоите в зарегистрированном браке:
data_1["wed"]= data_1$t_marst
#data_1["wed"] = lapply(data_1$t_marst, as.character)
data_1$wed1 = 0
data_1$wed1[which(data_1$wed==2)] <- 1 # Состоите в зарегистрированном браке
data_1$wed1 = as.numeric(data_1$wed1)

data_1["wed1"]


# 2) Разведены и в браке не состоите/Bдовец (вдова):
data_1["wed2"] = lapply(data_1["wed"], as.character)
data_1$wed2 = 0
data_1$wed2[which(data_1$wed==4)] <- 1 # Разведены и в браке не состоите
data_1$wed2[which(data_1$wed==5)] <- 1 # Bдовец (вдова)
data_1$wed2 = as.numeric(data_1$wed2)

data_1["wed2"]

# 3)Никогда в браке не состояли:
data_1["wed3"]=data_1$t_marst
data_1$wed3 = 0
data_1$wed3[which(data_1$wed==1)] <- 1 # Никогда в браке не состояли
data_1$wed3 = as.numeric(data_1$wed3)

data_1["wed3"]

#Вариант 1

# №1.Построить линейную регрессию зарплаты на все параметры,и оценить коэффициент вздутия дисперсии VIF.

data_2 = select(data_1, salary, age, sex, higher_educ, status2, dur, wed1,wed2,wed3)

#Исключим из рассмотрения строки с отсутствующими значениями NA
data_2 = na.omit(data_2)
glimpse(data_2)

#Построение зависимости для рассматриваемых данных:
model1 = lm(data = data_2, salary~age + sex + higher_educ + status2 + dur + wed1 + wed2 + wed3)
summary(model1)
vif(model1)

#Исключим из рассмотрения все регрессоры с отсутствующими значениями NA
model2 = lm(data = data_2, salary~age + sex + dur) # R^2 = 0.06639 - довольно низкий
summary(model2)                                    # p-статистика очень хорошая(***) у всех переменных 
vif(model2) # => линейной зависимости нет                                       

#   age        sex        dur 
#1.008008   1.043988   1.045676 

# №2.Введём в модель логарифмы и степени переменных:

# 2.1)Логарифмы:
model3 = lm(salary~age+log(age) + sex + dur + log(dur),data = data_2) #R^2 = 0.09061 - увеличился на 0.024, по сравнению с моделью: "Sal ~ Age + Sex + Dur"
summary(model3)                                             #p-статистика хорошая только переменных log(age) и sex
vif(model3) # => линейной зависимости нет 

#   age      log(age)     sex         dur     log(dur) 
# 3.799147  3.794782    1.016615   4.144889   4.163341 

# Попробуем улучшить модель, убирая из нее параметры с наибольшими коэф в vif:
model4 = lm(salary~age + log(age) + sex + dur,data = data_2) #R^2 = 0.06722  - увеличился на 0.0008, по сравнению с моделью: "Sal ~ Age + Sex + Dur"
summary(model4)                                             #p-статистика очень хорошая(***) у всех переменных, кроме log(age) и "Свободного Коэффициента"
vif(model4) # => линейной зависимости нет 

#   age      log(age)      sex       dur 
# 3.636281  3.618010    1.038272   1.051902 

model5 = lm(salary~log(age) + sex + dur,data = data_2) #R^2 = 0.05907  - уменьшился на 0.007, по сравнению с моделью: "Sal ~ Age + Sex + Dur"
summary(model5)                                             #p-статистика очень хорошая(***) у всех переменных
vif(model5) # => линейной зависимости нет 

#  log(age)      sex       dur 
# 1.008700     1.038095  1.046434

# 2.2)Степени:
model6 = lm(salary~age + I(age^0.1) + sex + dur+ I(dur^0.1),data = data_2) #R^2 = 0.09058 - увеличился на 0.024 , по сравнению с моделью: "Sal ~ Age + Sex + Dur"
summary(model6)                                             #p-статистика очень хорошая(***) только у переменных Age и Sex
vif(model6) # => линейной зависимости нет 

#   age      I(age^0.1)     sex       dur      I(dur^0.1) 
# 4.835096   4.829656     1.016740  5.010107   5.034093 

# Попробуем улучшить модель, убирая из нее параметры с наибольшими коэф в vif:
model7 = lm(salary~age + I(age^0.1) + sex + dur,data = data_2) #R^2 = 0.06723 - увеличился на 0.0008 , по сравнению с моделью: "Sal ~ Age + Sex + Dur"
summary(model7)                                             #p-статистика очень хорошая(***) только у переменных Age, Sex и Dur
vif(model7) # => линейной зависимости нет 

#   age      I(age^0.1)      sex        dur 
# 4.601656   4.582983      1.038274   1.051879 

model8 = lm(salary~I(age^0.1) + sex + dur,data = data_2) #R^2 = 0.06045 - увеличился на 0.0059 , по сравнению с моделью: "Sal ~ Age + Sex + Dur"
summary(model8)                                             #p-статистика очень хорошая(***) у всех переменных
vif(model8) # => линейной зависимости нет 

# I(age^0.1)     sex         dur 
# 1.009680     1.038148   1.047450

# Попробуем улучшить модель, повышая степень(до степени "2", с шагом 0.1):
model9 = lm(salary~I(age^0.2) + sex + dur,data = data_2) #R^2 = 0.06174 - уменьшился на 0.005 , по сравнению с моделью: "Sal ~ Age + Sex + Dur"
summary(model9)                                             #p-статистика очень хорошая(***) у всех переменных 
vif(model9) # => линейной зависимости нет 

# I(age^0.2)     sex           dur 
# 1.010583     1.038196      1.048387

model10 = lm(salary~I(age^0.3) + sex + dur,data = data_2) #R^2 = 0.06291 - уменьшился на 0.003 , по сравнению с моделью: "Sal ~ Age + Sex + Dur"
summary(model10)                                             #p-статистика хорошая у всех переменных 
vif(model10) # => линейной зависимости нет

# I(age^0.3)      sex          dur 
# 1.011384     1.038238     1.049217 

model11 = lm(salary~I(age^0.4) + sex + dur,data = data_2) #R^2 = 0.06394 - уменьшился на 0.002 , по сравнению с моделью: "Sal ~ Age + Sex + Dur"
summary(model11)                                             #p-статистика хорошая у всех переменных, кроме "Свободного Коэффициента" 
vif(model11) # => линейной зависимости нет

# I(age^0.4)     sex           dur 
# 1.012068     1.038272      1.049927 

model12 = lm(salary~I(age^0.5) + sex + dur,data = data_2) #R^2 = 0.06394 - уменьшился на 0.001 , по сравнению с моделью: "Sal ~ Age + Sex + Dur"
summary(model12)                                             #p-статистика хорошая у всех переменных, кроме "Свободного Коэффициента" 
vif(model12) # => линейной зависимости нет

# I(age^0.5)   sex            dur 
# 1.012629   1.038296      1.050510 

# Поскольку при повышении степени от "0.1" до "0.5" R^2 возрастает, то попробуем взять сразу степень равную "0.9"

model13 = lm(salary~I(age^0.9) + sex + dur,data = data_2) #R^2 = 0.06704 - увеличился на 0.0007 , по сравнению с моделью: "Sal ~ Age + Sex + Dur"
summary(model13)                                             #p-статистика хорошая у всех переменных, кроме "Свободного Коэффициента" 
vif(model13) # => линейной зависимости нет

# I(age^0.9)    sex           dur 
# 1.013750    1.038292     1.051687 

model14 = lm(salary~I(age^1.1) + sex + dur,data = data_2) #R^2 =  0.06749 - увеличился на 0.0011 , по сравнению с моделью: "Sal ~ Age + Sex + Dur"
summary(model14)                                             #p-статистика хорошая у всех переменных, кроме "Свободного Коэффициента" 
vif(model14) # => линейной зависимости нет

# I(age^1.1)    sex           dur 
# 1.013763    1.038235     1.051713 

model15 = lm(salary~I(age^1.2) + sex + dur,data = data_2) #R^2 =  0.06758 - увеличился на 0.00119 , по сравнению с моделью: "Sal ~ Age + Sex + Dur"
summary(model15)                                             #p-статистика хорошая у всех переменных, кроме "Свободного Коэффициента" 
vif(model15) # => линейной зависимости нет

# I(age^1.2)     sex        dur 
# 1.013667     1.038196   1.051620 

model16 = lm(salary~I(age^1.3) + sex + dur,data = data_2) #R^2 =  0.06759 - увеличился на 0.0012 , по сравнению с моделью: "Sal ~ Age + Sex + Dur"
summary(model16)                                             #p-статистика хорошая у всех переменных, кроме "Свободного Коэффициента" 
vif(model16) # => линейной зависимости нет

# I(age^1.3)     sex        dur 
# 1.013515     1.038152   1.051468 

model17 = lm(salary~I(age^1.4) + sex + dur,data = data_2) #R^2 =  0.06754 - увеличился на 0.00115 , по сравнению с моделью: "Sal ~ Age + Sex + Dur"
summary(model17)                                             #p-статистика хорошая у всех переменных, кроме "Свободного Коэффициента" 
vif(model7) # => линейной зависимости нет

# I(age^1.4)      sex        dur 
# 1.013314     1.038104   1.051265 

#Поскольку при степени "1.4" значение R^2 меньше, чем при стпени "1.3", то попробуем сразу взять степень равную "1.9" :
model18 = lm(salary~I(age^1.9) + sex + dur,data = data_2) #R^2 =  0.06643 - увеличился на 0.00004 , по сравнению с моделью: "Sal ~ Age + Sex + Dur"
summary(model18)                                             #p-статистика хорошая у всех переменных 
vif(model18) # => линейной зависимости нет

# I(age^1.9)    sex        dur 
# 1.011825    1.037842   1.049728 

model19 = lm(salary~I(age^2) + sex + dur,data = data_2) #R^2 =  0.07877 - увеличился на 0.012 , по сравнению с моделью: "Sal ~ Age + Sex + Dur"
summary(model19)                                             #p-статистика хорошая у всех переменных
vif(model19) # => линейной зависимости нет

# I(age^2)      sex      dur 
# 1.005638 1.042064 1.047263 

# №3.Выберем наилучшую модель среди построенных

# 3.1)Вывод:Среди моделей с логарифма лучшей можно считать model5, однако т.к эта модель хуже
# первоначальной model2(т.к. p-статистика хорошая в обоих случаях,а R^2 в model5 меньше, чем в model2).
# Следовательно, log() не дал ощутимых результатов.
# 3.2)Вывод:Среди моделей со степенями лучшая - это model19(модель с квадратом), тк в остальных случаях у нас ниже R^2 
# и больше параметров с плохой p-статистикой

# №4.Сделать вывод о том, какие индивиды получают наибольшую зарплату.

# Вывод: Наибольшую зарплату получают мужчины более молодого возраста, живущие в городе,с высшим образованием,
# с большой продолжительностью рабочей недели и никогда не состоящие в браке.

# №5.Оценить регрессии для подмножества индивидов:Городские жители, состоящие в браке; разведенные, без
# высшего образования.

# Ищем подмножество Городские жителей, состоящих в браке:
data_3 = subset(data_2, status2 == 1)
data_3

data_4 = subset(data_3, wed1 == 1)
data_4

# Ищем подмножество Разведенных, без высшего образования:
data_5 = subset(data_2, wed2 == 1)
data_5

data_6 = subset(data_5, higher_educ == 0)
data_6


model_subset1 = lm(data = data_4, salary~dur + sex + I(age^2))
summary(model_subset1)
# R^2 =  0.1173, p-статистика хорошая у всех переменных, кроме "Свободного Коэффициента" 
# Модель хорошая
# Наибольшую зарплату получают мужчины, с высшим образованием 

model_subset2 = lm(data = data_6, salary~dur + sex + I(age^2))
summary(model_subset2)
# R^2 =  0.09543 , p-статистика хорошая у всех переменных 
# Модель хорошая
# Наибольшую зарплату получают мужчины более молодого возраста, с большой продолжительностью рабочей недели 