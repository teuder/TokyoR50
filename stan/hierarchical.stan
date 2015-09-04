//階層ベイズモデル
//試験の点数の分布へのあてはめ、各生徒の解答力の推定
data {
  int<lower=0>         N; //生徒の人数
  int<lower=0>         M; //テストの点数の最大値
  int<lower=0>      y[N]; //生徒のテストの点数
}
parameters {
  real             alpha; //生徒の解答力の平均
  real           beta[N]; //生徒の解答力のばらつき
  real<lower=0>    sigma; //生徒の解答力のばらつきの標準偏差
} 
transformed parameters {
  real              z[N]; //生徒 i の解答力
  real              p[N]; //生徒 i がある問に正解する確率
  for(i in 1:N){
    z[i] <- alpha + beta[i]; //生徒 i の解答力
    p[i] <- inv_logit( z[i] );//生徒 i の１問あたりの正答確率 
  }
}
model{
  beta  ~ normal(0, sigma);  // betaの事前分布
  for(i in 1:N)
    y[i] ~ binomial(M, p[i]); //観測値の分布（尤度）
    
}
generated quantities{
  int y_hat[N]; // yの予測値
  for(i in 1:N)
    y_hat[i] <- binomial_rng(M, p[i]); //二項分布乱数
}

