# Copyright 2012 itakingiteasy
# Distributed under the terms of the WTFPLv2
# $Header:

EAPI=4

inherit autotools autotools-utils eutils flag-o-matic mingw32

DESCRIPTION="A high-quality and portable font engine"
HOMEPAGE="http://www.freetype.org/"
SRC_URI="
	mirror://sourceforge/freetype/${M32_P/_/}.tar.bz2
"

LICENSE="FTL GPL-2"
SLOT="2"

KEYWORDS="x86 amd64"
IUSE=""

RDEPEND="
	sys-libs/mingw32-zlib
"
DEPEND="
	${RDEPEND}
"


src_prepare() {
	sed -i -e "/#define FT_CONFIG_OPTION_OLD_INTERNALS/ { s:^:/*:; s:$:*/: }" \
		include/freetype/config/ftoption.h \
	die "unable to disable option FT_CONFIG_OPTION_OLD_INTERNALS"

	sed '/^Libs:/{s/$/ -lz/}' -i builds/unix/freetype2.in

	elibtoolize
	epunt_cxx
}

src_configure() {
	append-flags -fno-strict-aliasing
	econf \
		--disable-shared \
		--disable-bzip2 \
	|| die "econf failed"
}

src_install() {
	default
	clean_files
}

