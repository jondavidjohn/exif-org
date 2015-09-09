test:
	@bash ./test/test.sh

install:
	cp ./media-org "$${DESTDIR:-/usr/local/bin}"
	chmod +x "$${DESTDIR:-/usr/local/bin}/media-org"

uninstall:
	rm "$${DESTDIR:-/usr/local/bin}/media-org"

.PHONY: test install
