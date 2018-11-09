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
  `Lua付き` でビルドされていないものは、便利な補完機能関係のプラグインが効かない。

 - Windows  
   - [香り屋さんで配布している Vim](https://www.kaoriya.net/software/vim/)
   - `Git For Windows`  に同梱されている Vim
     (ただし、Luaを必要するものや、vimproc.vim を利用するプラグインには非対応)

 - Linux  
   パッケージに含まれる Vim。  
   尚、パッケージ版だと `Luaなし`でビルドされている場合が多いので、
   その際は自分で `Lua付き`の Vim を [ここ](https://qiita.com/Fendo181/items/8a5545cd7550bd9a3c91)を
   参考にビルドするのが良い。

# Vim 以外に必要なもの
 - Git  
   Windows の場合は、`Git Bash` がセットになってる `Git for Windows`

 - ビルドツール
   - Windows(多少面倒なのでオプショナル)  
    プラグイン `vimproc.vim` を利用する際、バイナリをビルドする必要があるので、
     `MinGW` をあらかじめインストールしておく。  

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

   Linux では、ほとんどがインストール済みと思われる。インストールされていなかったら
   `apt install` などでインストールする。  

   これらは、とり敢えずなくても、そのツールを利用するプラグインが動作しないだけで問題はない。  

   Windows においては、Windows 用バイナリをネットで探し、パスの通ったディレクトリに保存する。  

   - bc  
     http://gnuwin32.sourceforge.net/packages/bc.htm
   - ctags  
     https://github.com/universal-ctags/ctags-win32/releases
   - indent  
     http://gnuwin32.sourceforge.net/packages/indent.htm
   - look(neco-lookで 英単語の補完に利用)  
     バイナリの場所は失念。手元の look.exe でバージョン表示すると `look from util-linux 2.23`  と表示。
   - words(look で利用する英単語を集めたファイル)  
     Ubuntu などでインストールされる wamerican パッケージの /usr/share/dict/words  を
     流用すればよいかも？)  
     look.exe と同じ場所に保存する。
   - pt(grepツール)  
	    https://github.com/monochromegane/the_platinum_searcher  
      日本語対応がしっかりしているので Windows ではこれが良い。


# インストール手順
  1. 自分のホームディレクトリに `vimfiles.git` を `git clone` する。  
    (Linux の場合は `.vim`  という名称で clone する)
  2. clone された中に含まれる `_vimrc` と `_gvimrc` をホームディレクトリ直下にコピーする。  
    (Linux の場合は それぞれ `.vimrc` `.gvimrc` という名称でコピーする。)
  3. Vim を起動する。必要なプラグインが自動的にインストールされる。  
     尚、2～3回、Vim の終了起動を繰替えす必要がある。
  4. プラグイン vimproc.vim の DLL のビルドまたはコピー(オプショナル)  
     一部のプラグイン、Unite, clang, previmとopen-browser 等で必要  
  5. ターミナルから Vim を起動する場合は ターミナル自体の配色を`背景が薄いクリーム色`になるよう調整する。

 - Windows の GVim 用のインストール例  
   1. Git Bash 上で以下を実行する。
      ```
      $ cd ~
      $ git clone https://github.com/tkatsu/vimfiles.git
      ```
      ※  vimfiles フォルダが既にあればリネームし、バックアップしておく。

   2. Git Bash 上で以下を実行する。
      ```
      $ cp vimfiles/_vimrc _vimrc
      $ cp vimfiles/_gvimrc _gvimrc
      ```
      ※  _vimrc, _gvimrc が既にあればリネームし、バックアップしておく。

   3. タスクバーなどから GVim を起動する。(終了・起動を2・3回繰返す)

   4. vimproc.vim の DLL(vimproc_win64.dll)のビルドまたはコピー
     - ビルド **しない** 場合
       [vimproc.vim プラグインの開発者 Shougoさんの URL](https://github.com/Shougo/vimproc.vim/releases) から
         `vimproc_winXX.dll` をダウンロードし、
       `~/vimfiles/dein/.cache/_vimrc/.dein/lib` にコピーする。  
       ※ XX の部分は OS のビット数 32 か 64 を表わす。

     - ビルド **する** 場合、以下を実行する。  
       Power Shell にて以下を実行する。
   
       ```
       $ cd ~\vimfiles\dein\repos\github.com\Shougo\vimproc.vim
       $ .\tools\update-dll-mingw.bat
       $ cp lib\vimproc_winXX.dll ~\vimfiles\dein\.cache\_vimrc\.dein\lib\
      
       ```
       尚、vimproc-vim のヘルプやネット上の情報に、Vim 上で以下を行えば良いように書かれているが、
       うまく行く場合と行かない場合がある。

        `:call dein#update('vimproc.vim')` または `:call dein#add('Shougo/vimproc.vim', {'build' : 'make'})`  

 - Windows の Git for Windows 付属の Vim 用のインストール例  
   1. Git Bash 上で以下を実行する。
      ```
      $ cd ~
      $ git clone https://github.com/tkatsu/vimfiles.git .vim
      ```
      ※  .vimフォルダが既にあればリネームし、バックアップしておく。

   1. Git Bash 上で以下を実行する。
      ```
      $ cp vimfiles/_vimrc .vimrc
      ```
      ※  .vimrc が既にあればリネームし、バックアップしておく。

   1. Git Bash 上で vim を起動する。(終了・起動を2・3回繰返す)

   ※ vimfils _vimrc を GVim と共用させることも可能だが、Linux 風の名称にして、独立させた方が無難。  
   ※ vimproc.vim の DLL(vimproc_cygwin.dll) のビルド環境がない為、 vimproc.vim を利用するプラグインには非対応。  

 - Linux でのインストール例
   1. コマンドラインで以下を実行する。
      ```
      $ cd ~
      $ git clone https://github.com/tkatsu/vimfiles.git .vim
      ```
      ※  .vimフォルダが既にあればリネームし、バックアップしておく。

   2. コマンドラインで以下を実行する。
      ```
      $ cp vimfiles/_vimrc .vimrc
      $ cp vimfiles/_gvimrc .gvimrc
      ```
      ※  .vimrc, .gvimrc が既にあればリネームし、バックアップしておく。

   3. vim を起動する。(終了・起動を2・3回繰返す)

   4. vimproc.vim の DLL(vimproc_linux64.so)のビルド  
      コマンドラインで以下を実行する。
      ```
      $ cd ~/.vim/dein/repos/github.com/Shougo/vimproc.vim
      $ make
      $ cp lib/vimproc_linux64.dll ~/.vim/dein/.cache/.vimrc/.dein/lib/
      ```
     
      ※ `:call dein#update('vimproc.vim')` または
       `:call dein#add('Shougo/vimproc.vim', {'build' : 'make'})` 
       の方法もあるが、Windows の時と同様に上手く行かな場合がある。

   5. kaoriyaさんの便利なプラグインと日本語対応ヘルプを使う(オプショナル)
      ```
      $ sudo mkdir -p /opt
      $ cd /opt
      $ sudo git clone https://github.com/koron/vim-kaoriya.git
      $ sudo git clone https://github.com/vim-jp/vimdoc-ja.git
      ```

  ※ 最初の Vim 実行時、`~/.vimbackup`  というディレクトリが自動的に作られる。
  ここにバックアップファイルなどの一時ファイルが保存される。

# カスタマイズの例
  ※ ファイル名、ディレクトリ名は Windows 版で説明。Linux の場合は適宜読み変える。  

  - プラグインマネージャー dein を無効する  
    `~/_vimrc` の中の以下の行の  '1' を '0' にする。

    ```
    let s:use_dein = 1
    ```
  - プラグイン `vim-clang` を有効にする  
    `~/vimfiles/rc/dein_lazy.toml` の中の以下の行の '0' を '1' にする。

    ```
    if = ''' 0 && dein#tap('neocomplete.vim') '''
    ```

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
