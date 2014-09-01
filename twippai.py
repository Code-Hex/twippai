#!/usr/bin/python
# coding: utf-8

import os
import json
import time
import requests
from hashlib import md5
from requests_oauthlib import OAuth1

def md5hex(str):
	a = md5()
	a.update(str)
	return a.hexdigest()

folder = './data'
path = os.path.exists(folder)
if not path:
	os.mkdir(folder)

consumer_key = '' #Your consumer_key
consumer_secret = '' #Your consumer_secret
access_token = '' #Your access_token
access_token_secret = '' #Your access_token_secret

url = 'https://api.twitter.com/1.1/search/tweets.json'
oauth = OAuth1(consumer_key,consumer_secret,
		access_token,access_token_secret,
		signature_method = 'HMAC-SHA1')
idnum = ''
count = 1
while 1: #while TRUE よりもこっちが高速
	query_form = {'q' : u'#おっぱい',
					  'lang' : 'ja',
					  'rpp' : 100,
					  'result_type' : 'recent',
					  'max_id' : idnum}

	uri = requests.get(url, auth = oauth, params = query_form)
	json_loads = json.loads(uri.content)

	for data in json_loads['statuses']:
		if 'media' not in data['entities']:
			continue
		else:
			urls = data['entities']['media']
			media_urls = urls[0]['media_url'] #画像のURL取得
			downloads = requests.get(media_urls).content #画像のダウンロード
			print "\r" + media_urls + " " + str([count])
		filename = '%s.jpg' % md5hex(urls[0]['media_url'])
		filepath = '%s/%s' % (folder, filename)

		images = open(filepath, 'wb')
		images.write(downloads)
		images.close()
		count += 1
	idnum = data['id']
	time.sleep(1)