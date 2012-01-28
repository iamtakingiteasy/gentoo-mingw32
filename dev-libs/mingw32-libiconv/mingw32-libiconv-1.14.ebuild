# Copyright 2012 itakingiteasy
# Distributed under the terms of the WTFPLv2
# $Header: $

EAPI=4

inherit eutils libtool mingw32

DESCRIPTION="GNU charset conversion library for libc which doesn't implement it"
HOMEPAGE="http://www.gnu.org/software/libiconv/"

SRC_URI="
	mirror://gnu/libiconv/${M32_P}.tar.gz
"

LICENSE="GPL-3"

SLOT="0"

KEYWORDS="x86 amd64"

IUSE="+static-libs"

RDEPEND="
"
DEPEND="
"

src_prepare() {
	elibtoolize
}

src_configure() {
	econf \
		--disable-nls \
		$(use_static) \
	|| die
}

src_install() {
	emake DESTDIR="${D}" install || die
	clean_files	
}
