
# あむ編むコミュ！
（略してあむコミュ！）
## サービスURL: https://amucommu.com/

[![Image from Gyazo](https://i.gyazo.com/4c08aca9c043423da3871226f171a3d4.png)](https://gyazo.com/4c08aca9c043423da3871226f171a3d4)

## サービス概要
**あむ編むコミュ！**（あむコミュ！）は、同じコミュニティ内で「感謝の気持ち」を表現し、相手が喜ぶ画像をAIで生成してプレゼントするサービスです。<br>
ユーザーは、感謝メッセージを3回送信するごとに「ニット系アイテム」を獲得でき、コレクションとして収集できます。<br>
感謝の循環によって、普段のコミュニティ活動をより豊かにし、相手の気持ちが目に見える形で伝わることを目指しています。<br>


## このサービスへの思い・作りたい理由
オンラインコミュニティ、特にRUNTEQでは日々のプログラミング学習の中で助け合うことが多く、感謝の気持ちを伝えたくなる瞬間が多くあります。<br>
普段はテキストで感謝を伝えますが、もう少し気持ちを込めた形で贈り物をしたいと感じることがありました。<br>
私は昔から知らない人に話しかけてすぐに仲良くなれます。そして、仲良くなったさまざまな立場の方々から、お世話になることが多かったです。<br>
感謝の形は様々で、助けてもらったことによる活動の成果を報告したり、プレゼントを用意したりしてきましたが、今回はオンラインで「テキストとは違う感謝の伝え方」を追求しました。<br>
過去に感謝を伝えるために努力してきた経験や、その思いをプログラミングに生かしたいと考え、このアプリを開発しました。<br>
このサービスが、コミュニティの人々が「感謝」をより積極的に表現し、つながりを深められるきっかけになればと願っています。<br>

## ユーザー層について
**対象ユーザー**:<br>
RUNTEQコミュニティの20〜30代前半のメンバーを想定しています。<br>

**理由**:<br>
日々の活動で多くの感謝が生まれる環境であるためです。<br>
感謝の気持ちをテキスト以上の形で表したいという需要があり、このサービスが感謝の表現方法を増やし、コミュニティ全体の活発な交流につながると考えています。<br>

まだ先の話になりますが、ゆくゆくは、RUNTEQ以外のコミュニティにも広がって行けば嬉しいですが、まずはターゲットを絞りRUNTEQコミュニティとします。<br>

## サービス概要

| 感謝状一覧 | 感謝状作成 |
| ---- | ---- |
| <a href="https://gyazo.com/2d63b067bfe25e94d01c039a0867f0ef"><img src="https://i.gyazo.com/2d63b067bfe25e94d01c039a0867f0ef.gif" alt="Image from Gyazo" width="490"/></a> | <a href="https://gyazo.com/e8287ad452d4158071c87352fa0a1d36"><img src="https://i.gyazo.com/e8287ad452d4158071c87352fa0a1d36.gif" alt="Image from Gyazo" width="490"/></a> |
| みんなのそれぞれの感謝と相手を思って作られたニットの画像が閲覧できます。 | ログイン後、1ヶ月に2回、感謝のメッセージとAI画像の感謝状作成ができます。|

| 画像生成 | アイテム一覧 |
| ---- | ---- |
| <a href="https://gyazo.com/560cd2f93a2e125f7094e723ed8eec0b"><img src="https://i.gyazo.com/560cd2f93a2e125f7094e723ed8eec0b.gif" alt="Image from Gyazo" width="490"/></a> | <a href="https://gyazo.com/d48ceeb9fed887f4e0d7900cafea06f7"><img src="https://i.gyazo.com/d48ceeb9fed887f4e0d7900cafea06f7.png" alt="Image from Gyazo" width="490"/></a> |
| キーワードをもとに画像を最大2枚生成できます。 | 感謝状を3つ投稿すると、アイテムを1つ獲得できます。 |

| 感謝状詳細 | Xシェア |
| ---- | ---- |
| <a href="https://gyazo.com/bd44be424fb6bfa3ea7a49bc86f13c9b"><img src="https://i.gyazo.com/bd44be424fb6bfa3ea7a49bc86f13c9b.gif" alt="Image from Gyazo" width="490"/></a> | <a href="https://gyazo.com/d0d2f9082aa4572b1e4792d5333dbfd4"><img src="https://i.gyazo.com/d0d2f9082aa4572b1e4792d5333dbfd4.png" alt="Image from Gyazo" width="490"/></a> |
| 感謝状をXでシェア、投稿の編集、コメントができます。 | ご自身の生成された画像によって中心の画像が変わります。 |


## 技術スタック
| カテゴリ | 技術 |
| ---- | ---- |
| フロントエンド | Rails 7.2.1, TailwindCSS, DaisyUI |
| バックエンド | Rails 7.2.1 (Ruby 3.2.3 ) |
| データベース | PostgreSQL |
| インフラ | Render.com, AWS S3 |
| 認証 | Sorcery, GitHub認証, GitHubログイン |
| 開発環境 | Docker |
| API | OpenAI API, GitHub API |



## サービスの利用イメージ

- ユーザーはサイトにアクセス

*ログインした場合の流れ*<br>
- 感謝状を書いてAIで画像生成
感謝状に相手の名前と感謝メッセージを書きます。<br>
自分でタグを作る（感謝の内容やその人自身を連想させるようなAIが具体的な画像を生成しやすいキーワード）。<br>
タグを元にAIで画像生成し、感謝状と共に掲示板投稿できる。<br>

### ログイン済みの場合
1. **感謝メッセージ作成**: 相手の名前、感謝メッセージ、相手に関連するタグを指定。<br>
2. **AI画像生成**: AIがタグをもとに画像を生成し、感謝メッセージと共に掲示板に投稿。
3. **画像保存**: 生成された画像は、自身のデバイスにも保存可能。<br>
4. **アイテム獲得**: 感謝メッセージを3回送信するとニット系アイテムを獲得。<br>
5. **アイテムの保存と贈呈**: アイテムはプロフィールに表示され、他のユーザーへのプレゼントも可能。<br>

感謝メッセージの例：<br>
〇〇さんいつもありがとうございます！この間、Rails基礎のメーラーの部分がわからなくて、〇〇さんさんに丁寧に解説していただけて理解することができました！<br>
本当にありがとうございます！<br>
タグの例：バトミントン, しば犬, 薬、ピンク、イチゴ、お酒<br>
(タグには、その人の好きなものや関連するモチーフを入力する。)<br>


- **感謝状を3回送ると、一つのアイテムを獲得**
  - アイテムは、編み物をテーマにしたもの。
  - 獲得したアイテムは、ユーザーのマイページでにて表示。
  - 自分でコレクションにして楽しむことがでる。

- **Xシェア機能**
  - 生成された画像をXシェア。
  感謝状投稿後に感謝状詳細ページにある、「Xでメッセージを送る」ボタンをクリックする。<br>
  - 投稿ごとの画像に合わせて加工された画像がXシェアされる。


- **検索機能**
  - 感謝状一覧画面で、名前と感謝のメッセージとタグを検索することができる。


### ログインしていない場合
- **閲覧のみ**: 感謝状一覧や検索機能のみ利用可能。<br>


## サービスの深掘りについて

*ログイン必須に対する理由*<br>
匿名での感謝表現も需要があると感じますが、このサービスは個別に感謝を届けることに重きを置いています。<br>
ログインを必須にすることで、感謝の履歴ややりとりの記録が残り、ユーザー間でのつながりが深まる効果が期待できます。<br>
この設計によって、感謝がよりパーソナルに届けられると考えています。<br>

*アイテム獲得と主目的の関係*<br>
ユーザーが獲得したアイテムは、プロフィールに表示されます。<br>
自分でコレクションする楽しみがあり、また他のユーザーにプレゼントすることで感謝の表現やコミュニケーションを深めるツールとしても活用されます。<br>
このため、アイテムはただの報酬ではなく、感謝の可視化と共有を助ける存在として設計しています。<br>

*ユーザー感謝メッセージ送信のハードルについて*<br>
感謝のメッセージは、相手の特徴を反映させた画像が理想ですが、もし相手の好みがわからない場合でも、基本のテンプレートや一般的なタグで画像を生成することが可能です。<br>
相手を思い浮かべること自体が大切であり、リサーチをしなくても送れる設計になっています。<br>



## ユーザーの獲得について

私自身のXやtimesで広報。同期に使ってもらう。<br>
ユーザーの感謝状投稿やアイテムのXシェア機能で、コミュニティ内の認知を増やし新規ユーザーの獲得を目指します。<br>

## サービスの差別化ポイント・推しポイント

サービスのメイン目的は、感謝を伝えコミュニティ内でつながりを深めることです。<br>
感謝の気持ちをただ伝えるだけでなく、AIが生成する画像を添えて相手にプレゼントできる点が特徴です。<br>
他のサービスがアイコンなど自分用の画像生成が主なのに対し、あむコミュは人に向けた画像生成が中心です。<br>
また、3回のメッセージで獲得できるアイテムは「編み物」テーマにしており、感謝を「編む」というテーマを表現しています。<br>
アイテム獲得は、この体験の記念や可視化としての役割を持ち、感謝が形として残ることで、ユーザー同士がその活動を振り返るきっかけになればと考えています。<br>
また、アイテムを贈り合うことで更なる交流や感謝の循環が生まれるよう設計しており、さらなる交流のきっかけを作ることも大きな推しポイントです。<br>


#### 似たアプリや仕組み
サンキューカード<br>
マクドナルドのクルーの中にある、小さな感謝を伝えるカード。<br>

RUNTEQのCREDOの仕組み<br>
CREDOに該当する人を投票で募り表彰する。<br>

ジモティ<br>
ものやイベントをサイトを通じて発見する。<br>
掲示板機能が主ですが、相手との連絡のやり取りはメール。<br>
ログインしなくても掲示板と詳細ページは見れますが、相手に連絡するときはログイン必須。<br>
対象は違いますが、感謝の気持ちを形にするためにはログインしないといけないところが参考になりました。<br>


## 機能一覧

会員登録・ログイン<br>
ユーザー認証、GitHub外部認証システム<br>
トップページ<br>

感謝メッセージページ<br>
感謝メッセージ登録<br>
感謝メッセージ詳細<br>
感謝メッセージ編集<br>

タグ絞り機能<br>
名前、感謝メッセージ、タグ検索機能<br>
検索・一覧表示<br>
投稿ごとに合わせた画像加工機能付きのXシェア機能<br>
タグを元にしたAI画像生成機能<br>
月に2回までAI画像生成を使用できる機能<br>
3回メッセージ送るとアイテム獲得機能<br>

使い方ガイド作成<br>
独自ドメイン<br>
運営元・お問い合わせフォーム<br>
利用規約・プライバシーポリシー<br>



## 機能の実装方針予定

### MVPリリース時
- ユーザー認証
sorcery: ユーザー認証<br>
GitHubの外部ログイン認証

- タグ検索機能（タグで絞り込み機能）

- 検索機能
form object<br>

- 投稿フォームの作成: form_withを使ってメッセージを入力するフォームを作成。

- 投稿フォームでメッセージを送るとその内容がXシェアされる機能
感謝状と加工した画像と共に動的OGPでXで送信する。<br>
gem meta-tags<br>
gem mini_magick<br>

- AI画像生成機能
openai api<br>
HTTParty<br>

- Webサイトのアクセス数やユーザー数取得
Google Analytics<br>

### 本リリース時

# 画面遷移図
[Figma](https://www.figma.com/design/363Rw5sImKcIuiEAXao282/knitcommu?node-id=0-1&t=X2UvNN9JzQgMkDYk-1)<br>

# ER 図
[amucommu - ER 図](https://dbdiagram.io/d/amuamucommu-66fbcc04fb079c7ebdf2a87d)
[![Image from Gyazo](https://i.gyazo.com/5129df85791a3511b5c64c480ab335c7.png)](https://gyazo.com/5129df85791a3511b5c64c480ab335c7)