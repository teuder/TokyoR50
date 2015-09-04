//線形回帰
//新データに対する予測値の算出

data {
  int<lower=0> N; // サンプル数
  int<lower=1> K; // 説明変数の数
  matrix[N,K]  x; // 説明変数の行列（計画行列）
  vector[N]    y; // 目的変数
  
  //新データに対する予測値の算出用
  int<lower=0>     N_new;  //予測サンプル数
  matrix[N_new, K] x_new;  //予測説明変数の行列
}
parameters {
  real          alpha;   //切片
  vector[K]      beta;   //係数ベクター
  real<lower=0> sigma;   //ノイズ
  
  //（書き方２）
  //vector[N_new] y_new; 
}
model{
  y ~ normal(alpha + x * beta, sigma);
  
  //（書き方２）新データに対する y の予測値の生成
  //y_new ~ normal(alpha + x * beta, sigma);
}
generated quantities {
  //サンプルされたパラメター値と予測用データを使い
  //正規乱数から y の予測値を生成する
  vector[N_new] y_new;
  for (n in 1:N_new) {
    y_new[n] <- normal_rng(x_new[n] * beta, sigma);
  }
}
