library(readr)
library(dplyr)
library(ggplot2)
library(caret)
library(foreach)
library(pROC)          
library(verification)
library(psych)
library(tidyverse)
library(kableExtra)

#import data
warcolony <- read_csv("Data/warcolonyfinal.csv")
warcolony <- warcolony %>% dplyr::select(-c(...1))

warcolony <- warcolony[complete.cases(warcolony$war), ]
warcolony <- warcolony[complete.cases(warcolony$decolonized),]

#generate models - how does war impact decolonization?
#include following control factors in all - population, region
#note: no ideology model - too many missing values :(
#base model - colony at war
#uses all observations
colwar.f <- formula(decolonized ~
                      war + #flags for war (prev. year)
                      lnpop + #population / 1,000, logged + lagged
                      factor(region))  #regional factor

#secondary model - colonizer at war + resource interest (coastline, mountains, land area)
#uses 13k observations
impwar.f <- formula(decolonized ~
                      colonizer_warsum + #num of wars involved prev. year
                      lncoast + #coastal land (logged)
                      lnmtn + #rocky terrain (logged) (neg. effect expected)
                      lnpop + #population / 1,000, logged + lagged
                      factor(region)) #regional factor
#third model - colony at war + details (democracy, war type, etc.)
#uses 13k observations
coltypewar.f <- formula(decolonized ~ 
                          factor(wartype) +  #indicator of war type 
                          colonizer_demoscore + #democracy score of colonizer (prev. year)
                          lnpop + #population / 1,000, logged + lagged
                          factor(region)) #regional factor

#set up cross-validation and AUC-ROC curve creation
formulas <- list(colwar = colwar.f, colmot = coltypewar.f, impwar = impwar.f)
probabilities <- list()
roc_result <- list()
avg <- list()

#set seed list
set.seed(42)
iseed <- sample(2:10000,10, replace = FALSE) #10 seeds for 10 loops

for (fml_name in names(formulas)) {
  #select formula of interest
  fml <- formulas[[fml_name]]
  
  #obtain necessary columns and predictors - include country and year to uniquely ID probs
  predict_names <- all.vars(formula(fml))
  predict_names <- c("country", "year", predict_names)
  
  #lists to hold model info and probability values
  models <- list()
  probabilities[[fml_name]] <- list() 
  
  #complete observations only for the model
  warcolsub <- warcolony[, c(predict_names)]
  warcolsub <- warcolony[complete.cases(warcolsub), ]
  
  #count rows
  rows <- nrow(warcolsub)
  
  for(j in seq_along(iseed)){
    #divide data subset into five randomly generated "folds"
    set.seed(iseed[j]) #random seed, keep consistent across all models
    folds <- sample(rep(1:5, length.out = rows))
    warcolsub$fold <- folds
    
    #probability column
    warcolsub$pr <- NA
  
  for (i in 1:5) {
    #identify test data and training data
    warcoltrain <- warcolsub[warcolsub$fold != i, ] #train on 4/5 of the data
    warcoltest  <- warcolsub[warcolsub$fold == i, ] #test on 1/5 of the data
    
    #establish cut point
    cutp <- mean(warcoltrain$decolonized)
    
    #produce the model
    models[[i]] <- glm(fml, data = warcoltrain, family = binomial)
    
    #use model estimates and test data to probability values (1/5)
    warcoltest$pr <- predict(models[[i]], newdata = warcoltest, type = "response")
    
    #add probabilities to test dataset
    warcolsub$pr[warcolsub$fold == i]  <- warcoltest$pr
  
    }
    #formula metrics for each iteration (j)
    probabilities[[fml_name]][[j]] <- list(pr = warcolsub$pr)
    warcolsub[[paste0("pr", j)]] <- probabilities[[fml_name]][[j]]$pr
    
  }
  #compute total mean 
  coln <- c("pr1", "pr2", "pr3", "pr4", "pr5", "pr6", "pr7" , "pr8", "pr9", "pr10")
  warcolsub$prJavg <- rowMeans(warcolsub[,coln], na.rm = TRUE)
  
  #area under the curve
  roc_result[[fml_name]] <- roc.area(warcolsub$decolonized, warcolsub$prJavg)
  avg[[fml_name]] <- mean(warcolsub$prJavg)
  
  #get column names
  rpr <- warcolsub[, c("country", "year", "prJavg")]
  names(rpr)[names(rpr) == "prJavg"] <- fml_name  
  
  #merge datasets - should show computed probabilites per model
  warcolony <- merge(warcolony, rpr, by = c("country","year"), all = TRUE) 
}

#predication and observation columns for ROC
pred <- warcolony[, c("colwar", "colmot", "impwar")]
obs <- warcolony$decolonized

