################################################################################
#
# fake_hw_clock
#
################################################################################

FAKE_HW_CLOCK_VERSION = 1.0
FAKE_HW_CLOCK_INSTALL_STAGING = NO

define FAKE_HW_CLOCK_EXTRACT_CMDS

endef

define FAKE_HW_CLOCK_INSTALL_TARGET_CMDS
    $(INSTALL) -D -m 0755 package/fake_hw_clock/S00fake-hw-clock $(TARGET_DIR)/etc/init.d/
    echo "2014-08-07 14:55:11" > $(TARGET_DIR)/etc/fake-hw-clock
endef

$(eval $(generic-package))
