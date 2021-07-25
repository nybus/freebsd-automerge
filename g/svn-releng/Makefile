# $Id: Makefile,v 1.4 2015/10/27 21:40:47 rmon Exp $

TAG?=X.X

TAGS= \
	9.0 \
	9.1 \
	9.2 \
	9.3 \
	10.0 \
	10.1 \
	10.2 \
	10.3 \
	11.2 \
	11.3 \
	11.4

#TEMPROOT=/var/tmp/temproot-debug
TEMPROOT?=/var/tmp/temproot-${.MAKE.PID}

SVNROOT=svn://svn.freebsd.org/base/releng

_USR=${TEMPROOT}/usr
_SRC?=${TEMPROOT}/usr/src

CO=svn co ${SVNROOT}/${TAG}/
COE=${CO} --depth empty

UP=svn up
UPE=${UP} --set-depth empty
UPL=${UP} --set-depth files

nop:

setup:
	ln -s ../../cf .

rm:
	-rm -rf ${TEMPROOT}/*
	chflags -R noschg ${TEMPROOT}
	rm -rf ${TEMPROOT}
#
co:
	mkdir -p ${_USR}
	cd ${_USR}; ${COE} src
	cd ${_USR}; ${UPL} src
	cd ${_USR}; ${UP} src/etc
	cd ${_USR}; ${UPE} src/share
	cd ${_USR}; ${UP} src/share/mk
	cd ${_USR}; ${UPL} src/gnu
	cd ${_USR}; ${UP} src/gnu/usr.bin
	cd ${_USR}; ${UPE} src/usr.bin
	cd ${_USR}; ${UP} src/usr.bin/mail
	cd ${_USR}; ${UP} src/usr.bin/locate
	cd ${_USR}; ${UPE} src/contrib
	cd ${_USR}; ${UPE} src/contrib/sendmail
	cd ${_USR}; ${UP} src/contrib/sendmail/cf
	cd ${_USR}; ${UP} src/contrib/sendmail/src
#	cd ${_USR}; ${UPE} src/share
	cd ${_USR}; ${UP} src/share/termcap
	cd ${_USR}; ${UPE} src/usr.sbin
	cd ${_USR}; ${UP} src/usr.sbin/rmt
	cd ${_USR}; ${UPE} src/contrib/openbsm
	cd ${_USR}; ${UP} src/contrib/openbsm/etc
	cd ${_USR}; ${UPE} src/crypto
	cd ${_USR}; ${UP} src/crypto/openssh
	cd ${_USR}; ${UPE} src/crypto/openssl
	cd ${_USR}; ${UP} src/crypto/openssl/apps
	cd ${_USR}; ${UPE} src/sys
	cd ${_USR}; ${UPE} src/sys/i386
	cd ${_USR}; ${UPE} src/sys/amd64
	cd ${_USR}; ${UP} src/sys/i386/conf
	cd ${_USR}; ${UP} src/sys/amd64/conf
	cd ${_USR}; ${UPE} src/sys/sys
	cd ${_USR}; ${UP} src/sys/sys/param.h

co2:

#	make -m ${_SRC}/share/mk -C ${_SRC} distrib-dirs DESTDIR=${TEMPROOT}
up:
	make -m ${_SRC}/share/mk -C ${_SRC}/etc distrib-dirs DESTDIR=${TEMPROOT}
#	make -m ${_SRC}/share/mk -C ${_SRC} _obj SUBDIR_OVERRIDE=etc
	make -m ${_SRC}/share/mk -C ${_SRC} everything SUBDIR_OVERRIDE=etc
	make -m ${_SRC}/share/mk -C ${_SRC} distribution DESTDIR=${TEMPROOT}

cf: .PHONY
	mkdir -p ${.CURDIR}/cf
	cd ${TEMPROOT}; find -x . -type f \! -path './usr/src/*' -print0 | xargs -0 sha256 -r > ${.CURDIR}/cf/SVN_${TAG}.sha256

step: co up cf rm

generate:
	@echo "> ${.TARGET} started on `LC_ALL=C date`"
.for i in ${TAGS}
	${MAKE} step TAG=${i}
.endfor
	@echo "> ${.TARGET} completed on `LC_ALL=C date`"
	cat cf/*.sha256 | cut -d ' ' -f 2- | sort | uniq > cf/index.txt

debug:
