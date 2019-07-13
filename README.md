# perlcritic x reviewdog

[perlcritic](https://metacpan.org/pod/perlcritic) と [reviewdog](https://github.com/reviewdog/reviewdog) を組み合わせて使う方法の説明用リポジトリです。


## Requirements

* Docker


## Usage

まずはこのリポジトリを git clone します。その後、

```sh
make build
```

で Docker イメージのビルドをおこないます。

```sh
make perlcritic
```

によって、 perlcritic の結果が見られます。

```sh
make reviewdog
```

をしても、特に出力は得られません。master ブランチの最新コミットとの差分を見るためです。  
develop ブランチに移動してみましょう。

```sh
git checkout develop
make reviewdog
```

今度は出力が得られたはずです。  
master ブランチとの差分で、 perlcritic で指摘されるもののみが出力されました。
