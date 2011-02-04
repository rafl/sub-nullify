#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "hook_op_check_entersubforcv.h"

MGVTBL nullify_vtbl;

static OP *
nullify_cb (pTHX_ OP *o, CV *cv, void *ud)
{
    PERL_UNUSED_ARG(cv);
    PERL_UNUSED_ARG(ud);

    op_free(o);
    return newOP(OP_NULL, 0);
}

static void
nullify (CV *cv)
{
    sv_magicext((SV *)cv, NULL, PERL_MAGIC_ext, &nullify_vtbl,
                (const char *)hook_op_check_entersubforcv(cv, nullify_cb, NULL),
                0);
}

static void
unnullify (CV *cv)
{
    MAGIC *mg, *prevmagic = NULL, *moremagic = NULL;

    for (mg = SvMAGIC(cv); mg; prevmagic = mg, mg = moremagic) {
        moremagic = mg->mg_moremagic;

        if (mg->mg_type == PERL_MAGIC_ext && mg->mg_virtual == &nullify_vtbl) {
            if (prevmagic)
                prevmagic->mg_moremagic = moremagic;
            else
                SvMAGIC_set(cv, moremagic);

            hook_op_check_entersubforcv_remove((hook_op_check_id)mg->mg_ptr);

            mg->mg_moremagic = NULL;
            Safefree(mg);

            return;
        }
    }

    croak("CV not nullified");
}

MODULE = Sub::Nullify  PACKAGE = Sub::Nullify

void
nullify (CV *cv)

void
unnullify (CV *cv)
