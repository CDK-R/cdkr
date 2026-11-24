# Reverse-dependency analysis: rcdklibs 2.14.1

## Result

All 12 direct reverse dependencies completed paired checks. Ten have no new
problems; FastRet and RxnSim introduce one check error each. No installation
failures or timeouts were reported. This is not yet release clearance.

## Scope and environment

- Run date: 2026-11-24.
- macOS ARM64, R 4.5.2, Homebrew OpenJDK 27.
- Candidate: current rcdk 3.9.0 sources with rebuilt Java 8-targeted helper JAR.
- Candidate rcdklibs: 2.14.1, GitHub commit
  `bf933d76929ab9a5835881a1a099e27eccfe849a`.
- Baseline: CRAN rcdk 3.8.2; per-check baseline dependency library contains
  rcdklibs 2.9. Candidate library precedes that library and supplies 2.14.1.
- Both sides use rJava 1.0-11.
- CRAN plus Bioconductor 3.22 repositories associated with R 4.5.2.
- Direct reverse Depends, Imports, Suggests, LinkingTo. Package selection was
  independently checked against `tools::package_dependencies`.
- Two workers, 30-minute timeout per check.
- Own package: `R CMD check --no-manual`, zero errors, warnings, or notes.
- Revdeps: `R CMD check --no-manual --no-build-vignettes`.

This does not cover transitive-only reverse dependencies, other Bioconductor
releases, other operating systems, or Java 8/17 runtime validation.
Individual package tests may skip optional/CRAN-disabled work.

## Package results

| Package | Version | Repository | New problems | Existing notes |
| --- | --- | --- | --- | --- |
| admetshiny | 1.0.1 | CRAN | None | 0 |
| DeepPINCS | 1.18.0 | Bioconductor | None | 1 |
| FastRet | 1.5.2 | CRAN | Test error | 0 |
| fioRa | 0.3.7 | CRAN | None | 0 |
| InterpretMSSpectrum | 1.5.3 | CRAN | None | 0 |
| LipinskiFilters | 1.0.1 | CRAN | None | 1 |
| pubchem.bio | 1.0.5 | CRAN | None | 0 |
| REFT | 0.1.4 | CRAN | None | 1 |
| RMassBank | 3.20.0 | Bioconductor | None | 2 |
| rQSAR | 1.0.0 | CRAN | None | 0 |
| RxnSim | 1.0.4 | CRAN | Example error | 0 |
| webchem | 2.0.0 | CRAN | None | 0 |

## FastRet: descriptor fixture/cache mismatch

`test-getCDs.R:22` compares cached descriptor values with freshly calculated
ones. Candidate output differs in missing-value representation (`NA` versus
`NaN`) and small numerical changes. The test summary is 146 passes, one
failure, one warning, five skips. The failure is absent with the baseline.

These observations do not yet isolate whether the differences come from
CDK, the R interface, or their interaction. Do not simply loosen the
downstream assertion without identifying the changed descriptors and checking
the intended numerical and missing-value semantics.

## RxnSim: reaction-similarity runtime failure

A documented `rs.compute(rct1, rct2, verbose = TRUE)` example fails with:

```
Error in if (straight >= cross) { :
  missing value where TRUE/FALSE needed
```

The printed reactions include a standalone `[H+]` product. This is a lead
for investigating empty/degenerate fingerprints or missing similarity values,
not an established root cause. The baseline completes the examples.

Prioritize a minimal reproduction of this error, inspect the fingerprints
and similarity operands, and determine the correct behavior before adding a
compatibility fix. A blanket `NA`-to-zero substitution could hide a real
chemistry or fingerprinting issue.

## Local evidence

The full run is preserved under:

```
.release/20261124-085613-b76c38ea2457/
  results/
  candidate/revdep/README.md
  candidate/revdep/problems.md
  candidate/revdep/failures.md
  candidate/revdep/checks.noindex/
```

Repository and package inventories are in
`.release/results/revdep-repositories.csv` and `revdep-inventory.csv`.
Artifacts are ignored local files, not included in the source package.
