# Copyright 2012 itakingiteasy
# Distributed under the terms of the WTFPLv2
# $Header: $

EAPI=4

inherit eutils toolchain-funcs mingw32

DESCRIPTION="A high-quality data compressor used extensively by Gentoo Linux"
HOMEPAGE="http://www.bzip.org/"

SRC_URI="
	http://www.bzip.org/${M32_PV}/${M32_P}.tar.gz
"

LICENSE="BZIP2"

SLOT="0"

KEYWORDS="x86 amd64"

IUSE="+static-libs"

RDEPEND="
"
DEPEND="
"

src_prepare() {
	epatch "${FILESDIR}/${M32_PN}-orig-1.0.6-makefile-CFLAGS.patch"
	epatch "${FILESDIR}/${M32_PN}-orig-1.0.6-saneso.patch"
	epatch "${FILESDIR}/${M32_PN}-orig-1.0.6-man-links.patch" #172986
	epatch "${FILESDIR}/${M32_PN}-orig-1.0.6-no-test.patch"
	epatch "${FILESDIR}/${M32_PN}-orig-1.0.6-POSIX-shell.patch" #193365
	sed -i \
		-e 's:\$(PREFIX)/man:\$(PREFIX)/share/man:g' \
		-e 's:ln -s -f $(PREFIX)/bin/:ln -s :' \
		-e 's:$(PREFIX)/lib:$(PREFIX)/$(LIBDIR):g' \
	Makefile || die
	sed  '/sys\\stat/{s|\\|/|}' -i bzip2.c || die
}


bemake() {
	emake \
		CC="$(tc-getCC)" \
		AR="$(tc-getAR)" \
		RANLIB="$(tc-getRANLIB)" \
	"$@" || die
}


src_compile() {
	bemake -f Makefile-libbz2_so all || die
	append-flags -static
	bemake all || die

}

src_install() {
	emake PREFIX="${D}" DESTDIR="${D}" install || die "install failed"
	cd "${D}"
	mkdir lib
	mv libbz2.a lib
	mkdir usr
	mv bin share include lib usr/

	clean_files
}
