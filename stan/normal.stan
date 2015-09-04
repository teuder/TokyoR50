//正規分布の平均と標準偏差を推定する

data {//モデルに渡すデータを定義
  int<lower=1> N; //データの数
  real y[N]; //N個の実数配列
}
parameters {//推定したいモデルパラメターを定義
  real mu;
  real<lower=0> sigma;
}
model {//モデルの定義
  mu ~ uniform(150, 190);     //muの事前分布
  sigma ~ normal(0, 1000);  //sigmaの事前分布
  y ~ normal(mu, sigma);    //データ y は正規分布から生成されていると想定
}


