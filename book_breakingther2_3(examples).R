# Example01 - 섬세한 그래프를 그려 데이터 분석하기 ----
# package : ggplot2, ggthemes
# Step1. 데이터를 확인한다.
str(diamonds)

# Step2. 필요한 패키지를 불러온다.
library(ggplot2)
library(ggthemes)

# Step3. 그래프를 그린다.
ggplot(diamonds, aes(x = x, y = price)) + geom_point()
ggplot(diamonds, aes(x = x, y = price, colour = clarity)) + geom_point()
                                       # 어떤 clarity는 여러 값에 분포되어 있어 price에 영향을
                                       # 미치지 않지만 어떤 clarity는 특정 price에 몰려있다.
                                       # price가 낮은 다이아몬드에 쓰이는 clarity와 price가
                                       # 높은 다이아몬드에 쓰이는 clarity가 있을 것이다.

# Step4. 테마를 적용한다.
ggplot(diamonds, aes(x = x, y = price, colour = clarity)) + geom_point() + theme_solarized_2()

# Step5. Alpha값을 조절한다.
ggplot(diamonds, aes(x = x, y = price, colour = clarity)) + geom_point(alpha = 0.03) + 
  theme_solarized_2() # price가 8000까지 몰려있고 그 이상부터 개수가 
                      # 급격히 떨어지는 것을 확인할수 있다.

# Step6. legend만 alpha값이 1이 되도록 한다.
ggplot(diamonds, aes(x = x, y = price, colour = clarity)) + geom_point(alpha = 0.03) +
  guides(colour = guide_legend(override.aes = list(alpha = 1))) + theme_solarized_2()
                  # guide함수를 이용해 범례를 재정의

# Step7. X축과 Y축의 범위를 줄인다.
ggplot(diamonds, aes(x = x, y = price, colour = clarity)) + geom_point(alpha = 0.03) +
  geom_hline(yintercept = mean(diamonds$price), color = "turquoise3", alpha = .8) +
  guides(colour = guide_legend(override.aes = list(alpha = 1))) + xlim(3, 9) +
  theme_solarized_2()


# Example02 - 시계열데이터 라인 그래프로 나타내기 ----
# package : ggplot2, ggthemes
# Step1. 데이터를 불러온다.
(TS <- read.csv("example_ts.csv"))

# Step2. 필요한 패키지를 불러온다.
library(ggplot2)
library(ggthemes)

# Step3. 그래프를 그려본다.
ggplot(TS, aes(x = Date, y = Sales)) + geom_line() # 모든 값이 표시되지 않는다.
                                                   # 1. 연속된 날짜 값으로 바꿔주기
                                                   # 2. 모든 값을 요인 값으로 바꿔주기

# Step4. factor()함수로 요인화 한다.
ggplot(TS, aes(x = factor(Date), y = Sales, group = 1)) + geom_line() # group은 1가지

# Step5. 점을 추가한다.
ggplot(TS, aes(x = factor(Date), y = Sales, group = 1)) + geom_line() + geom_point()

# Step6. 테마 적용
ggplot(TS, aes(x = factor(Date), y = Sales, group = 1)) + geom_line() + geom_point() + 
  theme_light()

# Step7. 디자인 개선
ggplot(TS, aes(x = factor(Date), y = Sales, group = 1)) + geom_line(colour = "orange1", size = 1) +
  geom_point(colour = "orange2", size = 4) + theme_light()

# Step8. X축과 Y축의 이름을 바꾼다.
ggplot(TS, aes(x = factor(Date), y = Sales, group = 1)) + geom_line(colour = "orange1", size = 1) +
  geom_point(colour = "orangered2", size = 4) + xlab("년도") + ylab("매출") +
  ggtitle("A기업 월별 매출") + theme_light()


# Example03 - dplyr패키지를 이용해 원하는 데이터 쉽게 선택해 그래프로 나타내기 ----
# package : dplyr, ggplot2, ggthemes
# Step1. 필요한 패키지를 불러온다.
library(dplyr)
library(ggplot2)
library(ggthemes)

