# Copyright 2012 itakingiteasy
# Distributed under the terms of the WTFPLv2
# $Header:

EAPI=4

inherit eutils flag-o-matic libtool autotools mingw32


DESCRIPTION="Gimp ToolKit +"
HOMEPAGE="http://www.gtk.org/"

SRC_URI="
	mirror://gnome/sources/gtk+/${PV%.*}/${M32_P}.tar.xz
	mirror://gentoo/introspection.m4.bz2
"

LICENSE="LGPL-2"
SLOT="3"

KEYWORDS="x86 amd64"
IUSE=""

RDEPEND="
	media-libs/mingw32-jpeg
	media-libs/mingw32-tiff
	x11-libs/mingw32-cairo
	x11-libs/mingw32-pango
	x11-libs/mingw32-gdk-pixbuf
	dev-libs/mingw32-atk
	dev-libs/mingw32-glib
"
DEPEND="
	${RDEPEND}
"

strip_builddir() {
	local rule=$1
	shift
	local directory=$1
	shift
	sed -e "s/^\(${rule} =.*\)${directory}\(.*\)$/\1\2/" -i $@ \
	|| die "Could not strip director ${directory} from build."
}


src_prepare() {
	sed 's:\(g_test_add_func ("/ui-tests/keys-events.*\):/*\1*/:g' \
		-i gtk/tests/testing.c || die "sed 1 failed"
	sed '\%/recent-manager/add%,/recent_manager_purge/ d' \
		-i gtk/tests/recentmanager.c || die "sed 2 failed"
	sed -e 's:\(SUBDIRS.*\)reftests:\1:' \
		-i tests/Makefile.* || die "sed 3 failed"
	
	cp "${FILESDIR}/${M32_PN}-3.2.1-selector.errors" \
		tests/css/parser/selector.errors || die "cp failed"
	
	rm -v tests/a11y/pickers.{ui,txt} || die "rm failed"

	epatch "${FILESDIR}/${M32_PN}-3.2.1-failing-tests.patch"
	epatch "${FILESDIR}/${M32_PN}-3.2.3-mingw.patch"
	epatch "${FILESDIR}/${M32_PN}-3.2.3-pkgconfig.patch"


	strip_builddir SRC_SUBDIRS tests Makefile.am Makefile.in
	strip_builddir SRC_SUBDIRS demos Makefile.am Makefile.in

	replace-flags -O3 -O2

	strip-flags

	mkdir -p "${S}/m4" || die
	mv "${WORKDIR}/introspection.m4" "${S}/m4macros" || die
	AT_M4DIR=m4macros eautoreconf
}

src_configure() {

	econf \
		--enable-win32-backend \
		--disable-gdiplus \
		--with-included-immodules \
		--without-libjasper \
		--enable-debug=yes \
		--enable-explicit-deps=no \
		--disable-gtk-doc \
		--disable-shared \
		--disable-cups \
	|| die "econf failed"
}

src_install() {
	mkdir -p "${D}"usr/lib
	emake DESTDIR="${D}" install || die "emake install failed"
	rm -rf "${D}usr/share/gtk-doc"
	mingw32_clean_files
}


