# Analysis - 1) 탐색적 자료 분석(Exploratory Data Analysis)
#               -> 저항성, 잔차의 해석, 자료의 재표현, 자료의 현시성
## 자료의 현시성 : 자료를 빠르게 그래프로 그리고 그래프를 통해 자료의 특징을 찾아내고 탐색하는 것.
#            2) 확증적 자료 분석(Confirmatory Data Analysis)

# 값을 나타내는 그래프 : 막대 그래프, Boxplot, Histogram ----
## 일변량 그래프

# 막대 그래프 / 파이 차트 ----
# (1) 명목형 변수를 나타내기 좋은 그래프.
# (2) 명목형 변수는 수치적 의미가 없기 때문에 빈도수(Frequency)를 나타내거나
#     다른 수치형 변수의 평균과 같은 값을 나타내기에 좋다.
# (3) 명목형 변수는 전체에서 각가 요소가 차지 하는 비율인 '상대도수'를 그래프로 나타낼 수 있다.
# (4) 파이 차트는 '상대도수'와 같이 비율을 나타내는 대표적인 그래프.

# 히스토그램(Histogram) ----
# (1) 막대 그래프는 막대가 떨어져 있고, 히스토그램은 붙어 있어야 한다.
# (2) 막대 그래프는 막대의 높이값만 의미가 있고, 히스토그램은 막대의 면적에도 의미가 있다.
# (3) 막대 그래프 X축 변수 : 이산형, 명목형, 순서형 변수 (독립적)
# (4) 히스토그램 X축 변수 : 수치형, 연속형 변수 / 가장 중요한 것 : 계급 크기를 정하는 것
# (5) 상대도수밀도 = 상대도수 / 계급간격

# 상자 그래프(Box Plot) ----
# (1) 수치형 연속변수만 나타낼 수 있는 그래프.

## 다변량 그래프
# 변수 관계를 나타내는 그래프 ----
# 산포도 ----
# (1) ~에 따라 ~가 어떻게 된다. / 두 변수는 상관관계가 있다.
# (2) Y축의 종속변수를 설명하기 위해 X축에 놓을 수 있는 독립변수를 찾는것이 목표

# R에서 그래프를 그리는 3가지 이유 ----
# 1. 빠르게 데이터를 탐색하기 위해 그래프 그리기(EDA - 탐색적 자료분석) - plot()
# 2. 보다 정교한 데이터의 특징을 나타내기 위해 그래프 그리기 - package::ggplot2
# 3. Report를 위한 그래프 packages::rCharts

# EDA를 위한 그래프 그리기(R Basic Graph) ----
# plot() ----
DF <- read.csv("example_studentlist.csv")
detach(DF)
attach(DF)
str(DF)
plot(age)
plot(height, weight) # x, y
plot(weight ~ height) # y ~ x (종속변수 ~ 독립변수)
plot(height, sex)
plot(sex, height)

(DF2 <- data.frame(DF$height, DF$weight))
plot(DF2)
(DF3 <- cbind(DF2, DF$age))
plot(DF3)
plot(DF) # 그래프에 사용되는 변수 : 수치형, 명목형(다른 type이라면 error)

# levels별 그래프
plot(weight ~ height, pch = as.integer(sex)) # pch : 점의 종류 결정
legend("topleft", c("남", "여"), pch = DF$sex)
coplot(weight ~ height | sex) # 조건화 그래프

# 제목 달기, X축 이름 달기 등 ----
plot(weight ~ height, ann = F) # 아무 label도 출력이 안되게 한다.
title(main = "A대학 B학과생 몸무게와 키의 상관관계")
title(xlab = "키")
title(ylab = "몸무게")
grid()
weightMean <- mean(height)
abline(v = weightMean, col = "red") # 가로 : h, 세로 : v
                                    # R의 기본 그래프는 빠르게 탐색하기 위한 용도로만 사용 ----

# barplot() ----
(FreqBlood <- table(DF$bloodtype))
barplot(FreqBlood)
title(main = "혈액형별 빈도수")
title(xlab = "혈액형")
title(ylab = "빈도수")
 
(Height <- tapply(DF$height, DF$bloodtype, mean))
barplot(Height, ylim = c(0, 200)) # ylim : Y축의 범위 설정
plot(bloodtype)

# boxplot() ----
boxplot(height)
boxplot(height ~ bloodtype)

