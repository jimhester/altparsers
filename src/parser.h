#ifndef PARSER_H
#define PARSER_H

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <Rinternals.h>
#include <R_ext/Boolean.h>
#include <wchar.h>
#include "IOStuff.h"

extern Rboolean utf8locale, mbcslocale;

int nlines( const char* ) ;

// #ifdef SUPPORT_MBCS
// # ifdef Win32
// #  define USE_UTF8_IF_POSSIBLE
// # endif
// #endif


# define attribute_visible
# define attribute_hidden

/* Used as a default for string buffer sizes,
			   and occasionally as a limit. */
#define MAXELTSIZE 8192

//static SEXP	NewList(void);
//static SEXP	GrowList(SEXP, SEXP);
//static SEXP	Insert(SEXP, SEXP);

/* File Handling */
#define R_EOF   -1

#ifdef __cplusplus
extern "C" {
#endif

typedef enum {
    PARSE_NULL,
    PARSE_OK,
    PARSE_INCOMPLETE,
    PARSE_ERROR,
    PARSE_EOF
} ParseStatus;

#ifdef __cplusplus
}
#endif

# define yychar			Rf_yychar
# define yylval			Rf_yylval
# define yynerrs		Rf_yynerrs

#ifdef ENABLE_NLS
#include <libintl.h>
#ifdef Win32
#define _(String) libintl_gettext (String)
#undef gettext /* needed for graphapp */
#else
#define _(String) gettext (String)
#endif
#define gettext_noop(String) String
#define N_(String) gettext_noop (String)
#define P_(StringS, StringP, N) ngettext (StringS, StringP, N)
#else /* not NLS */
#define _(String) (String)
#define N_(String) String
#define P_(String, StringP, N) (N > 1 ? StringP: String)
#endif

/* Miscellaneous Definitions */
#define streql(s, t)	(!strcmp((s), (t)))

#define PUSHBACK_BUFSIZE 16
#define CONTEXTSTACK_SIZE 50

FILE *	_fopen(const char *filename, const char *mode);
int	_fgetc(FILE*);


/* definitions for R 2.16.0 */

int utf8clen(char c);
# define Mbrtowc        Rf_mbrtowc
# define ucstomb        Rf_ucstomb
extern Rboolean utf8locale, mbcslocale;
size_t ucstomb(char *s, const unsigned int wc);
extern size_t Mbrtowc(wchar_t *wc, const char *s, size_t n, mbstate_t *ps);
#define mbs_init(x) memset(x, 0, sizeof(mbstate_t))


#include <R_ext/libextern.h>

#ifdef __MAIN__
# define INI_as(v) = v
#define extern0 attribute_hidden
#else
# define INI_as(v)
#define extern0 extern
#endif

LibExtern SEXP  R_SrcfileSymbol;    /* "srcfile" */
LibExtern SEXP  R_SrcrefSymbol;     /* "srcref" */
extern0 SEXP	R_WholeSrcrefSymbol;   /* "wholeSrcref" */

/* Objects Used In Parsing  */
LibExtern int	R_ParseError	INI_as(0); /* Line where parse error occurred */
extern0 int	R_ParseErrorCol;    /* Column of start of token where parse error occurred */
extern0 SEXP	R_ParseErrorFile;   /* Source file where parse error was seen.  Either a
				       STRSXP or (when keeping srcrefs) a SrcFile ENVSXP */
#define PARSE_ERROR_SIZE 256	    /* Parse error messages saved here */
LibExtern char	R_ParseErrorMsg[PARSE_ERROR_SIZE] INI_as("");
#define PARSE_CONTEXT_SIZE 256	    /* Recent parse context kept in a circular buffer */
LibExtern char	R_ParseContext[PARSE_CONTEXT_SIZE] INI_as("");
LibExtern int	R_ParseContextLast INI_as(0); /* last character in context buffer */
LibExtern int	R_ParseContextLine; /* Line in file of the above */

/* Evaluation Environment */
extern0 SEXP	R_CurrentExpr;	    /* Currently evaluating expression */

/* used in package utils */
extern Rboolean known_to_be_latin1 INI_as(FALSE);
extern0 Rboolean known_to_be_utf8 INI_as(FALSE);

#define R_EOF	-1

/* parse.h */
typedef struct SrcRefState SrcRefState;

struct SrcRefState {

    Rboolean keepSrcRefs;	/* Whether to attach srcrefs to objects as they are parsed */
    Rboolean didAttach;		/* Record of whether a srcref was attached */
    SEXP SrcFile;		/* The srcfile object currently being parsed */
    SEXP Original;		/* The underlying srcfile object */
    PROTECT_INDEX SrcFileProt;	/* The SrcFile may change */
    PROTECT_INDEX OriginalProt; /* ditto */
    SEXP data;			/* Detailed info on parse */
    SEXP text;
    SEXP ids;
    int data_count;
    				/* Position information about the current parse */
    int xxlineno;		/* Line number according to #line directives */
    int xxcolno;		/* Character number on line */
    int xxbyteno;		/* Byte number on line */
    int xxparseno;              /* Line number ignoring #line directives */

    SrcRefState* prevState;
};

void InitParser(void);

void R_InitSrcRefState(void);
void R_FinalizeSrcRefState(void);

SEXP R_Parse1Buffer(IoBuffer*, int, ParseStatus *); /* in ReplIteration,
						       R_ReplDLLdo1 */
SEXP R_ParseBuffer(IoBuffer*, int, ParseStatus *, SEXP, SEXP); /* in source.c */
SEXP R_Parse1File(FILE*, int, ParseStatus *); /* in R_ReplFile */
SEXP R_ParseFile(FILE*, int, ParseStatus *, SEXP);  /* in edit.c */

#ifndef HAVE_RCONNECTION_TYPEDEF
typedef struct Rconn  *Rconnection;
#define HAVE_RCONNECTION_TYPEDEF
#endif
SEXP R_ParseConn(Rconnection con, int n, ParseStatus *status, SEXP srcfile);

	/* Report a parse error */

void NORET parseError(SEXP call, int linenum);

/* The Pointer Protection Stack */
LibExtern int	R_PPStackSize	INI_as(R_PPSSIZE); /* The stack size (elements) */
LibExtern int	R_PPStackTop;	    /* The top of the stack */
LibExtern SEXP*	R_PPStack;	    /* The pointer protection stack */


/* The maximum length of input line which will be asked for,
   in bytes, including the terminator */
#define CONSOLE_BUFFER_SIZE 4096

# define installTrChar		Rf_installTrChar
# define EncodeChar             Rf_EncodeChar
# define NewEnvironment		Rf_NewEnvironment
# define wcstoutf8		Rf_wcstoutf8
SEXP Rf_installTrChar(SEXP);
#define checkArity(a,b) Rf_checkArityCall(a,b,call)
void Rf_checkArityCall(SEXP, SEXP, SEXP);

const char *EncodeChar(SEXP);

int ENC_KNOWN(SEXP x);
int IS_ASCII(SEXP x);

/* CHARSXP charset bits */
#define BYTES_MASK (1<<1)
#define LATIN1_MASK (1<<2)
#define UTF8_MASK (1<<3)
/* (1<<4) is taken by S4_OBJECT_MASK */
#define CACHED_MASK (1<<5)
#define ASCII_MASK (1<<6)

void NORET UNIMPLEMENTED_TYPE(const char *s, SEXP x);
size_t wcstoutf8(char *s, const wchar_t *wc, size_t n);
SEXP NewEnvironment(SEXP, SEXP, SEXP);

#endif
