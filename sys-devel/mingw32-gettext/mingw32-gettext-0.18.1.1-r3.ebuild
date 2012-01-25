# Copyright 2012 itakingiteasy
# Distributed under the terms of the WTFPLv2
# $Header:

EAPI=4

inherit autotools eutils flag-o-matic toolchain-funcs libtool prefix mingw32

DESCRIPTION="GNU locale utilities"
HOMEPAGE="http://www.gnu.org/software/gettext/"
SRC_URI="mirror://gnu/${M32_PN}/${M32_P}.tar.gz"

LICENSE="GPL-3 LGPL-2"
SLOT="0"

KEYWORDS="x86 amd64"
IUSE=""

RDEPEND="
	dev-libs/mingw32-libiconv
	dev-libs/mingw32-libxml2
	dev-libs/mingw32-expat
	sys-libs/mingw32-zlib
"
DEPEND="
	${RDEPEND}
"


src_prepare() {
	epatch "${FILESDIR}/${M32_P}-mingw32.patch"
	epunt_cxx
	eautoreconf
}

src_configure() {
	econf \
		--disable-shared \
		--enable-threads=win32 \
		--without-libexpat-prefix \
		--without-libxml2-prefix \
	|| die "econf failed"

}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	dosym msgfmt /usr/bin/gmsgfmt 
	dobin gettext-tools/misc/gettextize || die "gettextize"
	rm -f "${D}"/usr/share/locale/locale.alias "${D}"/usr/lib/charset.alias
	rm -f "${D}"/usr/share/doc/${PF}/*.html
		
	clean_files
}

