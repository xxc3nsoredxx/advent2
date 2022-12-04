clone: clone.o lib.o
	$(LD) $(LDFLAGS) $^ -o $@

clone.o: clone.asm lib.h
	$(AS) $(ASFLAGS) $< -o $@
