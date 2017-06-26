export TARGET = iphone:latest:latest
include $(THEOS)/makefiles/common.mk

#SOURCES := $(wildcard Folder/*.m)

TWEAK_NAME = GhostBuster
GhostBuster_FILES = Tweak.xm $(SOURCES)
#GhostBuster_FRAMEWORKS = UIKit
#GhostBuster_PRIVATE_FRAMEWORKS = ChatKit
GhostBuster_CFLAGS += -Wno-objc-property-no-attribute
GhostBuster_CFLAGS += -Wno-deprecated-declarations
#GhostBuster_CFLAGS += -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

before-stage::
	find . -name ".DS_Store" -delete

after-install::
	install.exec "killall -9 SpringBoard"
