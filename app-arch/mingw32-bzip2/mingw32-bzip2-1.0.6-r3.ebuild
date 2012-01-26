# Copyright 2012 itakingiteasy
# Distributed under the terms of the WTFPLv2
# $Header:

EAPI=4



inherit eutils toolchain-funcs flag-o-matic mingw32

DESCRIPTION="A high-quality data compressor used extensively by Gentoo Linux"
HOMEPAGE="http://www.bzip.org/"
SRC_URI="http://www.bzip.org/${M32_PV}/${M32_P}.tar.gz"

LICENSE="BZIP2"
SLOT="0"

KEYWORDS="x86 amd64"
IUSE=""

RDEPEND=""
DEPEND="
	${RDEPEND}
"

src_prepare() {
	epatch "${FILESDIR}/${M32_PN}-1.0.4-makefile-CFLAGS.patch"
	epatch "${FILESDIR}/${M32_PN}-1.0.6-saneso.patch"
	epatch "${FILESDIR}/${M32_PN}-1.0.4-man-links.patch"
#	epatch "${FILESDIR}/${M32_PN}-1.0.6-progress.patch"
	epatch "${FILESDIR}/${M32_PN}-1.0.3-no-test.patch"
	epatch "${FILESDIR}/${M32_PN}-1.0.4-POSIX-shell.patch"
	epatch "${FILESDIR}/${M32_PN}-1.0.6-sysstat.patch"

	sed \
		-e 's:\$(PREFIX)/man:\$(PREFIX)/share/man:g' \
		-e 's:ln -s -f $(PREFIX)/bin/:ln -s :' \
		-e 's:$(PREFIX)/lib:$(PREFIX)/$(LIBDIR):g' \
		-i \
			Makefile \
	|| die

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

