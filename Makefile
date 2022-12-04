INC = $(realpath include/)
LIB = $(realpath lib/)

export VPATH = $(INC):$(LIB)

export AS 		= nasm
export ASFLAGS	= -felf64 -I$(INC)/
export LDFLAGS	= -melf_x86_64

.PHONY: all clone lib

all: clone

lib:
	$(MAKE) -C lib

clone: lib
	$(MAKE) -C 02-clone
