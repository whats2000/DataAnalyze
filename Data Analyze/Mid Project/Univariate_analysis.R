# 安裝需要的包
install.packages("ggplot2")
library(ggplot2)

# 讀取CSV檔
data <- read.csv("C:/Users/hsian/Documents/GitHub/Learning_in_college/Massive_Data_Analysis/DataAnalyze/Data Analyze/Mid Project/IceHockey2023VsSalaryVsPlayer.csv")
View(data)

# 找到數值型特徵的中位數並填充缺失值
medians <- sapply(data, function(col) ifelse(is.numeric(col), median(col, na.rm = TRUE), NA))
medians
data <- apply(data, 2, function(col) ifelse(is.numeric(col) & is.na(col), medians[col], col))
View(data)

data <- as.data.frame(data)


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
# 單變量分析
for (col in names(data)) {
  if (is.numeric(data[[col]])) {
    # 連續性變數創建線性圖
    p <- ggplot(data, aes(x = data[[col]])) + geom_line(color = "blue")
    print(p)
  } else {
    # 類別性變數創建直方圖
    p <- ggplot(data, aes(x = data[[col]])) + geom_histogram(binwidth = 1, fill = "lightblue", color = "black")
    print(p)
  }
}


