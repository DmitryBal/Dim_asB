library("lmtest")
library("GGally")
library("car")

data = swiss
help(swiss)

# ������� 1 (����������� ����������: Fertility; ����������: Agriculture, Examination,Infant.Mortality)

# �1.��������, ��� � ������ ������ ��� �������� �����������:

vif(model) #Agriculture 1.96; 
           #Examination 1.98;
           #Infant.Mortality 1.05;

model_test_1 = lm(Agriculture ~ Examination + Infant.Mortality, data) # Agr = -2*Ex + (-1.1)*Inf.M + 105.56;
model_test_1                                                          # R^2 = 0.49. VIF = 1/(1 - R^2) = 1.96. ���� VIF � ������ 5, �� ���� ������, ��� ��� ����������(Examination) ������� 
summary(model_test_1)                                                 # �������� p-����������(***), � ��� R^2 = 0.49 - ��� �������� ������� ����������, �� ����� �������, ��� ���������� 
                                                                      # ��������� ����������� ����� �����������(Agriculture) � �����������(Examination);


model_test_2 = lm(Examination ~ Agriculture + Infant.Mortality, data) # Ex = -0.24*Agr + (-0.43)*Inf.M +37.42;
model_test_2                                                          # R^2 = 0.49. VIF = 1/(1 - R^2) = 1.98. ���� VIF � ������ 5, �� ���� ������, ��� ��� ����������(Examination) ������� 
summary(model_test_2)                                                 # �������� p-����������(***), � ��� R^2 = 0.49 - ��� �������� ������� ����������, �� ����� �������, ��� ���������� 
                                                                      # ��������� ����������� ����� �����������(Examination) � �����������(Agriculture);


model_test_3 = lm(Infant.Mortality ~ Agriculture + Examination , data) # Inf.M = -0.03*Agr + (-0.1)*Ex + 23.43; 
model_test_3                                                           # R^2 = 0.049. VIF = 1/(1 - R^2) = 1.05. �.�. VIF ����������� ������ 5, �� ����� � ������������ �������, ��� 
summary(model_test_3)                                                  # ���������(Infant.Mortality) �� ������� �� �����������(Agriculture, Examination).
                                                     


# �2.1 �������� �������� ������ ��������� ����������(Fertility) �� �����������(Agriculture, Examination,Infant.Mortality):

model = lm(Fertility ~ Agriculture + Examination + Infant.Mortality, data)
model
summary(model)   # F = -0.04*Agr + (-1.04)*Ex + 1.44*Inf.M + 60.87;
                 # R^2 = 0.5398. ��� ��� ����������� �������� R^2 �������� ������ => ������� �����-���� ����������� ������ ������.

# �2.2. ���������� P-���������� � �����������(Agriculture, Examination,Infant.Mortality):
    
      #`�������� P-���������� ��� ����������(Examination) ������(***);
      # �������� P-���������� ��� ����������(Infant.Mortality) �������� ������(**);
      # �������� P-���������� ��� ����������(Agriculture) �������(0 ����).

# ������� ��������: ��������� Agriculture �� ������. P-���������� ���������� ������, ��� ��� ����� �������� ����������� �� ��� ����������:
  
model = lm(Fertility ~ Examination + Infant.Mortality, data)
model
summary(model)  # F = -0.94*Ex + 1.49*Inf.M + 56.08;
                # R^2 = 0.5363 => R^2 ��������� ����� �� 0.35%, ��� ����������� ������, ��� 5% => �� ��� �������� ����� ��������� ���������(Agriculture).


# �3.����� � ������ ��������� ����������� � ������� ���������, ������� ������������ ������:

model = lm(Fertility ~ log(Examination) + log(Infant.Mortality), data) # F = -12.76*log(Ex) + 3.79*log(Inf.M) + 6.35;
model                                                                  # P-���������� ��� �����������(Examination,Infant.Mortality) �������;
summary(model)                                                         # R^2 = 0.52 => ���������� ����������.
vif(model) #log(Examination) 1.0002, log(Infant.Mortality) 1.0002. => �������� ����������� ���;

