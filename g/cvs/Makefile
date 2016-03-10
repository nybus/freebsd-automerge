# $Id: Makefile,v 1.2 2014/03/23 05:13:37 rmon Exp $

#TAG=RELENG_7_0
#TAG?=RELENG_8_0
TAG?=RELENG_X_X

TAGS= \
	RELENG_6_0 \
	RELENG_6_1 \
	RELENG_6_2 \
	RELENG_6_3 \
	RELENG_6_4 \
	RELENG_7_0 \
	RELENG_7_1 \
	RELENG_7_2 \
	RELENG_7_3 \
	RELENG_7_4 \
	RELENG_8_0 \
	RELENG_8_1 \
	RELENG_8_2 \
	RELENG_8_3 \
	RELENG_8_4 \
	RELENG_9_0

#TEMPROOT=/var/tmp/temproot-debug
TEMPROOT?=/var/tmp/temproot-${.MAKE.PID}

CVSROOT=:pserver:anoncvs@anoncvs.fr.FreeBSD.org:/home/ncvs

_USR=${TEMPROOT}/usr
_SRC=${TEMPROOT}/usr/src

nop:

setup:
	ln -s ../../cf .

rm:
	-rm -rf ${TEMPROOT}
	chflags -R noschg ${TEMPROOT}
	rm -rf ${TEMPROOT}
#
co:
	mkdir -p ${_USR}
	cd ${_USR}; cvs -R -z3 -d ${CVSROOT} co -r ${TAG} -l src
	cd ${_USR}; cvs -R -z3 -d ${CVSROOT} co -r ${TAG} src/etc
	cd ${_USR}; cvs -R -z3 -d ${CVSROOT} co -r ${TAG} src/share/mk
	cd ${_USR}; cvs -R -z3 -d ${CVSROOT} co -r ${TAG} -l src/gnu
	cd ${_USR}; cvs -R -z3 -d ${CVSROOT} co -r ${TAG} src/gnu/usr.bin
	cd ${_USR}; cvs -R -z3 -d ${CVSROOT} co -r ${TAG} src/usr.bin/mail
	cd ${_USR}; cvs -R -z3 -d ${CVSROOT} co -r ${TAG} src/usr.bin/locate
	cd ${_USR}; cvs -R -z3 -d ${CVSROOT} co -r ${TAG} src/contrib/sendmail/cf
	cd ${_USR}; cvs -R -z3 -d ${CVSROOT} co -r ${TAG} src/contrib/sendmail/src
	cd ${_USR}; cvs -R -z3 -d ${CVSROOT} co -r ${TAG} src/share/termcap
	cd ${_USR}; cvs -R -z3 -d ${CVSROOT} co -r ${TAG} src/usr.sbin/rmt
	cd ${_USR}; cvs -R -z3 -d ${CVSROOT} co -r ${TAG} src/contrib/openbsm/etc
	cd ${_USR}; cvs -R -z3 -d ${CVSROOT} co -r ${TAG} src/crypto/openssh
	cd ${_USR}; cvs -R -z3 -d ${CVSROOT} co -r ${TAG} src/crypto/openssl/apps
	cd ${_USR}; cvs -R -z3 -d ${CVSROOT} co -r ${TAG} src/sys/i386/conf
	cd ${_USR}; cvs -R -z3 -d ${CVSROOT} co -r ${TAG} src/sys/amd64/conf

co2:

#	make -m ${_SRC}/share/mk -C ${_SRC} distrib-dirs DESTDIR=${TEMPROOT}
up:
	make -m ${_SRC}/share/mk -C ${_SRC}/etc distrib-dirs DESTDIR=${TEMPROOT}
#	make -m ${_SRC}/share/mk -C ${_SRC} _obj SUBDIR_OVERRIDE=etc
	make -m ${_SRC}/share/mk -C ${_SRC} everything SUBDIR_OVERRIDE=etc
	make -m ${_SRC}/share/mk -C ${_SRC} distribution DESTDIR=${TEMPROOT}

cf: .PHONY
	mkdir -p ${.CURDIR}/cf
	cd ${TEMPROOT}; find -x . -type f \! -path './usr/src/*' -print0 | xargs -0 sha256 -r > ${.CURDIR}/cf/${TAG}.sha256

step: co up cf rm

generate:
	@echo "> ${.TARGET} started on `LC_ALL=C date`"
.for i in ${TAGS}
	${MAKE} step TAG=${i}
.endfor
	@echo "> ${.TARGET} completed on `LC_ALL=C date`"
	cat cf/*.sha256 | cut -d ' ' -f 2- | sort | uniq > cf/index.txt

debug:
