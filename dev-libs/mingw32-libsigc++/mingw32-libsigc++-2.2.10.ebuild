# Copyright 2012 itakingiteasy
# Distributed under the terms of the WTFPLv2
# $Header:

EAPI=4

inherit base eutils flag-o-matic mingw32

DESCRIPTION="Typesafe callback system for standard C++"
HOMEPAGE="http://libsigc.sourceforge.net"
SRC_URI="mirror://gnome/sources/${M32_PN}/${PV%.*}/${M32_P}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="2"

KEYWORDS="x86 amd64"
IUSE=""

RDEPEND="
"
DEPEND="
"


src_prepare() {
	sed -i 's|^\(SUBDIRS =.*\)examples\(.*\)$|\1\2|' \
		Makefile.am Makefile.in || die "sed examples failed"
	sed -i 's|^\(SUBDIRS =.*\)tests\(.*\)$|\1\2|' \
		Makefile.am Makefile.in || die "sed tests failed"
}

src_configure() {
	filter-flags -fno-exceptions

	econf \
		--disable-shared \
	|| die "econf failed"
}


src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	clean_files
}

