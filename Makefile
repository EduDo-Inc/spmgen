PREFIX?=/usr/local
INSTALL_NAME = spmgen

install: build install_bin

build:
	swift package update
	swift build -c release --disable-sandbox --build-path '.build'

install_bin:
	mkdir -p $(PREFIX)/bin
	install .build/release/$(INSTALL_NAME) $(PREFIX)/bin

uninstall:
	rm -f $(PREFIX)/bin/$(INSTALL_NAME)

format:
	swift format --in-place --recursive \
		./Package.swift ./Sources ./Tests