#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "hook_op_check_entersubforcv.h"

static OP *
nullify_cb (pTHX_ OP *o, CV *cv, void *ud)
{
    PERL_UNUSED_ARG(cv);
    PERL_UNUSED_ARG(ud);

    op_free(o);
    return newOP(OP_NULL, 0);
}

static hook_op_check_id
nullify (CV *cv)
{
    return hook_op_check_entersubforcv(cv, nullify_cb, NULL);
}

MODULE = Sub::Nullify  PACKAGE = Sub::Nullify

hook_op_check_id
nullify (CV *cv)
