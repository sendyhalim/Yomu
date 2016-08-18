platform = --platform osx
xcode_flags = -project Yomu.xcodeproj -scheme 'Yomu' -configuration Release DSTROOT=/tmp/Yomu.dst
xcode_flags_test = -project Yomu.xcodeproj -scheme 'Yomu' -configuration Debug
components_plist = Yomu/Components.plist
temporary_dir = /tmp/Yomu.dst
output_package_name = Yomu.pkg

bootstrap:
	carthage bootstrap $(platform)

update:
	carthage update $(platform)

synx:
	synx Yomu.xcodeproj

clean:
	rm -rf $(temporary_dir)
	rm -f $(output_package_name)
	xcodebuild $(xcode_flags) clean

test: clean bootstrap
	xcodebuild $(xcode_flags_test) test

installables: clean bootstrap
	xcodebuild $(xcode_flags) install

lint:
	swiftlint

package: installables
	pkgbuild \
		--component-plist $(components_plist) \
		--identifier "com.sendyhalim.yomu" \
		--install-location "/" \
		--root $(temporary_dir) \
		$(output_package_name)


.PHONY: bootstrap update synx clean test installables lint package
