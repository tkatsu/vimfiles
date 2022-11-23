# vimfiles
vimfiles for Linux and Windows using dein plugin manager.

# 特徴

 - Linux と Windows に共通利用可能  
 - 目にやさしい配色(背景が薄いクリーム色、文字が黒)
 - プロジェクト毎の vimrc の設定が可能
 - [dein plugin manager](https://github.com/Shougo/dein.vim)を利用し、プラグイン管理が簡単にできる  
   現在、dein で管理されているプラグイン
   <table>
   <tr>
   <td>Konfekt/Fastfold</td>
   <td>Shougo/context_filetype.vim</td>
   <td>Shougo/dein.vim</td>
   <td>Shougo/neocomplete.vim</td>
   </tr>
   <tr>
   <td>Shougo/neoinclude.vim</td>
   <td>Shougo/neomru.vim</td>
   <td>Shougo/neosnippet-snippets</td>
   <td>Shougo/neosnippet.vim</td>
   </tr>
   <tr>
   <td>Shougo/neoyank.vim</td>
   <td>Shougo/unite.vim</td>
   <td>Shougo/vimproc.vim</td>
   <td>SirVer/ultisnips</td>
   </tr>
   <tr>
   <td>aklt/plantuml-syntax</td>
   <td>cespare/vim-toml</td>
   <td>flazz/vim-colorschemes</td>
   <td>honza/vim-snippets</td>
   </tr>
   <tr>
   <td>kana/vim-operator-user</td>
   <td>kannokanno/previm</td>
   <td>nathanaelkane/vim-indent-guides</td>
   <td>osyo-manga/vim-precious</td>
   </tr>
   <tr>
   <td>rcmdnk/vim-markdown</td>
   <td>scrooloose/nerdtree</td>
   <td>scrooloose/syntastic</td>
   <td>tkatsu/omnisharp-vim</td>
   </tr>
   <tr>
   <td>tkatsu/vim-c-snippets</td>
   <td>tkatsu/vim-clang</td>
   <td>tkatsu/vim-clang-format</td>
   <td>tkatsu/git-vim</td>
   </tr>
   <tr>
   <td>tpope/vim-dispatch</td>
   <td>tpope/vim-endwise</td>
   <td>tpope/vim-rails</td>
   <td>tpope/vim-surround</td>
   </tr>
   <tr>
   <td>tyru/open-browser.vim</td>
   <td>ujihisa/neco-look</td>
   <td>vim-ruby/vim-ruby</td>
   <td>vim-scripts/Conque-GDB</td>
   </tr>
   </table>

# 対応 Vim
  `Lua付き` でビルドされた Vim の利用を推奨する。(:version にて確認)  
  Lua付きでビルドされていないものは、便利な補完機能関係のプラグインが効かない。

 - Windows  
   - [香り屋さんで配布している Vim](https://www.kaoriya.net/software/vim/)
   - `Git For Windows`  に同梱されている Vim
     (ただし、Luaを必要とするものや、vimproc.vim を利用するプラグインには非対応)

 - Linux  
   パッケージに含まれる Vim。  
   尚、パッケージ版だと `Luaなし`でビルドされている場合が多いので、
   その際は自分で `Lua付き`の Vim を [ここ](https://qiita.com/Fendo181/items/8a5545cd7550bd9a3c91)や
   [ここ](https://qiita.com/SS1031/items/7ee4feb7a18c62bd926f) を参考にビルドするのが良い。

# Vim 以外に必要なもの
 - Git  
   Windows の場合は、`Git Bash` がセットになってる `Git for Windows`

 - ビルドツール  
   プラグイン `vimproc.vim` の DLL を自分でビルドする場合に必要となる。

   - Windows(通常は不要。後述する kaoriya の DLL を利用するので)  
     `MinGW` をインストールする。

      - 32bit 版 Windows の場合  
        http://yohshiy.blog.fc2.com/blog-entry-292.html を参考にインストールする。
      - 64bit 版 Windows の場合  
        https://sourceforge.net/projects/mingw-w64/ の Files タブ の中にある
         `x86_64-win32-seh` をダウンロードし、C:の直下に展開する。

   - Linux  
     gcc などの普通のビルド環境一式。通常はインストール済みの場合が多い。  
     インストールされていない場合、Ubuntu など Debian系の OS なら
     `$ apt install build-essential` にてインストールする。

 - 外部ツール  
   利用するプラグインにより、以下の外部ツールを必要とする。  

        bc, ctags, indent, look, words, pt

   これらは、なくても、そのツールを利用するプラグインが動作しないだけで、とり敢えず問題はない。  

   Linux ではほとんどがインストール済みと思われる。インストールされていなかったら
   `sudo apt install xxx` などでインストールする。  

   Windows においては、Windows 用バイナリをネットで探し、パスの通ったディレクトリに保存する。  

   - bc  
     http://gnuwin32.sourceforge.net/packages/bc.htm
   - ctags  
     https://github.com/universal-ctags/ctags-win32/releases
   - indent  
     http://gnuwin32.sourceforge.net/packages/indent.htm
   - look  
     neco-lookで 英単語の補完に利用する。  
     Windows 用バイナリ look.exe は [ここ](https://gist.github.com/DeaR/5898758)を
     参考にビルドする。ビルドには MinGW  が必要。
   - words  
     上記 look で利用する **1行1単語の英単語データファイル**。  
     適当なものがなければ Ubuntu の /usr/share/dict/american-english を
     `sort -d` でソートしたものを words というファイル名にして利用するという
     方法がある。  look.exe と同じ場所に保存する。
   - pt(grepツール)  
	    https://github.com/monochromegane/the_platinum_searcher  
      日本語対応がしっかりしているので Windows ではこれが良い。

# vimfiles と各プラグインのインストール手順
  1. 自分のホームディレクトリに `vimfiles.git` を `git clone` する。  
    (Linux の場合は `.vim`  という名称で clone する)
  2. clone された中に含まれる `_vimrc` と `_gvimrc` をホームディレクトリ直下にコピーする。  
    (Linux の場合は それぞれ `.vimrc` `.gvimrc` という名称でコピーする。)
  3. Vim を起動する。  
    必要なプラグインが自動的にインストールされる。  
    尚、2～3回、Vim の起動・終了を繰替えす必要がある。
  4. プラグイン vimproc.vim の DLL のコピー(Linuxの場合はビルド)  
     一部のプラグイン、Unite, clang, previmとopen-browser 等で必要  
  5. ターミナルから Vim を起動する場合は ターミナル自体の配色を`背景が薄いクリーム色`になるよう調整する。

 - Windows の GVim 用のインストール例  
   Git Bash 上で以下を実行する。  

   1. 既存ファイルのバックアップ  
     vimfiles フォルダ や _vimrc, _gvimrc ファイルが既にあればリネームし、バッ
     クアップしておく。
      ```
      $ cd ~
      $ mv vimfiles vimfiles.old 
      $ mv _vimrc _vimrc.old
      $ mv _gvimrc _gvimrc.old
      ```

   2. vimfiles の cloneと、_vimrc と _gvimrc のコピー
      ```
      $ cd ~
      $ git clone https://github.com/tkatsu/vimfiles.git
      $ cp vimfiles/_vimrc _vimrc
      $ cp vimfiles/_gvimrc _gvimrc
      ```

   3. タスクバーなどから GVim を起動する。  
     最初の GVim の起動に3～4分かかる場合がある。その際、何の表示もされないがじっくり
    と待つ。GVim の再起動を2～3回繰替えし、GVim が スッと立ち上がればイン
    ストールが完了。

   4. vimproc.vim 用の DLLのコピー  
     kaoriya で配布している Vim には vimproc用 のDLL vimproc_winXX.dll 
     も同梱されているので、それを所定の場所にコピーする。  

      ```
      $ cp /c/vim/plugins/vimproc/lib/vimproc_winXX.dll ~/vimfiles/dein/repos/github.com/Shougo/vimproc.vim/lib/.
      ```
       ※ XX の部分は OS のビット数 32 か 64 を表わす。

   5. neocomplete.vim が **Vim 8.2.1066以降は非対応** への暫定対策  
     以下のように表示されたら、
      ```
      Vim 8.2.1066 is not backwards compatible.
      ```
      neocomplete.vim を commit 0f83788 へバージョンダウンさせる。  
      例.
      ```
      $ cd ~/vimfiles/dein/repos/github.com/Shougo/neocomplete.vim
      $ git checkout 0f83788
      ```

 - Git for Windows 付属の Vim 用のインストール例  
   Git Bash 上で以下を実行する。  
   ※ フォルダ名、ファイルの先頭の `_`と `.` の違いに注意!

   1. 既存ファイルのバックアップ  
     .vim フォルダ や .vimrc ファイルが既にあればリネームし、バックアップし
     ておく。
      ```
      $ cd ~
      $ mv .vim .vim.old 
      $ mv .vimrc .vimrc.old
      ```

   2. vimfiles の clone と .vimrc のコピー
      ```
      $ cd ~
      $ git clone https://github.com/tkatsu/vimfiles.git .vim
      $ cp .vim/_vimrc .vimrc
      $ vim
      ```
      ※ vim の起動・終了をを2・3回繰返す。

   ※ vimfiles と _vimrc を GVim と共用させることも可能だが、Linux 流の名称(.vim, .vimrc)にして、
      独立させた方が無難。  
   ※ vimproc.vim の DLL(vimproc_cygwin.dll) がない為、 vimproc.vim を利用するプラグインには
      非対応。  

 - Linux でのインストール例  
   コマンドラインで以下を実行する。  

   1. 既存ファイルのバックアップ  
     .vim フォルダ や .vimrc, .gvimrc ファイルが既にあればリネームし、
     バックアップしておく。
      ```
      $ cd ~
      $ mv .vim .vim.old 
      $ mv .vimrc .vimrc.old
      $ mv .gvimrc .gvimrc.old
      ```

   2. vimfiles の cloneと .vimrc と .gvimrc のコピー
      ```
      $ git clone https://github.com/tkatsu/vimfiles.git .vim
      $ cp .vim/_vimrc .vimrc
      $ cp .vim/_gvimrc .gvimrc
      $ vim
      ```
      ※ vim の起動・終了をを2・3回繰返す。

   3. vimproc.vim の DLL(vimproc_linux64.so)のビルド  
      Vim 上で以下を実行する。
      ```
      :VimProcInstall
      ```
      ※ `~/.vim/dein/.cache/.vimrc/.dein/lib/` に `vimproc_linux64.so` が作られる。

   4. kaoriyaさんの便利なプラグインと日本語ヘルプを使う(オプショナル)
      ```
      $ sudo mkdir -p /opt
      $ cd /opt
      $ sudo git clone https://github.com/koron/vim-kaoriya.git
      $ sudo git clone https://github.com/vim-jp/vimdoc-ja.git
      ```

   5. Shougoさんの deoplete plugin による入力補完  
     Vim-8.2.1978以降においては、python3 を有効にして Vim をビルドする。  
     ```
     $ ./configre --enable-python3interp=yes ...  
     ```
     pynvim をインストールする。  
     ```
     $ pip3 install pynvim
     ```

  ※ 最初の Vim 実行時、`~/.vimbackup`  というディレクトリが自動的に作られる。
  ここにバックアップファイルなどの一時ファイルが保存される。

# カスタマイズの例
  ※ ファイル名、ディレクトリ名は Windows 版で説明。Linux の場合は適宜読み変える。  

  - プラグインマネージャー dein を無効にする  
    `~/_vimrc` の中の以下の行の  '1' を '0' にする。

    ```
    let s:use_dein = 1
    ```
  - プラグイン `vim-clang` を有効にする  
    `~/vimfiles/rc/dein_lazy.toml` の中の以下の行の '0' を '1' にする。

    ```
    if = ''' 0 && dein#tap('neocomplete.vim') '''
    ```
    別途 LLVM のインストールが必要。

  - プラグインを追加する  
    `~/vimfiles/rc` の中の以下の設定ファイルに記述する。
    - dein.toml: 無条件に実行するもの
    - dein_lazy.toml: ファイルタイプ毎など遅延実行するもの

  - プロジェクト毎に vimrc の設定をする  
    プロジェクトのソースのルートディレクトリに `_vimrc.local` というファイルを作り
    そこにプロジェクト固有の設定を書く

    ```
    set ts=4
    set sw=4
    set expandtab
    ```

# dein 管理ではない plugin
  `~/vimfiles/plugin` ディレクトリに入っているもの。

  - keisen.vim  
    j,k,h,l でカーソル移動した通りに罫線が引かれる。  
    (Akutsu さん作成のものを UTF-8対応したもの)  
    ブロック図を書く時など超便利。  

    ```
    +-------+   +------------------+
    |  A    |   |       B          |
    +-------+   +------------------+
    ```
    詳しくはscriptの中を参照のこと。  

  - bccalc.vim  
    vim 上で計算を行う。
    ```
    100 * 100 =
    ```
    上記の上で、`:BcCalc` とすると = の右側に計算結果が入る。
    `obase=16;ibase=16;` を先頭に書くと16進の計算もできる。  
    詳しくはscriptの中を参照のこと。  

  - etc
   
# Lisence
  Open-sourced software licensed under the [MIT license](http://opensource.org/licenses/MIT).

以上