#assign colors for plot lines
colors <- c("#91c0ce","#81d664", "#0e8474") 
roc_objs <- list()

#prepare the AUC-ROC curves
for (i in 1:ncol(pred)) {
  roc_objs[[i]] <- roc(obs, pred[[i]])
  if (i == 1){
    roc_objs[[i]] <- roc(obs, pred[[i]])
    pROC::plot.roc(roc_objs[[i]], col = colors[i], lwd = 2, print.auc = FALSE, print.auc.y = 0.6 - 0.1*i,
    print.auc.cex = 0.6)
  }
  else{
    roc_objs[[i]] <- roc(obs, pred[[i]])
    pROC::plot.roc(roc_objs[[i]], col = colors[i], lwd = 2, print.auc = FALSE, print.auc.y = 0.6 - 0.1*i,
                   print.auc.cex = 0.6, add = TRUE)
    
  }
}
legend("bottomright", legend = paste0(names(pred), ": AUC = ", round(sapply(roc_objs, auc), 3)),
       col = colors, lwd = 2, inset = 0.05, cex = .35)
auc_vals <- round(sapply(roc_objs, auc), 2) 
names(roc_objs) <- paste0(names(pred), ": AUC = ", auc_vals)

#plot the curves
rplot <- ggroc(roc_objs, size = 1.25) +
  scale_color_manual(values = colors) +
  labs(title = "ROC-AUC Plot of War-Decolonization Models", 
       x = "Specificity (False Positive Rate)", 
       y = "Sensitivity (True Positive Rate)") + 
  theme_minimal() +
  theme(
        legend.position = c(0.7, 0.25),  # inside plot, near bottom right
        legend.background = element_rect(fill = "white", color = "black"),
        legend.title = element_blank(),
        legend.text = element_text(size = 12),
        legend.key.size = unit(0.4, "cm"),      
        legend.spacing.y = unit(0.2, "cm"),             
        plot.title = element_text(size = 12))
rplot


#model specificity and sensitivity table 
results <- data.frame(model = character(), spec=numeric(),sens=numeric(),
                      mean_correct = numeric(), stringsAsFactors = FALSE)  
cutp <- mean(warcolony$decolonized)
warcolony$colpred <- ifelse(warcolony$colwar >= cutp, 1, 0)
warcolony$colmotpred <- ifelse(warcolony$colmot >= cutp, 1, 0)
warcolony$imppred <- ifelse(warcolony$impwar >= cutp, 1, 0)

#model 1
c1 <- confusionMatrix(data = as.factor(warcolony$colpred),
                      reference = as.factor(warcolony$decolonized))
spec <- c1$byClass["Sensitivity"]
sens <- c1$byClass["Specificity"]
warcolony$colcorrect <- (warcolony$colpred >= cutp & warcolony$decolonized == 1) |
  (warcolony$colpred < cutp & warcolony$decolonized == 0)
mean_correct <- mean(warcolony$colcorrect, na.rm = TRUE)
results <- rbind(results, 
                 data.frame(model = "colwar", 
                            mean_correct = mean_correct,
                            sens = sens,
                            spec = spec))

#model 2
c2 <- confusionMatrix(data = as.factor(warcolony$colmotpred),
                      reference = as.factor(warcolony$decolonized))
spec <- c2$byClass["Sensitivity"]
sens <- c2$byClass["Specificity"]
warcolony$colmotcorrect <- (warcolony$colmotpred >= cutp & warcolony$decolonized == 1) |
  (warcolony$colmotpred < cutp & warcolony$decolonized == 0)
mean_correct <- mean(warcolony$colmotcorrect, na.rm = TRUE)
results <- rbind(results, 
                 data.frame(model = "colmot", 
                            mean_correct = mean_correct,
                            sens = sens,
                            spec = spec))

#model 3
c3 <- confusionMatrix(data = as.factor(warcolony$imppred),
                      reference = as.factor(warcolony$decolonized))
spec <- c3$byClass["Sensitivity"]
sens <- c3$byClass["Specificity"]
warcolony$impcorrect <- (warcolony$imppred >= cutp & warcolony$decolonized == 1) |
  (warcolony$imppred < cutp & warcolony$decolonized == 0)
mean_correct <- mean(warcolony$impcorrect, na.rm = TRUE)
results <- rbind(results, 
                 data.frame(model = "impwar", 
                            mean_correct = mean_correct,
                            sens = sens,
                            spec = spec))

rownames(results) <- NULL

results_table <- results %>% kable(
  col.names = c(" ", "Avg. Correct", "Sensitivity", "Specficity"),
  caption = "War-Decolonization Model Accuracy", 
  digit = 4) %>% 
  kable_classic()
results_table


rm(list = ls())



