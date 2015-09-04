
library(rstan)
par(family="HiraKakuProN-W3")


#シミュレーションデータの作成
logistic <- function(x){1.0/(1+exp(-x))} #ロジスティック関数
N     <- 100 #生徒の人数
M     <- 100 #テストの点数の最大値
alpha <- 0.86 #解答力の平均
sigma <- 3.78 #解答力の個人差の標準偏差
beta  <- rnorm(N, mean = 0, sd = sigma) #解答力の個人差
z <- alpha + beta #解答力
p <- logistic(alpha + beta) #各生徒の正答確率
y <- sapply(p, function(P){rbinom(1, M, P)}) #各生徒のテストの点数

#stanに渡すデータの作成
data_hier <- list(N=length(y), M=M, y=y)

#観測値へのあてはめ
fit_hier <- stan(file = "hierarchical.stan", data = data_hier, iter = 2000, chains = 4)

#オブジェクトの保存
save(logistic, M, sigma, alpha, beta, p, y, data_hier, fit_hier, file = "hierarchical.Rdata")
#load("hierarchical.Rdata")


#点数の分布をプロット
hist(y, col="orange", xlab="テストの点数", ylab="人数")

#推定したパラメタなどの抽出
param_hier <- extract(fit_hier)

#テストの点数分布の予実比較
y.obs  <- hist(y, breaks=seq(0,100,by=10))
y.prd <-  hist(colMeans(param_hier$y_hat), breaks=seq(0,100,by=10))
plot(y.obs$mids, y.obs$counts, col="black", pch=19, xlab="テストの点数", ylab="人数")
points(y.prd$mids, y.prd$counts, col="red",   pch=19)

#解答力 z の予実比較
z.obs  <- hist(z, breaks=seq(-15,15,by=2))
z.prd <-  hist(colMeans(param_hier$z), breaks=seq(-15,15,by=2))
plot(  z.obs$mids, z.obs$counts, col="black", pch=19, xlab="生徒の解答力 z", ylab="人数")
points(z.prd$mids, z.prd$counts, col="red",   pch=19)

#解答力の個体差 beta の予実比較
b.obs  <- hist(beta, breaks=seq(-15,15,by=2))
b.prd <-  hist(colMeans(param_hier$beta), breaks=seq(-15,15,by=2))
plot(  b.obs$mids, b.obs$counts, col="black", pch=19, xlab="生徒の解答力beta", ylab="人数")
points(b.prd$mids, b.prd$counts, col="red",   pch=19)

#パラメターの予実比較
# alpha
print(alpha)           #真値
mean(param_hier$alpha) #推定値
hist(param_hier$alpha, freq = FALSE) #分布

# sigma
print(sigma)            #真値
mean(param_hier$sigma)  #推定値
hist(param_hier$sigma, freq = FALSE)  #分布

# i番目の生徒の beta
i <- 1
print(beta[i])            #真値
mean(param_hier$beta[,i]) #推定値
hist(param_hier$beta[,i], freq = FALSE) #分布

# i番目の生徒の p
i <- 1
print(p[i])            #真値
mean(param_hier$p[,i]) #推定値
hist(param_hier$p[,i]) #分布

