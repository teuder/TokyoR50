library(rstan)
# #stanに渡すデータを作成する
logistic <- function(x){1.0/(1+exp(-x))}
x <- matrix(rnorm(200), ncol=2)
alpha <- 1.0
beta <- c(2.0,3.0)
q <- logistic(alpha + x %*% beta)
y <- sapply(q, function(Q){rbinom(1, 1, Q)})


# Stan にデータを渡して推定
logistic_dat <- list(N=nrow(x),K=ncol(x),x=x,y=y)
fit_logistic <- stan(file = "logistic.stan", data = logistic_dat, iter = 1000, chains = 4)

fit_logistic <- stan(fit=fit_logistic, data = logistic_dat, iter = 10000, chains = 5)

print(fit_logistic)
traceplot(fit_logistic)
param_logistic <- extract(fit_logistic)

mean(param_logistic$beta[,1])
hist(param_logistic$beta[,1])