# Step2. 데이터를 불러온다.
DF <- read.csv("example_population_f.csv")
DF <- DF[, -1] # 첫 번째 열은 ID숫자이기 때문에 삭제
(DF <- tbl_df(DF)) # dplyr에서 data.frame을 다룰 수 있도록 변환
                   # tbl_df(데이터 프레임 객체) - dplyr객체 속성을 추가하라.

# Step3. 충청도만 따로 객체에 담는다.
DF2 <- filter(DF, Provinces == "충청북도" | Provinces == "충청남도")
                  # filter(data.frame 객체, 변수명(조건) 변수값) - 조건에 맞는 행을 반환하라.

# Step4. 그래프 그리기
(Graph <- ggplot(DF2, aes(x = City, y = Population, fill = Provinces)) + 
    geom_bar(stat = "identity") + theme_wsj())

# Step5. 오름차순으로 정렬하기.
(GraphReorder <- ggplot(DF2, aes(x = reorder(City, Population),
                                 y = Population, fill = Provinces)) + 
    geom_bar(stat = "identity") + theme_wsj()) 
                             # reorder(정렬할 객체(factor), 정렬할 기준(numeric)) - 정렬하라.

# Step6. 남자비율이 높고 1인가구가 많은 도시를 필터링
DF3 <- filter(DF, SexRatio > 1, PersInHou < 2)

# Step7. 그래프로 그린다.
(Graph <- ggplot(DF3, aes(x = City, y = SexRatio, fill = Provinces)) +
    geom_bar(stat = "identity") + theme_wsj())


# Example04 - dplyr패키지를 이용해 필요한 데이터를 만들고 그래프로 나타내기 ----
# package : dplyr, ggplot2, ggthemes
# Step1. 필요한 패키지를 불러온다.
library(dplyr)
library(ggplot2)
library(ggthemes)

# Step2. 데이터 불러오기
DF <- read.csv("example_population_f.csv")
DF <- DF[, -1]

# Step3. 남녀비율을 문자로 나타내는 변수를 추가한다.
DF <- mutate(DF, SexF = ifelse(SexRatio < 1, "여자비율높음", 
                               ifelse(SexRatio > 1, "남자비율높음", "남여비율같음")))
                 # mutate(data.frame 객체, 추가할 변수명 = 추가할 내용)
                 # - 조건에 맞는 새로운 변수를 추가하라.

# Step4. 새로운 변수를 순서형 변수로 바꾼다.
DF$SexF <- factor(DF$SexF)
DF$SexF <- ordered(DF$SexF, c("여자비율높음", "남여비율같음", "남자비율높음"))

# Step5. 경기도 데이터만 DF2에 따로 저장한다.
DF2 <- filter(DF, Provinces == "경기도")

# Step6. 그래프 그리기.
(Graph <- ggplot(DF2, aes(x = City, y = (SexRatio - 1), fill = SexF)) + 
    geom_bar(stat = "identity", position = "identity")) + theme_wsj()
                                # position = "identity"를 넣어야 음수인 경우 에러 메시지 방지
                                # 경기도는 남자비율이 지나치게 높다.

# Step7. 서울 데이머나 DF3에 따로 저장한다.
DF4 <- filter(DF, Provinces == "서울특별시")

# Step8. 그래프 그리기.
(Graph2 <- ggplot(DF4, aes(x = City, y = (SexRatio - 1), fill = SexF)) + 
    geom_bar(stat = "identity", position = "identity") + theme_wsj()) 
                                # 서울은 여자비율이 더 높다.


# Example05 - reshape2패키지의 melt()를 이용해 데이터를 가공 후 그래프로 나타내기 ----
# package : dplyr, ggplot2, ggthemes, reshape2
# Step1. 필요한 패키지를 불러온다.
library(dplyr)
library(ggplot2)
library(ggthemes)
library(reshape2)

# Step2. 데이터 불러오기.
DF <- read.csv("example_population_f.csv")
DF <- DF[, -1]
DF <- tbl_df(DF)