# hist() ----
hist(height)
hist(height, breaks = 10) # Y축 : 빈도수
hist(height, breaks = 10, prob = T) # Y축 : 상대도수밀도
lines(density(height))
BreakPoint <- seq(min(height), max(height) + 7, by = 7)
hist(height, breaks = BreakPoint)
DiffPoint <- c(min(height), 165, 170, 180, 185, 190)
hist(height, breaks = DiffPoint) # 계급이 서로 다른 경우

# 기본 그래프 함수 활용 ----
## 한 화면에 여러 개 그래프 그리기 ----
par(mfrow = c(2, 3))
plot(weight, height)
plot(sex, height)
barplot(table(bloodtype))
boxplot(height)
boxplot(height ~ bloodtype)
hist(height, breaks = 10)
par(mfrow = c(1, 1)) # 원래대로 돌리기

## 한 그래프에 두 그래프를 겹쳐 나타내기 ----
(TS1 <- c(round(runif(30) * 100))) # round(숫자형 객체, 자리수)
(TS2 <- c(round(runif(30) * 100)))
(TS1 <- sort(TS1, decreasing = F))
(TS2 <- sort(TS2, decreasing = F))
plot(TS1, type = "l")
lines(TS2, lty = "dashed", col = "red")

x1 <- seq(1, 100, 1)
y1 <- dbinom(x1, 100, 0.25)
x2 <- seq(1, 50, 1)
y2 <- dbinom(x2, 50, 0.5)
plot(x1, y1, type = "h", ylim = c(0, 0.2)) # type = "h" 막대그래프
lines(x2, y2, col = "red")

DF1 <- data.frame(x = x1, y = y1, t = 1)
DF2 <- data.frame(x = x2, y = y2, t = 2)
DF <- rbind(DF1, DF2)
plot(DF$y ~ DF$x, type = "p", pch = DF$t, col = c("red", "blue"))

## type 인자 살펴보기 ----
plot(x1, y1, type = "p") # 동그라미
plot(x1, y1, type = "l") # 라인그래프
plot(x1, y1, type = "c") # 산점도 영역을 제외시킨 그래프
plot(x1, y1, type = "b") # c와 p를 함께 나타낸 그래프
plot(x1, y1, type = "o") # l과 p를 함께 나타낸 그래프
plot(x1, y1, type = "h") # 막대 그래프
plot(x1, y1, type = "s") # 막대 그래프 영역



# package::ggplot2, ggthemes ---
library(ggplot2)
library(ggthemes)
ggplot(data = diamonds, aes(x = carat, y = price, colour = clarity)) +
  geom_point() + theme_wsj()
g1 <- ggplot(data = diamonds, aes(x = carat, y = price, colour = clarity))
g2 <- geom_point()
g3 <- theme_wsj()
g1 + g2 + g3
g1 + g2 + theme_bw()

## ggplot() ----
## 미적 요소 매핑(aesthetic mapping)
## -> 주로 사용할 데이터를 x축, y축, colour등 그래프 요소에 매핑하는 일
## geom() ----
## 어떤 그래프를 그릴지 선택 : geom_point(), geom_line(), ... - 기하객체(geometric object)
DF <- read.csv("example_studentlist.csv")
g1 <- ggplot(DF, aes(x = height, y = weight, colour = bloodtype))
g1 + geom_point()
g1 + geom_line()
g1 + geom_line() + geom_point()
g1 + geom_line(size = 1) + geom_point(size = 10)
g1 + geom_line(aes(colour = sex), size = 1) + geom_point(size = 10)

## facet_grid() ----
## -> 명목형 변수를 기준으로 나눠서 별도의 그래프를 그려준다.
## 목적 : 명목형 변수의 level을 기준으로 나눠서 서로 비교하는 것.
g1 + geom_point(size = 10) + geom_line(size = 1) + facet_grid(. ~ sex)
g1 + geom_point(size = 10) + geom_line(size = 1) + facet_grid(sex ~ .) # y축 : 성별
g1 + geom_point(size = 10) + geom_line(size = 1) + facet_grid(sex ~ ., scales = "free")
                                                   # 각각의 그래프 범위가 같지 않아야 한다.
g1 + geom_point(size = 10) + geom_line(size = 1) + facet_grid(. ~ sex, scales = "free")
                                                   # facet_grid는 y축에 대해서는 스케일 허용X
