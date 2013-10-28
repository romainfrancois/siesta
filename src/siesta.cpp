#include <Rcpp.h>
using namespace Rcpp ;

// [[Rcpp::export]]
SEXP generate_formals(CharacterVector vars){
    Armor<SEXP> args(R_NilValue) ; 
    int n=vars.size() ;
    for( int i=n-1; i>=0; i--){
        const char* var = vars[i] ;
        args = Rf_cons( R_MissingArg, (SEXP)args ) ;
        SET_TAG( args, Rf_install(var) ) ;
    }
    return args;
}