# Step3. '도'별 합을 구한다.
group <- group_by(DF, Provinces)
DF2 <- summarise(group, SumPopulation = sum(Population), Male = sum(Male), Female = sum(Female))
         # group_by(data.frame객체, 그룹지을 변수), summarise(그룹객체, function) ----
         # -> 그룹을 지어 유지하라,                 새로운 객체에 새로운 변수로 요약하라.

# Step4. 남녀 변수를 factor로 바꾼다.
DF3 <- melt(DF2, id.vars = c("Provinces", "SumPopulation"), 
            measure.vars = c("Male", "Female"))
       # melt(data.frame, id.vars = 바꾸지 않을 변수들, measure.vars = 바꿀 변수들) ----
       # -> 여러 변수를 하나의 명목형 변수로 바꿔라.
DF2; DF3
colnames(DF3)[3] <- "Sex"
colnames(DF3)[4] <- "Population"
DF3

# Step5. 남녀 비율을 추가한다.
DF4 <- mutate(DF3, Ratio = Population / SumPopulation)
DF4$Ratio <- round(DF4$Ratio, 3)

# Step6. 그래프 그리기.
G1 <- ggplot(DF4, aes(x = Provinces, y = Ratio, fill = Sex)) + geom_bar(stat = "identity") +
  coord_cartesian(ylim = c(0.45, 0.55)) + theme_wsj()
G2 <- geom_text(aes(y = Ratio, label = Ratio), colour = "white")
G1 + G2
                  # coord_cartesian() - X축 or Y축에서 보여주고 싶은 영역을 확대해서 보여준다.

# Step7. 텍스트 표시를 그래프 가운데 넣기 위해 데이터에 위치값을 추가한다.
(DF4 <- mutate(DF4, Position = ifelse(Sex == "Male", 0.475, 0.525)))

# Step8. 그래프를 다시 셋팅한다.
G1 <- ggplot(DF4, aes(x = Provinces, y = Ratio, fill = Sex)) + geom_bar(stat = "identity") +
  coord_cartesian(ylim = c(0.45, 0.55)) + theme_wsj()
G2 <- geom_text(aes(y = Position, label = Ratio), colour = "white")
G1 + G2


# Example06 - 클리블랜드 점 그래프 그리기 ----
# package : dplyr, ggplot2, ggthemes
# Step1. 필요한 패키지를 불러온다.
library(dplyr)
library(ggplot2)
library(ggthemes)

# Step2. 데이터 불러오기.
DF <- read.csv("example_population_f.csv")
DF <- DF[, -1]
DF <- tbl_df(DF)

# Step3. 남녀 비율을 명목형 변수로 바꾼다.
DF2 <- mutate(DF, SexF = ifelse(SexRatio > 1, "남자비율높음", 
                                ifelse(SexRatio == 1, "남녀비율같음", "여자비율높음")))

# Step4. 경기도 데이터만 DF3에 따로 저장하기.
DF3 <- filter(DF2, Provinces == "경기도")

# Step5. 그래프 그리기.
(Graph <- ggplot(DF3, aes(x = (SexRatio - 1), y = reorder(City, SexRatio))) + 
    geom_segment(aes(yend = City), xend = 0, colour = "grey50") +
    geom_point(size = 4, aes(colour = SexF)) + theme_minimal())
                 # geom_segment() - xend : X축의 시작 위치
                 #                  yend : Y축의 factor 변수
                 #                  colour : xend에서 값을 나타내는 위치까지의 line color
                 #                  Y축을 reorder()함수로 정렬해야 순위별로 볼 수 있다.


# Example07 - 시간에 따른 연령별 인구 변화 그래프 그리기 ----
# package : dplyr, ggplot2, ggthemes, reshape2, scales
# Step1. 필요한 패키지를 불러온다.
library(dplyr)
library(ggplot2)
library(ggthemes)
library(reshape2)
library(scales)

# Step2. 시간별 인구변화 자료를 불러온다.
DF <- read.csv("example_population2.csv")
DF <- tbl_df(DF)

