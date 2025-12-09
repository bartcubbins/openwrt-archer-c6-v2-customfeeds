# SPDX-License-Identifier: MIT
# Copyright (C) 2025 Pavel Dubrova <pashadubrova@gmail.com>

include $(TOPDIR)/rules.mk

PKG_NAME:=wan-led-monitor
PKG_VERSION:=1.0
PKG_RELEASE:=1

PKG_MAINTAINER:=Pavel Dubrova <pashadubrova@gmail.com>
PKG_LICENSE:=MIT
PKG_LICENSE_FILES:=LICENSE

include $(INCLUDE_DIR)/package.mk

define Package/wan-led-monitor
	SECTION:=utils
	CATEGORY:=Utilities
	TITLE:=WAN LED Monitor Script
	DEPENDS:=+swconfig
endef

define Package/wan-led-monitor/description
	A script that monitors WAN link and controls LEDs.
endef

define Build/Compile
	# Nothing to compile for script-only package
endef

define Package/wan-led-monitor/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) ./files/usr/sbin/wan-led-monitor.sh $(1)/usr/sbin/

	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/etc/init.d/wan-led-monitor $(1)/etc/init.d/
endef

define Package/wan-led-monitor/postinst
#!/bin/sh
[ -n "$$IPKG_INSTROOT" ] || /etc/init.d/wan-led-monitor enable
exit 0
endef

$(eval $(call BuildPackage,wan-led-monitor))
