#講在前面
#井字號後面的字R不會讀取，所以你可以在你要輸入的code後面用#加註釋，整個腳本編輯完後直接全選貼到R上讓他一次跑也行。
#建議用Notepad++來讀取和編輯這個檔案，就是一個更高級好用的記事本。下載網址在這裡:https://notepad-plus-plus.org/downloads/ 。安裝後用這個軟體打開腳本，在上面工作列上選擇: 語言(L)>R>R，格式就會變成針對R語言的格式，會自動幫你確認寫法，自動輸入你用過的字串或變數；用這個來編輯比較不容易出錯，也比較容易查錯。不過你要是想用word來寫腳本的話，也不是不行啦...

#準備工作環境
install(agricolae) #分析需要的Package
install(ggplot2) #畫圖需要的Package
library(agricolae)#然後把上面安裝的Package叫出來，才可以使用它的功能
library(ggplot2)
setwd("D:/cch_data/fly_RNAdata/") #指定你的工作目錄，這樣你之後存檔、出圖、讀檔，都不用再打一長串路徑。這邊只是舉例，可以直接從你要指定的資料夾複製路徑再編輯修改。目錄階層的分隔必須用"/"，因為屬性是字串，所以在你路徑前後必須要有""或''。

#再來準備要分析的資料，兩種方式:
#1.直接載入txt檔，表格參考格式請看附檔"用R做統計分析表格格式範例.xlsx"
#用excel整理好表格後，另存為"文字檔(Tab字元分隔)(*.txt)"
#將tab檔放到你上面已經指定好的路徑裡。
#再來準備讀取tab檔需要的package:
install(data.table)
library(data.table)
#表格讀入R，並指定表格名稱為BW
BW <-fread(
	file="用R做統計分析表格格式範例.txt", #檔案名稱
	header=T, #將第一列作為欄名
	data.table=F
	)
#可以用以下指令來看你的檔案是否有成功載入成表格:
View(BW) #這裡是你在R所建立的變數名稱，所以不是字串，不需要加""。
#2.自己手動在R裡面填入所有data，並生成表格，這個給你當功課。

#跑ANOVA
ATG7anova <- avo(ATG7~treat,data=BW) #"儲存ANOVA結果的變數名稱"<-avo("要分析的data欄名"~"實驗組別的欄名",data="前面那些來源的表格")
#再來要看ANOVA結果:
summary(ATG7anova)
#看LSD結果(這個要ANOVA顯著才有意義)
print(LSD.test(ATG7anova,"treat")) #print(LSD.test("你要分析的ANOVA結果","組別的欄名"))
#畫盒鬚圖
boxplot(formula=ATG7~treat,data=BW)

#跑Tukey's HSD test就接著看這裡:
install(PMCMRplus) #跑Tukey用的package
library(PMCMRplus)
ATG7HSD<-tukeyTest(ATG7anova)#用上面ANOVA的結果來跑出Tukey的結果。
summary(ATG7HSD)
#看HSD結果(這個要ANOVA顯著才有意義)
summaryGroup(ATG7HSD)
#看HSD結果幫你分組的結果


#繪圖相關的其他指令，如標籤、顏色、大小等等，可以直接在指令前加"?"，像這樣:
?boxplot
#兩個問號也行
??boxplot
#對於其他指令不確定怎麼寫都能這樣查。一般都會提供試跑的範例。有問題再問我。

#LSD（Least Significant Difference）與 Tukey's HSD（Honestly Significant Difference）皆為 ANOVA（分析變異數）後的事後比較法（post hoc tests），用於判定組間是否有顯著差異。 它們的目標相同:在多組比較中識別哪些組間存在統計上顯著差異，但控制錯誤率的方式與嚴格程度不同。HSD較為嚴謹，較不容易出現偽陽性。
#by_潘六_2025/5/15