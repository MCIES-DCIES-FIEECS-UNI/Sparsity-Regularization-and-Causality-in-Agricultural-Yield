#======================================================
# Modelo ELASTIC NET
#======================================================

library(mgcv)
library(readxl)
library(glmnet)

DataTrainR <- read.csv("C:/Users/User/Downloads/DataTrainR (1).csv")
DataTestR <- read.csv("C:/Users/User/Downloads/DataTestR (1).csv")

VarFull = colnames(DataTrainR)
Var = VarFull[-which(VarFull == "Rendimiento_T_ha")] 
X_train <- DataTrainR[Var]
y_train <- DataTrainR["Rendimiento_T_ha"]

X_train[] <- lapply(X_train, function(x) if (is.logical(x)) as.numeric(x) else x)
class(X_train$TEMP_ACEL_1)

VarBool = colnames(X_train)[109:128]

X_train[VarBool] <- lapply(X_train[VarBool], function(x) x == "True")

as.matrix(X_train)

cvfit <- cv.glmnet(as.matrix(X_train), y_train$Rendimiento_T_ha, 
                   alpha = 0.02, standardize = TRUE)
# cv.glmnetdevuelve un cv.glmnetobjeto, una lista con todos los ingredientes del ajuste validado de forma cruzada. 
plot(cvfit)

# Podemos utilizar el siguiente código para obtener el valor de lambda.miny los coeficientes del modelo en ese valor dela:
cvfit$lambda.min

coef(cvfit, s = "lambda.min")


#===================================================
# MSE train
#===================================================
X_train <- as.matrix(sapply(X_train, as.numeric))

# Realiza la predicción con la lambda óptima

ypred <- predict(cvfit, newx = X_train, s = "lambda.min")

# Calcular el MSE
mse <- mean((y_train$Rendimiento_T_ha - ypred)^2)

# Mostrar el MSE
print(paste("El MSE es:", mse))

#===================================================
# MSE test
#===================================================
X_test <- DataTestR[Var]
y_test <- DataTestR["Rendimiento_T_ha"]
X_test[VarBool] <- lapply(X_test[VarBool], function(x) x == "True")

X_test <- as.matrix(sapply(X_test, as.numeric))

# Realiza la predicción con la lambda óptima

ypred <- predict(cvfit, newx = X_test, s = "lambda.min")

# Calcular el MSE
mse <- mean((y_test$Rendimiento_T_ha - ypred)^2)

# Mostrar el MSE
print(paste("El MSE es:", mse))


#===========================================================
# MODELO GAM
#===========================================================
DataTrainR[VarBool] <- lapply(DataTrainR[VarBool], function(x) x == "True")
DataTestR[VarBool] <- lapply(DataTestR[VarBool], function(x) x == "True")


DataTrainR[VarBool] = DataTrainR[VarBool]* 1
DataTestR[VarBool] = DataTestR[VarBool] * 1

text <- "Rendimiento_T_ha ~ s(NDVI_ACEL_1, k=3)+s(NDVI_ACEL_2, k=3)+s(NDVI_ACEL_3, k=3)+s(NDVI_ACEL_4, k=3)+
        s(NDVI_ACEL_5, k=3) + s(NDVI_ACEL_6,k=3) + s(NDVI_ACEL_7,k=3)+s(NDVI_ACEL_8,k=3) +s(NDVI_ACEL_9,k=3)+
        s(NDVI_ACEL_10, k=3) + s(NDVI_ACEL_11, k=3) + s(NDVI_VEL_1, k=3)+ s(NDVI_VEL_2, k=3) + s(NDVI_VEL_3, k=3) + 
        s(NDVI_VEL_4, k=3) + s(NDVI_VEL_5,k=3) + s(NDVI_VEL_6,k=3) + s(NDVI_VEL_7,k=3) + s(NDVI_VEL_8,k=3) + s(NDVI_VEL_9,k=3)+
        s(NDVI_VEL_10,k=3) + s(NDVI_VEL_11,k=3) + s(NDVI_VEL_12,k=3) +
        s(PREC_ACEL_1, k=3) +s(PREC_ACEL_2, k=3) + s(PREC_ACEL_3, k=3) + s(PREC_ACEL_4, k=3) + s(PREC_ACEL_5, k=3)+
        s(PREC_ACEL_6, k=3) + s(PREC_ACEL_7, k=3) + s(PREC_ACEL_8, k=3) + s(PREC_ACEL_9, k=3) + s(PREC_ACEL_10, k=3)+
        s(PREC_ACEL_11, k=3) + s(PREC_VEL_1, k=3) + s(PREC_VEL_2, k=3) + s(PREC_VEL_3, k=3) + s(PREC_VEL_4, k=3) + 
        s(PREC_VEL_5, k=3) + s(PREC_VEL_6, k=3) + s(PREC_VEL_7, k=3) + s(PREC_VEL_8, k=3) + 
        s(PREC_VEL_9, k=3) + s(PREC_VEL_10, k=3) + s(PREC_VEL_11, k=3) + s(PREC_VEL_12, k=3) +
         
        s(TEMP_ACEL_1, k=3) + s(TEMP_ACEL_2, k=3) +s(TEMP_ACEL_3, k=3) + s(TEMP_ACEL_4, k=3) + s(TEMP_ACEL_5, k=3) + 
        s(TEMP_ACEL_6, k=3) +  s(TEMP_ACEL_7, k=3) + s(TEMP_ACEL_8, k=3) + s(TEMP_ACEL_9, k=3) + s(TEMP_ACEL_10, k=3)+
        s(TEMP_ACEL_11, k=3) + s(TEMP_VEL_1, k=3) + s(TEMP_VEL_2, k=3) + s(TEMP_VEL_3, k=3) + s(TEMP_VEL_4, k=3) + s(TEMP_VEL_5, k=3)+
        s(TEMP_VEL_6, k=3) +s(TEMP_VEL_7, k=3) + s(TEMP_VEL_8, k=3) + s(TEMP_VEL_9, k=3)+
        s(TEMP_VEL_10, k=3) + s(TEMP_VEL_11, k=3) + s(TEMP_VEL_12, k=3) + CCDD_13 + CCDD_14 + CCDD_16 + CCDD_17  +
        CCDD_20 + CCDD_22 + CCDD_24 + CCDD_4 + P211_1_1.0 + P211_2_1.0 + P211_4_1.0 + P212_2 + P212_3 +
        P212_4 + P212_5 + P212_6 + P212_7 + P213_7.0 + P214_2"

# Convertir la cadena en una fórmula
formula <- as.formula(text)

# Ajustar el modelo utilizando la fórmula
b <- gam(formula, data = DataTrainR)
summary(b)
#==============================
# TRAIN
#==============================
train_predictions <- predict(b, newdata = DataTrainR)
train_actual <- DataTrainR$Rendimiento_T_ha
train_mse <- mean((train_predictions - train_actual)^2)
train_mse
#==============================
# TEST
#==============================
test_predictions <- predict(b, newdata = DataTestR)
test_actual <- DataTestR$Rendimiento_T_ha
test_mse <- mean((test_predictions - test_actual)^2)
test_mse
