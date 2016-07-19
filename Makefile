platform = --platform osx

bootstrap:
	carthage bootstrap $(platform)

update:
	carthage update $(platform)

.PHONY: carthage
