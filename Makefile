BUILDDIR := build
DBGDIR := $(BUILDDIR)/dbg
TGTDIR := $(BUILDDIR)/target
SRCDIR := src
INCDIR := include

CC := gcc
CFLAGS := -c -w -O2 -I$(INCDIR)
DBGFLAGS := -c -w -O2 -ggdb -I$(INCDIR)

SOURCES := $(shell find $(SRCDIR) -type f -iname '*.c')
HEADERS := $(shell find $(SRCDIR) -type f -iname '*.h')
TGTOBJ := $(subst src,$(TGTDIR),$(SOURCES:.c=.o))
DBGOBJ := $(subst src,$(DBGDIR),$(SOURCES:.c=.o))
TGTDIRS := $(sort $(subst src,$(TGTDIR),$(dir $(SOURCES))))
DBGDIRS := $(sort $(subst src,$(DBGDIR),$(dir $(SOURCES))))

build: target

run: target
	./$(TGTDIR)/compiler $(filter-out $@,$(MAKECMDGOALS))

target: $(TGTDIRS) $(TGTOBJ)
	$(CC) -o $(TGTDIR)/compiler $(TGTOBJ)

debug: $(DBGDIRS) $(DBGOBJ)
	$(CC) -o $(DBGDIR)/compiler $(DBGOBJ)

clean:
	rm -rf $(BUILDDIR)

$(DBGDIR)/%.o: $(SRCDIR)/%.c $(HEADERS)
	$(CC) -o $@ $(DBGFLAGS) $<

$(TGTDIR)/%.o: $(SRCDIR)/%.c $(HEADERS)
	$(CC) -o $@ $(CFLAGS) $<

$(TGTDIRS) $(DBGDIRS):
	mkdir -p $@

%:
	@:

# test_cases/t1.txt