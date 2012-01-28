# Copyright 2012 itakingiteasy
# Distributed under the terms of the WTFPLv2
# $Header: $

EAPI=4

inherit autotools eutils libtool flag-o-matic mingw32

DESCRIPTION="Gimp ToolKit +"
HOMEPAGE="http://www.gtk.org/"

SRC_URI="
	mirror://gnome/sources/${M32_PN}/${PV%.*}/${M32_P}.tar.xz
	mirror://gentoo/introspection.m4.bz2
"

LICENSE="|| ( LGPL-2.1 MPL-1.1 )"

SLOT="2"

KEYWORDS="x86 amd64"

IUSE="+static-libs +glib +svg"

RDEPEND="
	media-libs/mingw32-jpeg
	media-libs/mingw32-tiff
	media-libs/mingw32-fontconfig
	x11-libs/mingw32-cairo
	x11-libs/mingw32-pango
	x11-libs/mingw32-gdk-pixbuf
	dev-libs/mingw32-atk
	dev-libs/mingw32-glib:2
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
	epatch "${FILESDIR}/${M32_PN}-orig-2.24.8-limit-gtksignal-includes.patch"
	epatch "${FILESDIR}/${M32_PN}-orig-2.24.8-old-icons.patch"
	epatch "${FILESDIR}/${M32_PN}-orig-2.24.8-iconview-layout.patch"
	
	epatch "${FILESDIR}/${M32_PN}-mingw32-2.24.8-configure-static.patch"
	epatch "${FILESDIR}/${M32_PN}-mingw32-2.24.8-dllmain.patch"
	epatch "${FILESDIR}/${M32_PN}-mingw32-2.24.8-ldadds.patch"
	epatch "${FILESDIR}/${M32_PN}-mingw32-2.24.8-gdkvar.patch"
	epatch "${FILESDIR}/${M32_PN}-mingw32-2.24.8-perf.patch"

	strip_builddir SUBDIRS tutorial docs/Makefile.am docs/Makefile.in
	strip_builddir SUBDIRS faq docs/Makefile.am docs/Makefile.in
	strip_builddir SRC_SUBDIRS tests Makefile.am Makefile.in
	strip_builddir SRC_SUBDIRS demos Makefile.am Makefile.in
	sed '/^Libs:/{s/$/ -limm32 -lwinspool -lcomdlg32 -lcomctl32/}' -i gtk+-2.0.pc.in || die
	sed '/^Libs:/{s/$/ -luuid -limm32/}' -i gdk-2.0.pc.in || die

	replace-flags -O3 -O2
	strip-flags
	mkdir -p "${S}/m4" || die
	mv "${WORKDIR}/introspection.m4" "${S}/m4macros" || die
	
	AT_M4DIR=m4macros eautoreconf
}

src_configure() {
	econf \
		$(use_static) \
		--enable-win32-backend \
		--enable-explicit-deps=no \
		--with-included-immodules \
		--disable-gdiplus \
		--without-libjasper \
		--disable-gtk-doc \
		--disable-cups \
		--disable-papi \
	|| die
}

src_install() {
	mkdir -p "${D}usr/lib"
	emake DESTDIR="${D}" install || die
	clean_files	
}
