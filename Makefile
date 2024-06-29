TARGET := iphone:clang:17.5:15.0
INSTALL_TARGET_PROCESSES = YouTube

export PREFIX = /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/
include $(THEOS)/makefiles/common.mk

SUBPROJECTS += YTRebornObjc YTRebornSwift

include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/aggregate.mk