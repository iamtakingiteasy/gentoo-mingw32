# Copyright 2012 itakingiteasy
# Distributed under the terms of the WTFPLv2
# $Header: $

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

IUSE="+static-libs"

RDEPEND="
	sys-libs/mingw32-zlib
"
DEPEND="
	${RDEPEND}
"

src_prepare() {
	sed '/Libs:/{s/$/ -lz/}' -i libpng.pc.in || die
	elibtoolize
}


src_configure() {
	econf \
		$(use_static) \
	|| die
}

src_install() {
	emake DESTDIR="${D}" install || die
	clean_files
}
