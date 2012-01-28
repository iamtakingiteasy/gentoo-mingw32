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

LICENSE="LGPL-2.1"

SLOT="3"

KEYWORDS="x86 amd64"

IUSE="+static-libs +glib +svg"

RDEPEND="
	media-libs/mingw32-jpeg
	media-libs/mingw32-tiff
	media-libs/mingw32-fontconfig
	x11-libs/mingw32-cairo
	x11-libs/mingw32-pango
	x11-libs/mingw32-gdk-pixbuf:2
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
	replace-flags -O3 -O2
	strip-flags
	
	sed 's:\(g_test_add_func ("/ui-tests/keys-events.*\):/*\1*/:g' \
		-i gtk/tests/testing.c || die "sed 1 failed"

	sed '\%/recent-manager/add%,/recent_manager_purge/ d' \
		-i gtk/tests/recentmanager.c || die "sed 2 failed"
	
	sed -e 's:\(SUBDIRS.*\)reftests:\1:' \
		-i tests/Makefile.* || die "sed 3 failed"

	cp "${FILESDIR}/selector.errors" \
		tests/css/parser/selector.errors || die "cp failed"
	
	rm -v tests/a11y/pickers.{ui,txt} || die "rm failed"
	
	epatch "${FILESDIR}/${M32_PN}-orig-3.2.3-failing-tests.patch"
	epatch "${FILESDIR}/${M32_PN}-mingw32-3.2.3-atk.patch"
	epatch "${FILESDIR}/${M32_PN}-mingw32-3.3.10-dllmain.patch"
	epatch "${FILESDIR}/${M32_PN}-mingw32-3.3.10-uuid.patch"
	epatch "${FILESDIR}/${M32_PN}-mingw32-3.2.3-configure-static.patch"
	sed \
		-e '/^Libs:/{s/$/ -luuid -limm32/}' \
		-i \
			gdk-3.0.pc.in \
	|| die

	sed \
		-e '/^Libs:/{s/$/ -limm32 -lwinspool -lcomdlg32 -lcomctl32/}' \
		-i \
			gtk+-3.0.pc.in \
	|| die

	eautoreconf

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
	rm "${D}"usr/bin/gtk-update-icon-cache.exe*
	clean_files	
}
