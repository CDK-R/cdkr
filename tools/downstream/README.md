# Proposed downstream compatibility patches

These patches target the CRAN source releases FastRet 1.5.2 and RxnSim 1.0.4.
They are proposals for the downstream maintainers, not changes to rcdk's
chemistry behavior, and have not been submitted to those maintainers.

Apply to unpacked source packages:

```sh
patch -p1 -d path/to/RxnSim < tools/downstream/RxnSim-empty-fingerprints.patch
patch -p1 -d path/to/FastRet < tools/downstream/FastRet-cache-test.patch
mkdir -p path/to/RxnSim/tests
cp tools/downstream/test-RxnSim-empty-fingerprints.R \
  path/to/RxnSim/tests/empty-fingerprints.R
```

## RxnSim

CDK 2.14.1 produces an empty extended bit fingerprint for `[H+]`. Tanimoto
similarity for two empty fingerprints is `0/0`, which `fingerprint::distance`
returns as `NaN`. This propagates into RxnSim's matching scores and breaks
`if (straight >= cross)`.

The patch defines two-empty-set Tanimoto/Jaccard similarity as 1. An empty
versus nonempty fingerprint remains 0 through the existing implementation.
Other metrics and count fingerprints are unchanged. This is an explicit
empty-set convention for downstream maintainer review, not a general rule
that every missing similarity should be treated as zero or one.

The regression script tests empty/empty, empty/nonempty, nonempty/empty,
nonempty/nonempty, an unaffected metric, the originally failing reaction
example with and without verbose output, and reaction self-similarity.
It passes with both CRAN rcdk 3.8.2 / rcdklibs 2.9 and candidate rcdk 3.9.0 /
rcdklibs 2.14.1 on the local JDK 27.

## FastRet

The failing test equates a shipped historical descriptor cache with fresh
computations under whichever CDK is installed. The upgrade changes some
numeric values and missing-value representations. The proposed test-only
patch compares the uncached path with a direct current calculation instead.
Existing cache round-trip, duplicate, and parallel-path assertions remain.

This deliberately preserves the shipped descriptor cache and does not
change production output or loosen numerical tolerances. A separate product
decision would be needed to version/invalidate historical caches or recompute
model-training descriptors; that is not silently bundled into this patch.

All 15 assertions in the focused `getCDs` tests pass with both dependency
stacks on the local JDK 27.

## Reproduction and broader checks

Patched source trees used locally are under `.release/patches/`. With their
dependencies installed in a workspace-local library and `R_LIBS_USER`
selecting the desired stack:

```sh
Rscript tools/downstream/test-RxnSim-empty-fingerprints.R
Rscript -e 'testthat::test_local(".release/patches/FastRet", filter="getCDs", stop_on_failure=TRUE)'
Rscript tools/downstream/check-patched.R old  # or new
```

The latter runs `R CMD check --no-manual --no-build-vignettes` for both patched
packages with `_R_CHECK_FORCE_SUGGESTS_=false` (matching revdepcheck), saving
results under `.release/results/`. It requires the baseline
or candidate stack to be explicitly selected; use separate R processes to
avoid JVM/classpath contamination.
