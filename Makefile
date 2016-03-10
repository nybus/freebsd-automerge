# $Id: Makefile,v 1.10 2016/03/10 14:05:52 rmon Exp $

JX?=/js/?/j0

DSC=libexec/ld-elf\.so\.[0-9]+

JAIL_ROOT?=/js/1/j0/b9

TEMP_ROOT=/var/tmp/temproot${JAIL_ROOT:C/[^0-9a-zA-Z]+/_/g}

nop:

rm:
	-rm -rf ${TEMP_ROOT}
	@if [ -e ${TEMP_ROOT} ]; then \
		chflags -fR noschg ${TEMP_ROOT}; \
		rm -rf ${TEMP_ROOT}; \
	fi

up:
	mkdir -p ${TEMP_ROOT}
	cd /usr/src/etc; ${MAKE} distrib-dirs DESTDIR=${TEMP_ROOT}
	cd /usr/src/etc; ${MAKE} distribution DESTDIR=${TEMP_ROOT}

match:
	cd ${TEMP_ROOT}; find -x . -type f -print0 | xargs -0 sha256 -r > ${.CURDIR}/l-actual.sha256
	cd ${JAIL_ROOT}; cat ${.CURDIR}/cf/index.txt | ${.CURDIR}/e.pl -0 | xargs -0 sha256 -r > ${.CURDIR}/l-obsolete.sha256
#
	cat l-obsolete.sha256 | ./match.pl --subj=l-actual.sha256 --mode=match cf/*.sha256 > l-match.txt
	cat l-obsolete.sha256 | ./match.pl --subj=l-actual.sha256 --mode=stale cf/*.sha256 > l-stale.txt
#
	cp -p l-match.txt ${TEMP_ROOT}/
	cp -p l-stale.txt ${TEMP_ROOT}/

commit:
	rsync -avPHx --files-from=l-match.txt -c -O ${TEMP_ROOT}/ ${JAIL_ROOT}/ > ${TEMP_ROOT}/rsync.log
	cd ${TEMP_ROOT}; cat ${.CURDIR}/l-match.txt | ${.CURDIR}/join.pl | xargs -0 rm -f
	cd ${JAIL_ROOT}; cat ${.CURDIR}/l-stale.txt | ${.CURDIR}/join.pl | xargs -0 rm -f

tidy:
.for fn in mail/*.cf aliases rmt termcap motd pwd.db spwd.db
	rm -f ${TEMP_ROOT}/etc/${fn}
.endfor
	-chflags -fR noschg ${TEMP_ROOT}
.for i in 1 2 3 4 5 6 7 8
	find -x ${TEMP_ROOT} -type d -empty -print0 | xargs -0 rm -r
	find -x -L ${TEMP_ROOT} -type l -print0 | xargs -0 rm -f
.endfor

step: rm up match commit tidy

base:
	find -E -x ${JX} -type f -regex '.*/${DSC}$$' -maxdepth 6 | sed -E 's#/${DSC}$$##g' > base.txt

steps:
	cat base.txt | xargs -L 1 sh -x -u -c '${MAKE} step JAIL_ROOT=$$0'

#

generate:
	make -C g/cvs generate
	make -C g/svn-releng generate
	make -C g/svn-release generate
