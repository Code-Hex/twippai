#!/usr/bin/ruby

require 'rubygems'
require 'faraday'
require 'pathname'
require 'digest/md5'
require 'simple_oauth'
require 'faraday_middleware'

folder = Pathname.new('./data')
Dir.mkdir folder unless File.exists?(folder)

consumer_key = '' #Your consumer_key
consumer_secret = '' #Your consumer_secret
access_token = '' #Your access_token
access_token_secret = '' #Your access_token_secret

uri = 'https://api.twitter.com/1.1/search/tweets.json'
kao = ["( ･ω ･)","(  ･ω )","(    ･)","(     )","(･    )","( ω ･ )"];

faraday = Faraday.new(:url => uri) do |modules|
	oauth = {
		consumer_key: consumer_key,
		consumer_secret: consumer_secret,
		token: access_token,
		token_secret: access_token_secret
	}
	  modules.request	:url_encoded
	  modules.request	:oauth, oauth
	 #modules.response	:logger 確認用
	  modules.response :json, content_type: /\bjson$/
	  modules.adapter	:net_http
end

id = ''
count, i = 1, 0
loop do
	query_form = faraday.get uri, {
		q: '#おっぱい',
		lang: 'ja',
	    rpp: 100,
	    max_id: id,
		result_type: 'recent'
	} 

	abort("Error: #{query_form.status}") unless query_form.status == 200

	for data in query_form.body['statuses']
	next unless data['entities']['media']
		urls = data['entities']['media']
		media_urls = urls[0]['media_url'] #画像のURL取得
		print kao[i==5? i=0 : i+=1] + " Downloading... #{media_urls} [#{count}]\r"
		res = faraday.get media_urls
		filename = Digest::MD5.hexdigest(media_urls) + '.jpg'
		filepath = folder + filename
		File.open(filepath,'wb'){ |fp| fp.write(res.body)}
		count += 1
	end
	id = data['id']
	sleep(1)
end