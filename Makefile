.PHONY: all browser

all: dist/elm.js dist/index.html

dist/elm.js: src/*.elm
	elm make src/Main.elm --output dist/elm.js

dist/index.html: index.html
	cp index.html dist/index.html

browser: all
	open dist/index.html
