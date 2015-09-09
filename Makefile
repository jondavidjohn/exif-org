test:
	@bash ./test/test.sh

install:
	cp ./exif-org "$${DESTDIR:-/usr/local/bin}"
	chmod +x "$${DESTDIR:-/usr/local/bin}/exif-org"

uninstall:
	rm "$${DESTDIR:-/usr/local/bin}/exif-org"

.PHONY: test install