model = lm(log(Fertility) ~ log(Examination) + log(Infant.Mortality), data) # log(F) = -0.19*log(Ex) + 0.5*log(Inf.M) + 3.26;
model                                                                  # P-���������� ��� �����������(Examination,Infant.Mortality) �������;
summary(model)                                                         # R^2 = 0.49 => ���������� ����������.
vif(model) #log(Examination) 1.0002, log(Infant.Mortality) 1.0002. => �������� ����������� ���;

model = lm(Fertility ~ log(Examination) + Infant.Mortality, data) # F = -12.89*log(Ex) + 1.85*Inf.M + 67.48;
model                                                             # P-���������� ��� �����������(Examination,Infant.Mortality) �������; - ������ ������ � log()
summary(model)                                                    # R^2 = 0.54 => ���������� ������� ����������.                         
vif(model) #log(Examination) 1.0007, Infant.Mortality 1.0007. => �������� ����������� ���;

model = lm(Fertility ~ Examination + log(Infant.Mortality), data) # F = -0.94*Ex + 25.89*log(Inf.M) + 8.53;
model                                                             # P-���������� ��� �����������(Examination,Infant.Mortality) �������;
summary(model)                                                    # R^2 = 0.52 => ���������� ����������.
vif(model) #Examination 1.017, log(Infant.Mortality 1.017). => �������� ����������� ���;

# �����: ������ ������ � log() - ��� "F = -12.89*log(Ex) + 1.85*Inf.M + 67.48"; 
# log() ���� � ��� �������, �� �� ������� ������������.


# �4.1 ����� � ������ ������������ ������������ ��� �����������,� ��� ����� � �������� �����������:

model_1 = lm(Fertility ~ Examination + Infant.Mortality + I(Examination^2) + I(Infant.Mortality^2) + I(Examination*Infant.Mortality), data) 
model_1
summary(model_1) # R^2 = 0.56;

vif(model_1) # VIF ����� ������� => ������������ �������� �����������.

# Examination                  #Infant.Mortality                  #I(Examination^2)             #I(Infant.Mortality^2)        #I(Examination * Infant.Mortality) 
# 57.83822                         159.19511                          15.68486                         114.72434                          64.08134 

# �4.2 ����� ����������� �� ����������� � ������������ VIF, ���� ��� VIF �� �������� ������ 10:

model_2 = lm(Fertility ~ Examination + I(Examination^2) + I(Infant.Mortality^2) + I(Examination*Infant.Mortality), data) 
model_2
summary(model_2) # R^2 = 0.55;

vif(model_2)
# Examination                  #I(Examination^2)             #I(Infant.Mortality^2)      #I(Examination * Infant.Mortality) 
# 35.27631                          13.98831                           3.77449                          27.15829

model_3 = lm(Fertility ~ I(Examination^2) + I(Infant.Mortality^2) + I(Examination*Infant.Mortality), data) 
model_3
summary(model_3) # R^2 = 0.53;

vif(model_3)
# I(Examination^2)             #I(Infant.Mortality^2)     #I(Examination * Infant.Mortality) 
# 10.292239                          2.415118                         10.486468 

model_4 = lm(Fertility ~ I(Examination^2) + I(Infant.Mortality^2), data) # F = -0.2*I(Ex^2) + 0.04*I(Inf.M^2) + 63.49; 
model_4
summary(model_4) # R^2 = 0.5;p-���������� ������� 

vif(model_4)
# I(Examination^2)  #I(Infant.Mortality^2) 
# 1.027175              1.027175

# �����: ��������� ������ - ��� "F = -0.2*I(Ex^2) + 0.04*I(Inf.M^2) + 63.49", �.�. VIF() ���������� �� ���� ����������� ������������ <5.