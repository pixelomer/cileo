THEOS_DEVICE_IP = 0
THEOS_DEVICE_PORT = 2222
TARGET = iphone:11.2:11.0
ARCHS = arm64
export TARGET ARCHS

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Cileo
Cileo_FILES = Extensions/UIAlertController+PresentAlertWithTitle.m libu0sileo/u0sileo.m Tweak.xm

include $(THEOS_MAKE_PATH)/tweak.mk


SUBPROJECTS += silo
include $(THEOS_MAKE_PATH)/aggregate.mk
