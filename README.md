twippai
=======

Perl、Python、RubyでTwitterからたくさんのおっぱいをダウンロードするっていうのを作った！  
  
##参考:  
###Ruby:  
https://gist.github.com/mitukiii/2775321  
  
###Python:  
http://jp.python-requests.org/en/latest/ ←神!!  
http://www.gesource.jp/programming/python/code/0008.html  
  
##元ネタ  
プログラミングのきっかけを作ってくれたゆーすけべーさんの記事  
http://yusukebe.com/archives/20120229/072808.html  
  
  
##使い方
![これ](https://github.com/Code-Hex/twippai/blob/master/sample.gif)  
  
cd でディレクトリを変更しなかった場合、data フォルダはホームディレクトリに作成されます。  
  
Perl:  
LWP::Authen::OAuth  
Path::Class  
JSON::XS  
のモジュールを sudo cpan install でインストールすれば、このスクリプトは使えるはず...  
  
%cd (スクリプトが入ってるディレクトリ)
%perl twi.pl  
  
Python:  
json  
requests  
hashlib  
requests_oauthlib  
のモジュールを sudo pip install でインストールすれば、このスクリプトは使えるはず...  
※Python だけ実行中の表示が違います。  
  
%cd (スクリプトが入ってるディレクトリ)
%pyton twi.py  
  
Ruby:  
faraday  
simple_oauth  
faraday_middleware  
のモジュールを sudo gem install でインストールすれば、このスクリプトは使えるはず...  

%cd (スクリプトが入ってるディレクトリ)
%ruby twi.rb  
  
