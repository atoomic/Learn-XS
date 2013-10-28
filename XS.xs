/*-
 * Copyright (c) 2013 Nicolas R.
 * All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify
 * it under the same terms as Perl itself, either Perl version 5.10.1 or,
 * at your option, any later version of Perl 5 you may have available.
 */

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

//#include "ppport.h"

#include "learn.h"
#include <stdlib.h>
#include <string.h>

/*
typedef void (*sort_function_t)(ElementType A[ ], int N, CmpFunction *cmp);

typedef enum { VOID, INSERTION, SHELL, HEAP, MERGE, QUICK } SortAlgo;
typedef enum { INT, STR } SortType;

sort_function_t sort_function_map[] = {
		VoidSort
		,InsertionSort	
		,ShellSort
		,HeapSort
		,MergeSort
		,QuickSort
};
*/
/* typedef int (CmpFunction)(const ElementType *a, const ElementType *b); */
/*
CmpFunction *cmp_functionmap[] = {
		compare_int,
		compare_str
};
*/

/*
SV* _jump_to_sort(const SortAlgo method, const SortType type, SV* array) {
	AV* av;
	AV* input;
	SV* reply;
	SV* elt;
		
	av = newAV();
	reply = newRV_noinc((SV *) av);
		
	// not defined or not a reference
	if (!array || !SvOK(array) || !SvROK(array) )
		return reply;
	
	input = (AV*) SvRV(array);
	// should reference a hash
	if (SvTYPE (input) != SVt_PVAV)
		croak ("expecting a reference to an array");	
		
	int size = av_len(input);
	ElementType elements[size+1];
	int i;
	for ( i = 0; i <= size; ++i) {
		if ( type == INT ) {
			elements[i].i = SvIV(*av_fetch(input, i, 0));
		} else {
			elements[i].s = SvPV_nolen(*av_fetch(input, i, 0));
		}
		// fprintf(stderr, "number %02d is %d\n", i, elements[i]);	
	}
	
	// map to the c method
	sort_function_map[method]( elements, size + 1, cmp_functionmap[type]);
	
	// convert into perl types
	for ( i = 0; i <= size; ++i) {
		if ( type == INT ) {
			av_push(av, newSViv(elements[i].i));
		} else {
			av_push(av, newSVpv(elements[i].s, 0));
		}
	}	
	
	return reply;
}
*/

SV* _simple_integer(SV* v);
SV* _simple_integer(SV* v) {

	SV *iv = newSViv(0);

	/* is it a valid Iv */
	if (!v || !SvOK(v) || !SvIOK(v) ) return &PL_sv_undef;// return iv;
		
	sv_setiv(iv, SvIV(v));
	
	return iv;
}

SV* _simple_string(SV* v);
SV* _simple_string(SV* v) {

	SV *pv = newSV(0); /* no storage allocated */
	/* is it a valid Pv */
	if (!v || !SvOK(v) || !SvPOK(v) ) return &PL_sv_undef;
		
	sv_setpv(pv, SvPV_nolen(v));
	// sv_setsv(SV*, SV*);
	
	return pv;
}

/* first char */
SV* _first_char(SV* v);
SV* _first_char(SV* v) {

	
	/* is it a valid Pv */
	if (!v || !SvOK(v) || !SvPOK(v) ) return &PL_sv_undef;
	
	STRLEN len;
	char* ptr = SvPV(v, len);	
	if ( len == 0 ) return &PL_sv_undef;
	
	//fprintf(stderr, "string %s -> len %d\n", ptr, len);
	SV *pv = newSVpv(ptr, 1); /* no storage allocated */
	
	return pv;
}

SV* _sv_to_ref_array(SV* v) {

	if (!v || !SvOK(v) ) return &PL_sv_undef;

	AV* av =  newAV();
	av_push(av, v);
	
	return newRV_inc((SV*) av);
}

SV* _array_to_hash(SV *v);
SV* _array_to_hash(SV *v) {
	
	if ( !v || !SvOK(v) || !SvROK(v) || SvTYPE(SvRV(v)) != SVt_PVAV ) return &PL_sv_undef;
	
	/* perl 5.18 */
	// I32 max =  av_top_index((AV*) SvRV(v));
	AV *input = (AV*) SvRV(v);
	int size = av_len(input);
	//fprintf(stderr, "size is %d\n", size);
	if ( size < 0 || size % 2 == 0 ) return &PL_sv_undef;
	
	HV* hv =  newHV();
	
	int i;
	for ( i = 0; i <= size; i += 2) {
		SV **skey  = av_fetch(input, i, 0);
		SV **svalue = av_fetch(input, i + 1, 0);
		if ( skey && SvOK(*skey) && SvPOK(*skey) && svalue && SvOK(*svalue) ) {
			
			STRLEN keylen;
			char *key = SvPV(*skey, keylen);

			//fprintf(stderr, "key / value %d -> %s\n", i, key);
			hv_store(hv, (const char*) key, keylen, *svalue, 0);
		}
	}
	
	return newRV_inc((SV*) hv);
}

SV* _get_dual();
SV* _get_dual() {
    
	SV *sv = newSV(0);

	int code = 42;
	char msg[10];
	sprintf(msg, "universe");
	
	sv_setiv(sv, (IV) code);
    sv_setpv(sv, msg); // all other flags are reset
    SvIOK_on(sv);	// we need to restore the integer flag

    return sv;
}

/*
SV* _set_global;
SV* _set_global {
    
	const int  myerror_code 		 = 42;
    const char *myerror_msg          = "something";
    
    SV* sv = get_sv("myerror", GV_ADD);
    sv_setiv(sv, (IV) myerror_code);
    sv_setpv(sv, myerror_msg);
    SvIOK_on(sv);

    return 0;
}
*/


/* 
 * read perlguts : http://search.cpan.org/~flora/perl-5.14.2/pod/perlguts.pod 
 * 
 * */


MODULE = Learn::XS PACKAGE = Learn::XS

PROTOTYPES: ENABLE

SV* simple_integer(v)
		SV* v
		CODE:
			RETVAL = _simple_integer(v);
		OUTPUT:
			RETVAL

SV* simple_string(v)
		SV* v
		CODE:
			RETVAL = _simple_string(v);
		OUTPUT:
			RETVAL

SV* first_char(v)
		SV* v
		CODE:
			RETVAL = _first_char(v);
		OUTPUT:
			RETVAL
			
SV* to_arrayref(v)
		SV* v
		CODE:
			RETVAL = _sv_to_ref_array(v);
		OUTPUT:
			RETVAL

SV* array_to_hash(v)
		SV* v
		CODE:
			RETVAL = _array_to_hash(v);
		OUTPUT:
			RETVAL

SV* get_dual()
		CODE:
			RETVAL = _get_dual();
		OUTPUT:
			RETVAL
