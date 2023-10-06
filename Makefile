TARGET := iphone:clang:15.5:14.0
INSTALL_TARGET_PROCESSES = YouTube
GO_EASY_ON_ME = 1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = YouTubeReborn
YouTubeReborn_FILES = Tweak.xm $(shell find Controllers -name '*.m') $(shell find AFNetworking -name '*.m') $(shell find YouTubeExtractor -name '*.m')
YouTubeReborn_CFLAGS = -fobjc-arc -Wno-deprecated-declarations
YouTubeReborn_FRAMEWORKS = UIKit Foundation AVFoundation AVKit Photos Accelerate CoreMotion GameController VideoToolbox
YouTubeReborn_OBJ_FILES = $(shell find lib -name '*.a')
YouTubeReborn_LIBRARIES = bz2 c++ iconv z
ARCHS = arm64

include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/aggregate.mk
