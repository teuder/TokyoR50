data {
  int<lower=1> N; // データ数
  int<lower=0> K; // 説明変数の数
  matrix[N,K]  x;  // 計画行列
  int<lower=0, upper=1> y[N];  // 目的変数 0 or 1
}
parameters {
  real alpha;          //切片
  vector[K] beta;      //係数
}
model{
  y ~ bernoulli_logit(alpha + x*beta);//ベクトル化した記述
  //for (n in 1:N) //明示的に書き下し (inv_logitはlogistic関数のこと)
      //y[n] ~ bernoulli(inv_logit(alpha + beta * x[n]));
}