#include <Rinternals.h>
#include "parser.h"

Rboolean known_to_be_utf8 = FALSE ;
Rboolean known_to_be_latin1 = FALSE ;

Rboolean get_latin1(){ return known_to_be_latin1 ; }
void set_latin1( Rboolean value ) { known_to_be_latin1 = value ; }

Rboolean get_utf8(){ return known_to_be_utf8 ; }
void set_utf8(Rboolean value) { known_to_be_utf8 = value ; }

/**
 * same as _fgetc but without the \r business
 */
#ifdef Win32
inline int __fgetc(FILE* fp){
    int c;
    static int nexteof=0;
    if (nexteof) {
       nexteof = 0;
       return R_EOF;
    }
    c = fgetc(fp);
    if (c==EOF) {
       nexteof = 1;
       return '\n';
    }
    return c ;
}
#endif
