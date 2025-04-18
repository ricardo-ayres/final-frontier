export CFLAGS = -O2 -g -Wall -DOGG_MUSIC
export LIBS = -lGL -lGLU -lvorbisfile -lvorbis -logg
export FE2OBJS = ../fe2.part1.o ../fe2.part2.o

THIS=Makefile
VERSION=20060623

default:
	$(MAKE) -f $(THIS) fe2obj
	$(MAKE) -C src/

fe2clean:
	rm -f fe2.s.bin
	rm -f fe2.part1.o
	rm -f fe2.part2.o
	rm -f fe2.s.c
	rm -f frontier

fe2:
	$(MAKE) -f $(THIS) fe2clean
	$(MAKE) -f $(THIS) fe2obj
	$(MAKE) -C src/

fe2s: 
	$(MAKE) -C as68k/
	as68k/as68k --output-c fe2.s

fe2obj: fe2.s.c
	# this bit can be optimised because it is lots of small functions
	$(CC) -DPART1 -O1 -fomit-frame-pointer -Wall -Wno-unused -s `sdl-config --cflags` -c fe2.s.c -o fe2.part1.o
	# this can't unless you have shitloads of memory and a meaty
	# machine, because it is a huge stinking function.
	$(CC) -DPART2 -O0 -fomit-frame-pointer -Wall -Wno-unused -s `sdl-config --cflags` -c fe2.s.c -o fe2.part2.o

clean:
	$(MAKE) -C src/ clean
	rm -f frontier
	$(MAKE) -f $(THIS) fe2clean

allclean:
	$(MAKE) -f $(THIS) clean
	$(MAKE) -C as68k/ clean
	$(MAKE) -C dis68k/ clean
	$(MAKE) -f $(THIS) fe2clean

# To make a nice clean tarball
dist:
	$(MAKE) -f Makefile-i386 clean
	$(MAKE) -f $(THIS) allclean
	mkdir frontvm3-$(VERSION)
	mkdir frontvm3-$(VERSION)/as68k
	mkdir frontvm3-$(VERSION)/dis68k
	mkdir frontvm3-$(VERSION)/src
	mkdir frontvm3-$(VERSION)/savs
	#mkdir frontvm3-$(VERSION)/sfx
	#mkdir frontvm3-$(VERSION)/music
	cp as68k/* frontvm3-$(VERSION)/as68k
	cp dis68k/* frontvm3-$(VERSION)/dis68k
	cp src/* frontvm3-$(VERSION)/src
	#cp sfx/* frontvm3-$(VERSION)/sfx
	#cp music/* frontvm3-$(VERSION)/music
	cp fe2.s frontvm3-$(VERSION)
	cp m68000.h frontvm3-$(VERSION)
	cp _host.c frontvm3-$(VERSION)
	cp notes.txt frontvm3-$(VERSION)
	cp benchmarks.txt frontvm3-$(VERSION)
	cp README frontvm3-$(VERSION)
	cp TODO frontvm3-$(VERSION)
	cp Makefile-i386 frontvm3-$(VERSION)
	cp Makefile-C frontvm3-$(VERSION)
	cp Makefile-mingw frontvm3-$(VERSION)
	tar cvjf frontvm3-$(VERSION).tar.bz2 frontvm3-$(VERSION)
	rm -rf frontvm3-$(VERSION)

# save bandwidth...
audio-dist:
	mkdir frontvm-audio-$(VERSION)
	mkdir frontvm-audio-$(VERSION)/sfx
	mkdir frontvm-audio-$(VERSION)/music
	cp sfx/* frontvm-audio-$(VERSION)/sfx
	cp music/* frontvm-audio-$(VERSION)/music
	tar cvjf frontvm-audio-$(VERSION).tar.bz2 frontvm-audio-$(VERSION)
	rm -rf frontvm-audio-$(VERSION)

