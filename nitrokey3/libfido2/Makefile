# Copyright (C) Nitrokey GmbH
# SPDX-License-Identifier: Unlicense

LDLIBS := -lfido2

SOURCES := list-credentials.c list-devices.c
BINARIES := list-credentials list-devices

.PHONY: all
all: $(BINARIES)

.PHONY: clean
clean:
	rm -fv $(BINARIES)

PHONY: check
check:
	clang-format --dry-run --Werror $(SOURCES)

PHONY: fix
fix:
	clang-format -i $(SOURCES)
