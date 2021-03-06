# Copyright 2012 itakingiteasy
# Distributed under the terms of the WTFPLv2
# $Header: $

EAPI=4

inherit eutils libtool mingw32

DESCRIPTION="XML parsing libraries"
HOMEPAGE="http://expat.sourceforge.net/"

SRC_URI="
	mirror://sourceforge/expat/${M32_P}.tar.gz
"

LICENSE="MIT"

SLOT="0"

KEYWORDS="x86 amd64"

IUSE="+static-libs"

RDEPEND="
"
DEPEND="
"

src_prepare() {
	epatch "${FILESDIR}/${M32_PN}-orig-2.0.1-check_stopped_parser.patch"
	epatch "${FILESDIR}/${M32_PN}-orig-2.0.1-fix_bug_1990430.patch"
	epatch "${FILESDIR}/${M32_PN}-orig-2.0.1-CVE-2009-3560-revised.patch"

	elibtoolize

	mkdir "${S}"-build{,u,w} || die
}

src_configure() {
	local d 
	for d in build buildu buildw; do
		pushd "${S}"-${d}
		[[ ${d} == buildu ]] && export GENTOO_CPPFLAGS="-UXML_UNICODE"
		[[ ${d} == buildw ]] && export GENTOO_CPPFLAGS="-UXML_UNICODE -DXML_UNICODE_WCHAR_T"
		CPPFLAGS="${CPPFLAGS} ${GENTOO_CPPFLAGS}" ECONF_SOURCE="${S}" \
			econf \
				$(use_static) \
			|| die	
		popd
	done
}

src_compile() {
	cd "${S}"-build
	emake
	cd "${S}"-buildu
	emake buildlib LIBRARY=libexpatu.la
	cd "${S}"-buildw
	emake buildlib LIBRARY=libexpatw.la

}

src_install() {
	cd "${S}"-build
	emake DESTDIR="${D}" install
	cd "${S}"-buildu
	emake installlib DESTDIR="${D}" LIBRARY=libexpatu.la
	cd "${S}"-buildw
	emake installlib DESTDIR="${D}" LIBRARY=libexpatw.la
	
	if ! use static-libs; then
		rm -f "${D}"usr/lib*/libexpat{,u,w}.la
	fi

	clean_files	
}
