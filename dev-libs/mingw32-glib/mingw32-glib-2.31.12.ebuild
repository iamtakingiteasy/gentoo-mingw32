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

KEYWORDS=""

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
	if ! test -x /usr/bin/glib-compile-resources; then
		eerror "You MUST have glib-compile-resources from glib-2.31.12+ package
		on your host system; where you are cross-compiling from."
	fi

	sed 's/^\(.*\SUBDIRS .*\=.*\)tests\(.*\)$/\1\2/' -i $(find . -name Makefile.am -o -name Makefile.in) || die
	sed -i -e "/appinfo\/associations/d" gio/tests/appinfo.c || die
	sed -i -e "/desktop-app-info\/default/d" gio/tests/desktop-app-info.c || die
	sed -i -e "/desktop-app-info\/fallback/d" gio/tests/desktop-app-info.c || die
	sed -i -e "/desktop-app-info\/lastused/d" gio/tests/desktop-app-info.c || die
	sed -i -e "/connection\/filter/d" gio/tests/gdbus-connection.c || die
	sed -i -e "/connection\/large_message/d" gio/tests/gdbus-connection-slow.c || die
	sed -i -e "/gdbus\/proxy/d" gio/tests/gdbus-proxy.c || die
	sed -i -e "/gdbus\/proxy-well-known-name/d" gio/tests/gdbus-proxy-well-known-name.c || die
	sed -i -e "/gdbus\/introspection-parser/d" gio/tests/gdbus-introspection.c || die
	sed -i -e "/g_test_add_func/d" gio/tests/gdbus-threading.c || die
	sed -i -e "/gdbus\/method-calls-in-thread/d" gio/tests/gdbus-threading.c || die
	ln -sfn $(type -P true) gio/tests/gdbus-testserver.py

	epatch "${FILESDIR}/${M32_PN}-orig-2.30.1-external-gdbus-codegen.patch"
	ln -sfn $(type -P true) py-compile
	AT_M4DIR="${WORKDIR}" eautoreconf
	epunt_cxx
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