# Step3. 남여를 합해 새로운 data.frame에 저장한다.
group <- group_by(DF, Time)
DF2 <- summarise(group, s0 = sum(age0to4, age5to9),
                 s10 = sum(age10to14, age15to19),
                 s20 = sum(age20to24, age25to29),
                 s30 = sum(age30to34, age35to39),
                 s40 = sum(age40to44, age45to49),
                 s50 = sum(age50to54, age55to59),
                 s60 = sum(age60to64, age65to69),
                 s70 = sum(age70to74, age75to79),
                 s80 = sum(age80to84, age85to89),
                 s90 = sum(age90to94, age95to99),
                 s100 = sum(age100to104, age105to109))
                 # 코드가 너무 길다.
                 # Making Fucntion using variable name ----
library(foreach)
DF2_make <- foreach(i = c("", 1 : 10), .combine = cbind) %do% {
  cols <- paste0("s", i, "0")
  prevage <- paste0("age", i, "0to", i, "4")
  nextage <- paste0("age", i, "5to", i, "9")
  columnss <- group %>% summarise(sum(!!sym(prevage), !!sym(nextage)))
  colnames(columnss)[2] <- cols
  if(i != c(""))
    columnss$Time <- NULL
  
  return(columnss)
}
DF2_make <- tbl_df(DF2_make)
head(DF2, 5)
head(DF2_make, 5)

# Step4. 각 연령대별 변수를 명목형 변수로 만든다.
DF3 <- melt(DF2, id.vars = "Time", measure.vars = c(2 : dim(DF2)[2]))
colnames(DF3) <- c("Time", "Generation", "Population")

# Step5. 그래프로 그린다.
(G1 <- ggplot(DF3, aes(x = Time, y = Population, colour = Generation, fill = Generation)) +
    geom_area(alpha = .6) + theme_wsj())
            # geom_area() ----
            # -> 영역 그래프를 그려라.

# Step6. Y축 값을 comma가 들어가게 변경한다.
G2 <- ggplot(DF3, aes(x = Time, y = Population, colour = Generation, fill = Generation)) +
  geom_area(alpha = .6) + theme_wsj()
G2 + scale_y_continuous(labels = comma)


# Example08 - Sankey Diagram으로 예산 한눈에 보기 ----
# package : dplyr, rCharts
# Download : https://github.com/timelyportfolio/rCharts_d3_sankey
# Step1. 필요한 패키지를 불러온다.
library(dplyr)
library(rCharts)

# Step2. 데이터를 불러온다.
DF <- read.csv("example_2015_expenditure.csv")
str(DF)

# Step3. 데이터를 복사해서 사용한다.
DF2 <- DF

# Step4. 확정안 변수의 이름과 단위를 변경한다.
colnames(DF2)[6] <- "value"
DF2["value"] <- round(DF2["value"] / 1000)

# Step5. 데이터 처리하기 전 데이터를 복사한다.
DF3 <- DF2

# Step6. 데이터를 전처리한다.
sum1 <- DF3 %>% group_by(소관명, 회계명) %>%  summarise(sum(value))
sum2 <- DF3 %>% group_by(회계명, 분야명) %>%  summarise(sum(value))
sum3 <- DF3 %>% group_by(분야명, 부문명) %>%  summarise(sum(value))
sum4 <- DF3 %>% group_by(부문명, 프로그램명) %>%  summarise(sum(value))
sum1

# Step7. 변수 이름을 영문으로 바꾼다.
colnames(sum1) <- c("source", "target", "value")
colnames(sum2) <- c("source", "target", "value")
colnames(sum3) <- c("source", "target", "value")
colnames(sum4) <- c("source", "target", "value")

# Step8. 만든 모든 객체를 하나로 합친다.
sum1 <- as.data.frame(sum1)
sum2 <- as.data.frame(sum2)
sum3 <- as.data.frame(sum3)
sum4 <- as.data.frame(sum4)
DF4 <- rbind(sum1, sum2, sum3, sum4) ## class(sum1) <- class(sum1)[-1]방법으로 group_by 속성 삭제

