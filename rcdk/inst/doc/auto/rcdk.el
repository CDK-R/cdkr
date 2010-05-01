(TeX-add-style-hook "rcdk"
 (lambda ()
    (LaTeX-add-labels
     "fig:ols"
     "fig:cluster"
     "fig:isotopes")
    (TeX-add-symbols
     '("rclass" 1)
     '("funcarg" 1)
     '("Rpackage" 1)
     '("Rfunction" 1))
    (TeX-run-style-hooks
     "hyperref"
     "pdftex"
     "url"
     "times"
     "fullpage"
     "latex2e"
     "art11"
     "article"
     "letterpaper"
     "11pt")))

