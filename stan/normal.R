library(rstan)
#stanに渡すデータを作成する
N <- 1000
y <- rnorm(N, mean = 172, sd = 5.5)
normal_data <- list(N = N, y = y)

#データのヒストグラム
hist(y, breaks =seq(150,190,by=2.5), col="skyblue")
rug(y)

#モデルのあてはめ
fit_normal <- stan(file = "normal.stan", data = normal_data, iter = 2000, chains = 4, thin = 1)

save(y, N, normal_data, fit_normal, file = "fit_normal.RData")
#load("fit_normal.RData")

#MCMC推移
traceplot(fit_normal)

#推定値のプロット
plot(fit_normal)

#推定値などの値の常時
print(fit_normal)

#サンプルされたパラメター値の抽出
param_normal <- extract(fit_normal)

# mu の推定値
mean(param_normal$mu)


#ShinyStanによる推定結果の可視化
library(shinystan)
sso_normal <- launch_shinystan(fit_normal)



