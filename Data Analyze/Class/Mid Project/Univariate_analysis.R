# 安裝需要的包
install.packages("ggplot2")
library(ggplot2)
library(dplyr)

# 讀取CSV檔
data <- read.csv("C:/Users/hsian/Documents/GitHub/Learning_in_college/Massive_Data_Analysis/DataAnalyze/Data Analyze/Mid Project/IceHockey2023VsSalary.csv")
# 將連續性變量從字串轉換為數值型
data$Salary <- as.numeric(gsub(",", "", data$Salary))
data$Cap.Hit <- as.numeric(gsub(",", "", data$Cap.Hit))
sapply(data, class)
names(data)

# 找到數值型特徵的中位數並填充缺失值
options(scipen = 999) # 禁用科学计数法
medians <- sapply(data, function(col) ifelse(is.numeric(col), median(col, na.rm = TRUE), NA))
medians
data <- apply(data, 2, function(col) ifelse(is.numeric(col) & is.na(col), medians[col], col))
data <- as.data.frame(data)
View(data)

# 密度曲線圖
data$Team <- as.factor(data$Team)
Team_den <- ggplot(data, aes(x = Team, fill = Team)) +
  geom_density(alpha = 0.5) +
  labs(title = "Density Boxplot of Team",
       x = "Team",
       y = "Density")
print(Team_den)

# 繪製直方圖
Team_count_bar <- ggplot(data, aes(x = Team, fill = Team)) +
  geom_bar() +
  labs(title = "Histogram of Team",
       x = "Team",
       y = "Count")

print(Team_count_bar)

# 連續性變數的密度的資料前處理
data$GP <- as.numeric(data$GP)
data$G <- as.numeric(data$G)
data$A <- as.numeric(data$A)
data$Pts <- as.numeric(data$Pts)
data$X... <- as.numeric(data$X...)
data$PN <- as.numeric(data$PN)
data$PIM <- as.numeric(data$PIM)
data$S <- as.numeric(data$S)
data$SB <- as.numeric(data$SB)
data$MS <- as.numeric(data$MS)
data$H <- as.numeric(data$H)
data$GV <- as.numeric(data$GV)
data$TK <- as.numeric(data$TK)
data$BS <- as.numeric(data$BS)
data$FW <- as.numeric(data$FW)
data$FL <- as.numeric(data$FL)
data$F. <- as.numeric(data$F.)
data$Salary <- as.numeric(data$Salary)
data$Cap.Hit <- as.numeric(data$Cap.Hit)
# 計算 GP 變量的密度
density_values <- density(data$GP)
# 創建一個包含 GP 和密度的數據框
density_data <- data.frame(GP = density_values$x, Density = density_values$y)
# 繪製GP密度曲線圖
p <- ggplot(density_data, aes(x = GP, y = Density)) +
  geom_line(color = "blue") +
  geom_area(fill = "lightblue", alpha = 0.5) +
  labs(title = "Density Curve of GP",
       x = "GP",
       y = "Density")

print(p)


# 連續性變數的密度的線性圖
for (col in names(data)) {
  if (is.numeric(data[[col]])) {
    # 連續性變數創建線性圖
    density_values <- density(data[[col]], na.rm = TRUE)  # 修正此行
    density_data <- data.frame(col = density_values$x, Density = density_values$y)
    p <- ggplot(density_data, aes(x = col, y = Density)) +  # 修正此行
      geom_line(color = "blue") +
      geom_area(fill = "lightblue", alpha = 0.5) +
      labs(title = paste("Density Curve of", col),  # 修正此行
           x = col,  
           y = "Density")
    
    print(p)
  }
}

# 创建一个空的数据框用于存储结果
summary_df <- data.frame(Variable = c(), 
                         Min = c(), 
                         Q1 = c(), 
                         Median = c(), 
                         Q3 = c(), 
                         Max = c())

for (col in names(data)) {
  if (is.numeric(data[[col]])) {
    summary_var <- summary(data[[col]])
    summary_df <- rbind(summary_df, data.frame(Variable = col,
                                               Min = summary_var[[1]],
                                               Q1 = summary_var[[2]],
                                               Median = summary_var[[3]],
                                               Q3 = summary_var[[5]],
                                               Max = summary_var[[6]]))
  }
}
summary_df

summary(data$GP)
