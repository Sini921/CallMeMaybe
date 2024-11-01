ifeq ($(ROOTLESS),1)
THEOS_DEVICE_IP = 192.168.1.8
THEOS_DEVICE_PORT = 22
THEOS_PACKAGE_SCHEME = rootless
else ifeq ($(ROOTHIDE),1)
THEOS_PACKAGE_SCHEME = roothide
else
THEOS_DEVICE_IP = 192.168.1.9
THEOS_DEVICE_PORT = 22
endif

DEBUG = 0
FINALPACKAGE = 1
ARCHS = arm64 arm64e
TARGET := iphone:clang:latest:14.0
INSTALL_TARGET_PROCESSES = MobilePhone
PACKAGE_VERSION = 1.0.1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = CallMeMaybe
$(TWEAK_NAME)_FILES = Tweak.x Prefs/Prefs.m $(wildcard Utils/*.m)
$(TWEAK_NAME)_CFLAGS = -fobjc-arc -DTWEAK_VERSION=$(PACKAGE_VERSION)

include $(THEOS_MAKE_PATH)/tweak.mk
