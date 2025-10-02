install("agricolae") #分析需要的Package
install("ggplot2") #畫圖需要的Package
install(PMCMRplus) #跑Tukey用的package
install("data.table")
library("agricolae")#然後把上面安裝的Package叫出來，才可以使用它的功能
library("ggplot2")
library(PMCMRplus)
setwd("D:/cch_data/fly_RTA") 
library("data.table")
library(dplyr)
#表格讀入R，並指定表格名稱為RTAfly
RTAfly<-fread(
	file="all_fly_data_for_R.txt", #檔案名稱
	header=T, #將第一列作為欄名
	data.table=F
	)
	
#下面直接寫一個指令一次跑所有性狀	
variables <- setdiff(names(RTAfly), "treat")
# 建立一個 list 存結果
anova_results <- list()
tukey_results <- list()
group_summaries <- list()
# 依序分析每個變項
for (var in variables) {
  formula <- as.formula(paste(var, "~ treat"))
  
  # 執行 ANOVA
  anova_model <- aov(formula, data = RTAfly)
  anova_results[[var]] <- summary(anova_model)
  
  # 執行 Tukey HSD
  tukey_model <- TukeyHSD(anova_model)
  tukey_results[[var]] <- tukey_model
  
  # 分組摘要：產生分組字母 a, b, ab 等
  tukey_letters <- multcompView::multcompLetters4(anova_model, tukey_model)
  group_summaries[[var]] <- tukey_letters
}
# 直接叫所有結果檢視某一個變項的結果就加$EyeSize1(性狀名)
anova_results
tukey_results
group_summaries
