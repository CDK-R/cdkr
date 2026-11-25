# FastRet: descriptor cache compatibility

## Diagnosis

For the five molecules in the failing FastRet 1.5.2 test, direct comparison
of the old and new backends found:

- The same 53 discovered descriptor classes, in the same order.
- The same 45 explicitly requested classes and 241 selected feature columns.
- The same stored cache values.
- Fresh numerical differences only in MW and ATSm1 through ATSm5, with maximum
  absolute differences of about 1.04e-5 and 6.43e-6 respectively.
- Cached geomShape is NA while freshly calculated geomShape is NaN on both
  stacks. This is not a newly introduced CDK missing-value change.

Upstream WeightDescriptor and AutocorrelationDescriptorMass changed from
IsotopeFactory.getNaturalMass to Isotopes.average. The installed 2.14.1
WeightDescriptor bytecode calls Isotopes.average. No output reordering was
observed. This is not evidence of a lost uber-JAR service registration.

Run `diagnose-stack.R` in fresh R sessions for both dependency stacks to
reproduce the measurements. They cover this fixture, not all molecules or
all descriptors.

## Why the proposed test-only patch is insufficient as a cache policy

FastRet's getCDs caches descriptors in one CDs.sqlite, keyed only by SMILES.
init_cache seeds it from the shipped database; read_cached_cds joins only on
SMILES; write_cached_cds uses INSERT OR IGNORE. The shipped database has
1,802 rows and only a cds table, with no backend provenance metadata.

Consequently a CDK upgrade can reuse historical rows for known compounds and
calculate new rows under a different descriptor implementation. The existing
test-only patch removes an invalid cross-version equality assumption, but
does not address this production behavior.

Relevant downstream code (CRAN FastRet 1.5.2):

- R/getcds.R: getCDs, cache_path, init_cache, read_cached_cds, write_cached_cds.
- R/prepro.R: preprocess_data calls getCDs, but accepts supplied complete
  descriptor frames without recomputing them.
- R/train.R: train_frm preprocesses training data; predict_frm calculates
  missing predictors and can use the training descriptor frame for imputation.

Changing the cache alone therefore cannot guarantee consistency with an
already-trained model or externally supplied descriptors.

## Recommended cache policy

1. Namespace caches by a descriptor backend/schema identity: rcdk version,
   rcdklibs/CDK version, and FastRet's descriptor schema version.
2. Store that identity in database metadata and validate it on opening.
3. Seed from shipped data only when the shipped data declares a matching
   identity. Without trustworthy provenance, use its schema but start with
   zero descriptor rows. Do not infer a historical backend from near-equality.
4. Do not migrate or overwrite the existing unversioned cache in place. Leave
   it available for older installations; recompute into the new namespace.
5. Normalize missing descriptor values to NA at the calculation boundary,
   matching the representation persisted by SQLite, so fresh/cache-hit results
   have consistent semantics.
6. Keep cache integrity tests: same-backend calculation versus round-trip,
   duplicate molecules, worker processes, backend/schema mismatch, and old
   unversioned cache isolation. Do not require old shipped values to equal
   every future CDK implementation.

For cached data this is a correctness fix, not merely a larger tolerance.
It costs a one-time recomputation and more disk space per backend.

## Separate model policy requiring downstream maintainer agreement

Record descriptor provenance in newly trained models. At prediction time,
compare it with the backend used to generate new descriptors.

For backward compatibility, recommend a prominent warning for a known
mismatch or an older model with unknown provenance, rather than silently
retraining it or immediately rejecting all older models. Reproducibility
requires running the matching backend or deliberately retraining/revalidating
the model. Users supplying complete descriptor frames also need a provenance
contract; rcdk cannot infer their origin.

Strict rejection is stronger but breaks existing model workflows. Neither
recomputing a cache nor small observed differences is proof that predictions
from a historical model are unaffected. This policy should be chosen with
the FastRet maintainer before a production patch is submitted.

## Scope recommendation

Do not roll back rcdk's mass descriptors globally to hide one downstream
fixture mismatch. Propose the versioned-cache fix and updated same-backend
tests to FastRet, with model provenance/warnings agreed separately. The
existing FastRet-cache-test.patch remains a minimal test compatibility patch,
not the complete recommended production solution.
