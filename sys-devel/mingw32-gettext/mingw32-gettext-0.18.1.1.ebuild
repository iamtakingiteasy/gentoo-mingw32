# Copyright 2012 itakingiteasy
# Distributed under the terms of the WTFPLv2
# $Header: $

EAPI=4

inherit eutils libtool toolchain-funcs mingw32

DESCRIPTION="GNU locale utilities"
HOMEPAGE="http://www.gnu.org/software/gettext/"

SRC_URI="
	mirror://gnu/${M32_PN}/${M32_P}.tar.gz
"

LICENSE="GPL-3 GPL-2"

SLOT="0"

KEYWORDS="x86 amd64"

IUSE="+static-libs +cxx +nls"

RDEPEND="
	dev-libs/mingw32-libiconv
	dev-libs/mingw32-libxml2
	dev-libs/mingw32-expat
"
DEPEND="
	${RDEPEND}
"

src_prepare() {
	epatch "${FILESDIR}/${M32_PN}-mingw32-0.18.1.1-rpl_memchr.patch"
	export CXX=$(tc-getCXX)
}

src_configure() {
	econf \
		$(use_static) \
		$(use_with git) \
		--enable-threads=win32 \
		--without-libexpat-prefix \
		--without-libxml2-prefix \
		--without-emacs \
		--without-lispdir \
		--with-included-glib \
		--with-included-libcroco \
		--with-included-libunistring \
		--without-cvs \
	|| die
}

src_compile() {
	emake CXX=$(tc-getCXX)
}

src_install() {
	emake DESTDIR="${D}" install || die
	if ! use nls; then
		rm -r "${D}"/usr/share/locale
	fi
	dosym msgfmt /usr/bin/gmsgfmt
	dobin gettext-tools/misc/gettextize
	rm -f "${D}"/usr/share/locale/locale.alias "${D}"/usr/lib/charset.alias
	clean_files	
}
