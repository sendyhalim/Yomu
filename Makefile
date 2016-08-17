platform = --platform osx
xcode_flags = -project Yomu.xcodeproj -scheme 'Yomu' -configuration Release DSTROOT=/tmp/Yomu.dst
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

install: clean
	xcodebuild $(xcode_flags) install

lint:
	swiftlint

package: install
	pkgbuild \
		--component-plist $(components_plist) \
		--identifier "com.sendyhalim.yomu" \
		--install-location "/" \
		--root $(temporary_dir) \
		$(output_package_name)


.PHONY: carthage
