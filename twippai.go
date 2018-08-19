package main

import (
	"flag"
	"fmt"
	"io"
	"log"
	"net/http"
	"net/url"
	"os"
	"strconv"

	"github.com/ChimeraCoder/anaconda"
)

const (
	consumerKey       = "" //set your consumer key
	consumerSecret    = "" //set your consumer secret
	accessToken       = "" //set your token
	accessTokenSecret = "" //set your token secret
)

func getTwitterApi() *anaconda.TwitterApi {
	anaconda.SetConsumerKey(consumerKey)
	anaconda.SetConsumerSecret(consumerSecret)
	api := anaconda.NewTwitterApi(accessToken, accessTokenSecret)
	return api
}

var (
	word   = flag.String("word", "おっぱい", "put a keyword")
	length = flag.Int("len", 10, "how many images do you want to get")
)

func main() {
	flag.Parse()
	createDirIfNotExist("go-twippai")
	api := getTwitterApi()
	getResult(api, *word, *length)
}

func createDirIfNotExist(dir string) {
	if _, err := os.Stat(dir); os.IsNotExist(err) {
		err = os.MkdirAll(dir, 0755)
		if err != nil {
			panic(err)
		}
	}
}

func getResult(api *anaconda.TwitterApi, word string, length int) {
	var counter = 1
	stream := api.PublicStreamFilter(url.Values{
		"track": []string{"#" + word},
	})
	defer stream.Stop()
	for v := range stream.C {
		t, ok := v.(anaconda.Tweet)
		if !ok {
			log.Fatal("recerived unexpected value", ok)
			continue
		}
		for _, media := range t.ExtendedEntities.Media {
			if counter == length {
				break
			}
			if media.Media_url_https != "" && media.Type == "photo" {
				save(media.Media_url_https, counter)
				counter++
			}
		}
	}
}

func save(url string, counter int) {
	response, e := http.Get(url)
	if e != nil {
		log.Fatal(e)
	}

	defer response.Body.Close()
	filename := "go-twippai/image_" + strconv.Itoa(counter) + ".jpg"
	file, err := os.Create(filename)
	if err != nil {
		log.Fatal(err)
	}

	_, err = io.Copy(file, response.Body)
	if err != nil {
		log.Fatal(err)
	}

	file.Close()
	fmt.Println(url+" Success!", "[", counter, "]")
}
