# Copyright 2012 itakingiteasy
# Distributed under the terms of the WTFPLv2
# $Header:

EAPI=4

inherit autotools libtool eutils flag-o-matic mingw32

SRC_URI="
	mirror://gnome/sources/glib/${PV%.*}/${M32_P}.tar.xz
	http://pkgconfig.freedesktop.org/releases/pkg-config-0.26.tar.gz
"

DESCRIPTION="The GLib library of C routines"
HOMEPAGE="http://www.gtk.org/"

LICENSE="LGPL-2"
SLOT="2"

KEYWORDS="x86 amd64"
IUSE=""

RDEPEND="
	dev-libs/mingw32-libiconv
	dev-libs/mingw32-libffi
	sys-libs/mingw32-zlib
	sys-devel/mingw32-gettext

"
DEPEND=""


src_prepare() {
	mv -vf "${WORKDIR}"/pkg-config-*/pkg.m4 "${WORKDIR}"/ || die

#	epatch "${FILESDIR}/${M32_PN}-2.12.12-fbsd.patch"
#	epatch "${FILESDIR}/${M32_PN}-2.24-assert-test-failure.patch"
#	epatch "${FILESDIR}/${M32_PN}-2.30.1-external-gdbus-codegen.patch"
#	epatch "${FILESDIR}/${M32_PN}-2.30.1-homedir-env.patch"
#	epatch "${FILESDIR}/${M32_PN}-2.30.2-machine-id.patch"
##	epatch "${FILESDIR}/${M32_PN}-2.30.2-pkgconfig.patch"

	sed 's:^\(.*"/desktop-app-info/delete".*\):/*\1*/:' \
		-i "${S}"/gio/tests/desktop-app-info.c || die "sed failed"

	sed 's/^\(.*\SUBDIRS .*\=.*\)tests\(.*\)$/\1\2/' \
		-i $(find . -name Makefile.am -o -name Makefile.in) || die
	
	echo '#!/bin/sh' > py-compile

	elibtoolize
}

src_configure() {
	echo -n "" > win32.cache
	echo "glib_cv_long_long_format=I64" >> win32.cache
	echo "glib_cv_stack_grows=no"       >> win32.cache

	econf \
		--disable-shared \
		--with-threads=win32 \
		--with-pcre=internal \
		--cache-file=win32.cache \
		CROSS_COMPILING=1 \
	|| die "econf failed"

}


src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	rm -f "${ED}usr/bin/gtester-report"
	rm -f "${ED}/usr/lib/charset.alias"
	rm -rf "${ED}/usr/share/gdb/" "${ED}/usr/share/glib-2.0/gdb/"
	rm -rf "${ED}/etc"
	rm -rf "${D}usr/share/gtk-doc"
	clean_files
}

