# rss-update-bot
### _ava fox_

a mastodon bot that posts when an rss feed updates

## Installation

download binary from [releases](https://github.com/compufox/rss-update-bot/releases)

copy provided example config and populate it with valid tokens

if `poll-interval` is not provided, 3 hours is used

## Usage

specify a config file to use: `./rss-bot -c CONFIG`

pass in an RSS feed url: `./rss-bot URL+`

full usage example: 
`./rss-bot -c your.config https://my.cool.blog/rss/feed.xml`

multiple feeds:
`./rss-bot -c your.config https://my.cool.blog/rss/feed.xml https://my.second.blog/rss/feed.xml`

## Building

- install a lisp ([Roswell](https://github.com/roswell/roswell))

- create a `~/common-lisp` directory

- clone this repo, and the framework's repo

- run a few lisp commands

(`$` denotes a system shell, `*` denotes a lisp repl)

```shell
$ mkdir ~/common-lisp
$ git clone https://github.com/compufox/rss-update-bot ~/common-lisp/rss-update-bot
$ git clone https://github.com/compufox/glacier ~/common-lisp/glacier
$ ros run

* (ql:quickload :rss-update-bot)
* (asdf:make :rss-update-bot)
```

if everything goes smoothly, you should have created a binary:  `~/common-lisp/rss-update-bot/bin/rss-bot`

## License

NPLv1+

