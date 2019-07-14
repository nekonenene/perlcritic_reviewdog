# perlcritic x reviewdog

[perlcritic](https://metacpan.org/pod/perlcritic) と [reviewdog](https://github.com/reviewdog/reviewdog) を組み合わせて使う方法の説明用リポジトリです。


## Requirements

* Docker


## Usage

### 基本的な使い方

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

をしても、特に出力は得られません。master ブランチの最新コミットとの差分を見ているためです。  
develop ブランチに移動してみましょう。

```sh
git checkout develop
make reviewdog
```

今度は出力が得られたはずです。  
perlcritic で指摘されるもののうち、master ブランチとの差分に関わる箇所のみが出力されました。


### プルリクへの reviewdog コメントをローカルから付ける例

1. https://github.com/settings/tokens の『Generate new token』ボタンからトークンを作成。  
    権限は「public_repo」のみにチェック（非公開リポジトリならば「repo」にチェック）
2. プルリクエストを作成 （例: https://github.com/nekonenene/perlcritic_reviewdog/pull/1 ）
3. トークン文字列およびプルリクIDをもとに、以下のようなコマンドを実行します。  
    ```sh
    make reviewdog_pr REVIEWDOG_GITHUB_API_TOKEN="xxxxxx" CI_PULL_REQUEST=1
    ```
    結果、 https://github.com/nekonenene/perlcritic_reviewdog/pull/1 にコメントが行われました。
