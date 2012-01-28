# Copyright 2012 itakingiteasy
# Distributed under the terms of the WTFPLv2
# $Header: $

EAPI=4

inherit autotools eutils libtool mingw32

DESCRIPTION="The GLib library of C routines"
HOMEPAGE="http://www.gtk.org/"

SRC_URI="
	mirror://gnome/sources/${M32_PN}/${PV%.*}/${M32_P}.tar.xz
	http://pkgconfig.freedesktop.org/releases/pkg-config-0.26.tar.gz
"

LICENSE="LGPL-2"

SLOT="2"

KEYWORDS="~x86 ~amd64"

IUSE="+static-libs"

RDEPEND="
	dev-libs/mingw32-libiconv
	dev-libs/mingw32-libffi
	sys-libs/mingw32-zlib
	sys-devel/mingw32-gettext
"
DEPEND="
	${RDEPEND}
"

src_prepare() {
	mv -vf "${WORKDIR}"/pkg-config-*/pkg.m4 "${WORKDIR}"/ || die
	epatch "${FILESDIR}/${M32_PN}-orig-2.30.1-assert-test-failure.patch"
	sed 's:^\(.*"/desktop-app-info/delete".*\):/*\1*/:' \
		-i "${S}"/gio/tests/desktop-app-info.c || die "sed failed"
	sed 's/^\(.*\SUBDIRS .*\=.*\)tests\(.*\)$/\1\2/' -i $(find . -name Makefile.am -o -name Makefile.in) || die
	epatch "${FILESDIR}/${M32_PN}-orig-2.30.1-external-gdbus-codegen.patch"
	epatch "${FILESDIR}/${M32_PN}-orig-2.30.1-homedir-env.patch"
	
	sed '/^Libs:/s/$/ -ldnsapi -lshlwapi/' -i gio-2.0.pc.in || die
	sed '/^Libs:/s/$/ -lws2_32 -lole32 -lwinmm/' -i glib-2.0.pc.in || die
	sed '/^Libs:/s/$/ -lffi/' -i gobject-2.0.pc.in || die


	sed -i -e '/g_file_get_contents/s:/var/lib/dbus/machine-id:/etc/machine-id:' gio/gdbusprivate.c || die
	echo '#!/bin/sh' > py-compile

	AT_M4DIR="${WORKDIR}" eautoreconf
}

src_configure() {
	econf \
		$(use_static) \
		--enable-regex \
		--with-threads=win32 \
		--with-pcre=internal \
	|| die	
}


src_install() {
	emake DESTDIR="${D}" install
	rm "${ED}usr/bin/gtester-report"
	rm -f "${ED}/usr/lib/charset.alias"
	rm -rf "${ED}/usr/share/gdb/" "${ED}/usr/share/glib-2.0/gdb/"

	clean_files	
}
