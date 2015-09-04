#重回帰、新データに対する予測値の算出例

library(rstan)
# #stanに渡すデータを作成する
x<-matrix(rnorm(200), ncol=2)
alpha<-1.0
beta<-c(2.0,3.0)
sigma=1.0
z <- (alpha+x%*%beta)
e<-rnorm(N, mean = 0, sd = sigma)
y <- as.numeric(z + e) #ここでハマった。
#(z + e)がmatrixなので
# ここで as.numeric しないと y が matix になる。
# すると、lm.stan では y をベクターで定義したので、
# stanで定義した y と型が合わないというエラーになる。


# Stan にデータを渡して推定
lm_dat <- list(N=nrow(x),K=ncol(x),x=x,y=y, N_new=nrow(x) , x_new=x)
fit_lm <- stan(file = "lm3.stan", data = lm_dat)

traceplot(fit_lm)

param_lm <- extract(fit_lm)

mean(param_lm$alpha)
hist(param_lm$alpha)
