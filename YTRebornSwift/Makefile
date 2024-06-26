TARGET := iphone:clang:17.5:15.0
INSTALL_TARGET_PROCESSES = YouTube
GO_EASY_ON_ME = 1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = YTRebornSwift
YTRebornSwift_FILES = $(shell find Sources/YouTubeReborn -name '*.swift') $(shell find Sources/YouTubeRebornC -name '*.m' -o -name '*.c' -o -name '*.mm' -o -name '*.cpp')
YTRebornSwift_SWIFTFLAGS = -ISources/YouTubeRebornC/include
YTRebornSwift_CFLAGS = -fobjc-arc -ISources/YouTubeRebornC/include
YTRebornSwift_FRAMEWORKS = Foundation UIKit
ARCHS = arm64

include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/aggregate.mk