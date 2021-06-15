PREFIX?=/usr/local
INSTALL_NAME = spmgen

install: build install_bin

build:
	swift package clean
	swift package update
	swift build -c release --disable-sandbox --build-path '.build'

install_bin:
	mkdir -p $(PREFIX)/bin
	install .build/release/$(INSTALL_NAME) $(PREFIX)/bin

uninstall:
	rm -f $(PREFIX)/bin/$(INSTALL_NAME)

format: format-sources format-example

format-sources:
	swift format --in-place --recursive \
		./Package.swift ./Sources ./Tests

format-example:
	swift format --in-place --recursive \
		./Example/Package.swift ./Example/Sources \
		./Example/iOS ./Example/macOS ./Example/Shared