PORTNAME=	gmp
PORTVERSION=	6.2.1
CATEGORIES=	math devel
MASTER_SITES=	GNU

MAINTAINER=	ale@FreeBSD.org
COMMENT=	Free library for arbitrary precision arithmetic
WWW=		https://gmplib.org/

LICENSE=	LGPL3

USES=		cpe libtool tar:xz

CPE_VENDOR=	gmplib

OPTIONS_DEFINE=		CPU_OPTS INFO
OPTIONS_DEFAULT=	INFO

CPU_OPTS_DESC=	Enable assembly optimizations for your CPU

HAS_CONFIGURE=	yes
CONFIGURE_ENV=	MAKEINFO="${MAKEINFO} --no-split"
CONFIGURE_ARGS=	--prefix=${PREFIX} \
		--infodir=${PREFIX}/${INFO_PATH} \
		--mandir=${MANPREFIX}/man \
		--enable-cxx

USE_LDCONFIG=	yes

INFO_INFO=		gmp
INFO_USES=		makeinfo

INSTALL_TARGET=	install-strip
TEST_TARGET=	check

.include <bsd.port.pre.mk>

.if ${ARCH:Mmips*}
MAKE_JOBS_UNSAFE=yes
.endif

.if ! ${PORT_OPTIONS:MCPU_OPTS}
CONFIGURE_ARGS+=--build=${CONFIGURE_TARGET}
.elif ${ARCH:S/64//} != ${ARCH}
.if ${ARCH:Mpowerpc64*}
CONFIGURE_ENV+=	ABI="mode64"
.elif ${ARCH:Mriscv64*}
CONFIGURE_ENV+=	ABI="standard"
.else
CONFIGURE_ENV+=	ABI="64"
.endif
.else
CONFIGURE_ENV+=	ABI="32"
.endif

post-extract-INFO-on:
	@${RM} ${WRKSRC}/doc/gmp.info*

post-install-INFO-off:
	@${RM} ${STAGEDIR}${PREFIX}/${INFO_PATH}/*.info*

.include <bsd.port.post.mk>