# Step9. 그래프를 그리기 위해 먼저 rCharts객체를 만든다.
sankeyPlot <- rCharts$new()

# Step10. 사용할 library를 지정한다.
sankeyPlot$setLib("libraries/sankey")
sankeyPlot$setTemplate(script = "libraries/sankey/layouts/chart.html")

# Step11. 그래프 관련 정보를 지정한다.
sankeyPlot$set(data = DF4, nodeWidth = 15, nodePadding = 13, layout = 300, width = 900,
               height = 600, units = "천원", title = "Sankey Diagram")
               # nodeWidth : 노드의 가로폭, nodePadding : 노드를 연결하는 line들간의 간격
               # layout, width, height : 그려질 그래프의 크기
               # units : 노드를 연결하는 선 위에 마우스가 오버되었을 때 
               #         tooltip으로 나타나는 데이터의 값의 단위

# Step12. 그래프를 실행한다.
sankeyPlot


# Example09 - 작년에 구입한 아파트 값은 올랐을까? ----
# package : readxl, dplyr, stringr, rCharts
# Graph : http://www.nytimes.com/interactive/2014/01/23/business/case-shiller-slider.html?_r=0
# Step1. 필요한 library를 불러온다.
library(tidyverse)
library(readxl)
library(dplyr)
library(stringr)
library(rCharts)

# Step2. 데이터를 불러올 준비를 한다.
files <- sprintf("%4d년_%02d월_전국_실거래가_아파트(매매).xls", rep(2006 : 2014, each = 12), 1 : 12)
         # %4d : 네 자리 숫자를 넣는 것. %02d 두 자리 숫자를 넣는다. (0이 들어감으로서 01, 02, ...)

# Step3. 다운받은 모든 데이터를 DF객체로 불러온다.
DF <- NULL
for(i in 1 : length(files)){
  t <- read_excel(path = paste0("rawdata", "/", files[i]), sheet = 1, col_names = T)
  t <- mutate(t, date = paste0(substr(files[i], 1, 4), "-", 
                               month = substr(files[i], 7, 8), "-10"))
  DF <- rbind(DF, t)
}

# Step4. 깨진 한글변수명을 바꿔준다.
DF2 <- DF # 안전을 위해 새로운 객체에 복사한다.
colnames(DF2) <- c("시군구", "본번", "부번", "단지명", "전용면적", "계약일", "거래금액", 
                   "층", "건축년도", "도로명주소", "date")

# Step5. 필요한 데이터만 불러온다.
DF3 <- data.frame(date = DF2$date, addr = DF2$시군구, val = DF2$거래금액)

# Step6. 데이터형을 바꾼다.
str(DF3)

# Step7. addr변수를 정리한다.
City <- str_split_fixed(DF3[, 2], " ", 4)
City <- data.frame(City)
str(City)

# Step8. City변수에서 '구'만 뽑아 넣는다.
DF4 <- data.frame(date = DF3[, 1], addr = City[, 3], val = DF3[, 3])
str(DF4)

# Step9. 데이터를 정리한다.
DF5 <- DF4 %>% group_by(date, addr) %>% summarise(mean(val))

# Step10. 최종 데이터를 정리한다.
colnames(DF5)[3] <- "val"
DF5[["date"]] <- as.character(DF5[["date"]])
DF5$val <- DF5$val / 50 # 사용할 Graph library가 y축을 자동으로 바꿔주는 기능이 없다.
str(DF5)

# Step11. 데이터 그래프 그리기 단계
DF5 <- read.csv("example_realty.csv")
str(DF5)

# Step12. 그래프를 그리기 위해 변수를 객체화 한다.
g2 <- rCharts$new() # rCharts는 객체지향적

# Step13. 필요한 library를 불러온다.
g2$setLib("libraries/nyt_home")
g2$setTemplate(script = "libraries/nyt_home/layouts/nyt_home.html")

# Step14. 필요한 setting을 한다.
g2$set(description = "This data comes from the 'rt.molit.go.kr' datset",
       data = DF5, groups = "addr")

# Step15. Graph를 그린다.
g2
