# Main Dada Engine makefile

# destination for compiled binaries



prefix	= /usr/local
exec_prefix	= ${prefix}
bindir	= ${exec_prefix}/bin
datadir	= ${prefix}/lib
infodir	= ${prefix}/info
mandir	= ${prefix}/man

SHELL	= /bin/sh

INSTALL_DIRS	= ${bindir} ${datadir}/dada/include ${infodir} ${mandir}/man1

cpp 	= /usr/bin/cpp

INSTALL	=	/usr/bin/install -c

all:	dada
	
	$(MAKE) -C src
	$(MAKE) -C doc

dada:	dada.in
	sed -e "s/@PBDIR@/`echo ${bindir} |sed -e s/\\\\//\\\\\\\\\\\\\\//g `/g" <dada.in |sed -e "s/@DADAROOT@/`echo ${datadir} |sed -e s/\\\\//\\\\\\\\\\\\\\//g `\/dada/g" -e "s/@_CPP@/`echo ${cpp} |sed -e s/\\\\//\\\\\\\\\\\\\\//g `/g" >dada

install:	$(INSTALL_DIRS) \
	$(bindir)/pb ${bindir}/dada ${infodir}/dada.info
	$(INSTALL) -m 0644 include/*.pbi ${datadir}/dada/include
	$(INSTALL) -m 0644 man/*.1 ${mandir}/man1
	@echo 'Installation complete.'

${bindir}/pb:	src/pb
	$(INSTALL) -s src/pb ${bindir}
${bindir}/dada:	dada
	$(INSTALL) dada ${bindir}
${infodir}/dada.info:	doc/dada.info
	$(INSTALL) -m 0644 doc/dada.info ${infodir}

# dependencies for installation

$(INSTALL_DIRS):
	$(SHELL) mkdirs.sh $@


clean:
	rm -f *~ dada
	( cd src ; make clean )
	( cd doc ; make clean )
	( cd regex ; make clean )
distclean:	clean
	rm -f config.cache config.log config.status
	rm -f src/Makefile doc/Makefile regex/Makefile Makefile src/config.h inst


dada.tar.gz:
	tar cvf dada.tar src/*.[chxy] src/config.h.in man scripts/*.pb Makefile.in */Makefile.in doc/*.texi include/*.pbi dadaprolog.ps dada.in README COPYING regex/*.[ch37] regex/sys/* regex/COPYRIGHT install-sh configure
	gzip -9c dada.tar >dada.tar.gz
	rm dada.tar

