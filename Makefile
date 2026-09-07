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

# test
test:
	xcodebuild -project my-app.xcodeproj -scheme my-app -destination 'platform=iOS Simulator,name=iPhone 17' -skipMacroValidation test CODE_SIGNING_ALLOWED=NO

# open xcode
open:
	xed .

