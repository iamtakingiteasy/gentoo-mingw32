# Copyright 2012 itakingiteasy
# Distributed under the terms of the WTFPLv2
# $Header:

EAPI=4

inherit eutils libtool mingw32

DESCRIPTION="Portable Network Graphics library"
HOMEPAGE="http://www.libpng.org/"
SRC_URI="
	mirror://sourceforge/${M32_PN}/${M32_P}.tar.xz
"

LICENSE="as-is"
SLOT="0"

KEYWORDS="x86 amd64"
IUSE=""

RDEPEND="
	sys-libs/mingw32-zlib
"
DEPEND="
	${RDEPEND}
	app-arch/mingw32-xz-utils
"


src_prepare() {
	sed '/Libs:/{s/$/ -lz/}' -i libpng.pc.in
	elibtoolize
}

src_configure() {
	append-flags -fno-strict-aliasing
	econf \
		--disable-shared \
	|| die "econf failed"
}

src_install() {
	default
	clean_files
}

