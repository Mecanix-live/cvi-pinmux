# CVI Pinmux Makefile - for direct source directory build

# Configuration - set ONE of these to 'y'
CVI_PINMUX_CV180X ?= n
CVI_PINMUX_SG200X ?= y

# Installation directories
PREFIX = /usr
DESTDIR = 
TARGET_DIR = $(DESTDIR)$(PREFIX)
BIN_DIR = $(TARGET_DIR)/bin

# Compiler settings
CC = gcc
CFLAGS = -O2 -Wall
LDFLAGS = 

# Source directory selection
ifeq ($(CVI_PINMUX_CV180X),y)
    CVI_SRC_DIR = cv180x
else ifeq ($(CVI_PINMUX_SG200X),y)
    CVI_SRC_DIR = sg200x
else
    $(error "Please set either CVI_PINMUX_CV180X=y or CVI_PINMUX_SG200X=y")
endif

# Source files
SOURCES = $(wildcard $(CVI_SRC_DIR)/*.c)
TARGET = cvi-pinmux

.PHONY: all build install clean help

all: build

build: $(TARGET)

$(TARGET): $(SOURCES)
	@echo "Building cvi-pinmux for $(CVI_SRC_DIR)..."
	$(CC) $(CFLAGS) $(LDFLAGS) $(SOURCES) -o $@
	@echo "Build complete: $@"

install: build
	@echo "Installing to target..."
	install -d $(BIN_DIR)
	install -m 0755 $(TARGET) $(BIN_DIR)/
	@echo "Installed to $(BIN_DIR)/cvi-pinmux"

clean:
	@echo "Cleaning build..."
	rm -f $(TARGET)

distclean: clean
	@echo "Dist clean complete"

help:
	@echo "CVI Pinmux Build Options:"
	@echo "  make CVI_PINMUX_SG200X=y build    # Build for SG200X (default)"
	@echo "  make CVI_PINMUX_CV180X=y build    # Build for CV180X"
	@echo ""
	@echo "Standard targets:"
	@echo "  make build    # Build the binary"
	@echo "  make install  # Install system-wide"
	@echo "  make clean    # Remove the binary"
	@echo ""
	@echo "Current configuration:"
	@echo "  CVI_SRC_DIR: $(CVI_SRC_DIR)"
	@echo "  SOURCES: $(SOURCES)"

# Set SG200X as default if nothing is specified
ifneq ($(CVI_PINMUX_CV180X),y)
    CVI_PINMUX_SG200X = y
endif
