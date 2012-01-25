# Copyright 2012 itakingiteasy
# Distributed under the terms of the WTFPLv2
# $Header:

EAPI=4

inherit mingw32
GNOME_ORG_MODULE=${M32_PN}
inherit eutils flag-o-matic gnome.org libtool virtualx autotools


DESCRIPTION="Gimp ToolKit +"
HOMEPAGE="http://www.gtk.org/"

SRC_URI="
	${SRC_URI}
	mirror://gentoo/introspection.m4.bz2
"

LICENSE="LGPL-2"
SLOT="2"

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
	epatch "${FILESDIR}/${M32_PN}-2.14.3-limit-gtksignal-includes.patch"
	epatch "${FILESDIR}/${M32_PN}-2.24.4-old-icons.patch"
	epatch "${FILESDIR}/${M32_PN}-2.24.8-iconview-layout.patch"
	epatch "${FILESDIR}/${M32_PN}-2.24.8-mingw.patch"
	epatch "${FILESDIR}/${M32_PN}-2.24.8-pkgconfig.patch"

	strip_builddir SUBDIRS tutorial docs/Makefile.am docs/Makefile.in
	strip_builddir SUBDIRS faq docs/Makefile.am docs/Makefile.in
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


