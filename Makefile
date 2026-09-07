.PHONY: all brew-install install generate swiftgen lint test open

TEST_DESTINATION ?= platform=iOS Simulator,name=iPhone 17

all: brew-install install generate swiftgen open

brew-install:
	brew install mint libxml2

install:
	mint bootstrap
	bundle install

# generate
generate:
	mint run xcodegen xcodegen generate

# swiftgen
swiftgen:
	mint run swiftgen

# lint
lint:
	mint run swiftlint swiftlint --no-cache Sources Tests

# test
test:
	xcodebuild -project my-app.xcodeproj -scheme my-app -destination '$(TEST_DESTINATION)' -skipMacroValidation -enableCodeCoverage YES test CODE_SIGNING_ALLOWED=NO

# open xcode
open:
	xed .
