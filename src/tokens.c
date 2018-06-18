#include "parser.h"

static int buf_size ;

/**
 * buffer
 */
static char* buf ;

/**
 * Current line
 */
static int line ;

/**
 * Current byte offset within the file
 */
static int byte ;

#define PUSH(c, bp) do { \
	*(bp)++ = (c); \
} while(0) ;

/*	if ((bp) - buf >= sizeof(buf) ){ \
 *		old_bufsize=buf_size ; \
 *		buf_size*=2 ; \
 *		buf = (char*) realloc( buf, buf_size ) ; \
 *		bp = buf + old_bufsize ; \
 *	} \
 */

/**
 * gets a character from the file and keep track of the current line
 * and current byte offset within this line
 *
 * @param fp file stream to read from
 */
static int _getc( FILE* fp){
	int c = _fgetc(fp) ;
	if( c == '\n' ) {
		line++ ;
		byte=0;
	} else{
		byte++;
	}
	return c ;
}