g1 + geom_point(size = 10) + geom_line(size = 1) + facet_wrap(~ sex, scales = "free")

## facet_grid() / facet_wrap() ----
g <- ggplot(mpg, aes(displ, hwy))
g + geom_point()
g + geom_point() + facet_grid(. ~ class)
g + geom_point(alpha = .3) + facet_grid(cyl ~ class, scales = "free")
                             # 명목형 변수들의 level별로 나눠서 그래프를 보여주는 목적으로 사용
g + geom_point(alpha = .3) + facet_wrap(cyl ~ class, scales = "free")
                             # 각각의 그래프를 별도로 모아서 보기 위함.
g + geom_point(alpha = .3) + facet_wrap(cyl ~ class, scales = "free", ncol = 3)

## geom_bar() ----
ggplot(DF, aes(x = bloodtype)) + geom_bar()
ggplot(DF, aes(x = bloodtype, fill = sex)) + geom_bar()
ggplot(DF, aes(x = bloodtype, fill = sex)) + geom_bar(position = "dodge")
                                             # 하나의 막대에 누적되지 않게 각각의 막대로 표시.
ggplot(DF, aes(x = bloodtype, fill = sex)) + geom_bar(position = "identity")
                                             # 더해지지 않고 겹쳐서 표시.
ggplot(DF, aes(x = bloodtype, fill = sex)) + geom_bar(position = "fill")
                                             # 누적 그래프
ggplot(DF, aes(x = bloodtype, fill = sex)) + geom_bar(position = "dodge", width = 0.3)
                                             # 막대의 넓이값 변경.
(mheightByblo <- tapply(DF$height, DF$bloodtype, mean))
DF2 <- as.data.frame(mheightByblo)
DF2$bloodtype <- rownames(DF2)
rownames(DF2) <- NULL
DF2
ggplot(DF2, aes(x = bloodtype, y = mheightByblo, fill = bloodtype)) +
  geom_bar(stat = "identity") + scale_fill_brewer() # bin(default) : 빈도수, identity : 그대로 값

## geom_histogram() ----
g1 <- ggplot(diamonds, aes(x = carat))
g1 + geom_histogram(binwidth = 0.1, fill = "orange") # y축 : 도수
g1 + geom_histogram(aes(y = ..count..), binwidth = 0.1, fill = "orange") # '..' : 예약어
g1 + geom_histogram(aes(y = ..ncount..), binwidth = 0.1, fill = "orange") # 표준화된 도수값
g1 + geom_histogram(aes(y = ..density..), binwidth = 0.1, fill = "orange") # 밀도값
g1 + geom_histogram(aes(y = ..ndensity..), binwidth = 0.1, fill = "orange") # 표준화된 밀도값

## 그룹별로 따로 그래프 그리기 ----
g1 + geom_histogram(binwidth = 0.1, fill = "orange") + facet_grid(color ~ .)
g1 + geom_histogram(binwidth = 0.1, fill = "orange") + facet_grid(color ~ ., scales = "free")

## levels별로 겹쳐서 보기 ----
g1 + geom_histogram(aes(fill = color), binwidth = 0.1, alpha = 0.5)

## geom_point() ----
DF <- read.csv("example_studentlist.csv")
g1 <- ggplot(DF, aes(x = weight, y = height))
g1 + geom_point()
g1 + geom_point(aes(colour = sex), size = 7)
g1 + geom_point(aes(colour = sex, shape = sex), size = 7)
g1 + geom_point(aes(colour = sex, shape = bloodtype), size = 7)
g1 + geom_point(aes(colour = height, shape = sex), size = 7)
g1 + geom_point(aes(size = height, shape = sex), colour = "orange")
g1 + geom_point(aes(colour = sex, shape = bloodtype), size = 7, alpha = 0.6)
g1 + geom_point(aes(colour = sex), size = 7) + geom_smooth(method = "lm")
g1 + geom_point(aes(colour = sex), size = 7) + geom_text(aes(label = name))
g1 + geom_point(aes(colour = sex), size = 7) + geom_text(aes(label = name),
                                                         vjust = -1.1, colour = "grey35")

## theme() ----
g1 + geom_histogram(aes(y = ..ndensity..), binwidth = 0.1, fill = "orange") + theme_wsj()
