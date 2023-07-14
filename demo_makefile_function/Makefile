SHELL := /bin/bash
.ONESHELL:

define getIp
	fn="$0"
	box="$1"
	lxc info $$box | grep inet: | grep global | cut -d '/' -f 1 | awk '{print $$2}'
endef

all:
	@$(call getIp, "boxup");
	
