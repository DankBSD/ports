# Provide support to use the GNU make
#
# Feature:		gmake
# Usage:		USES=gmake
#
# MAINTAINER: tijl@FreeBSD.org

.if !defined(_INCLUDE_USES_GMAKE_MK)
_INCLUDE_USES_GMAKE_MK=	yes

.  if !empty(gmake_ARGS)
IGNORE=	Incorrect 'USES+= gmake:${gmake_ARGS}' gmake takes no arguments
.  endif

BUILD_DEPENDS+=		gmake>=4.3:devel/gmake
CONFIGURE_ENV+=		MAKE=gmake
MAKE_CMD=		gmake

# Limit starting jobs by load average
MAKE_ARGS+=	-l${MAKE_JOBS_NUMBER}

.endif
