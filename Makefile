platform = --platform osx

bootstrap:
	carthage bootstrap $(platform)

update:
	carthage update $(platform)

synx:
	synx Yomu.xcodeproj

lint:
	swiftlint

.PHONY: carthage
