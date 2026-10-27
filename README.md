# audit-report-renderer

The container the Chain Defenders audit report workflow runs in: TeX Live, pandoc and Ghostscript from Ubuntu
24.04, and Python 3.11. Built here, published as `ghcr.io/chain-defenders/audit-report-renderer`.

Before, every report run installed TeX from Ubuntu's package servers (about 3 minutes, sometimes far longer). The
report workflow now starts from this image instead and is pinned to an exact digest, so a rebuild never changes
existing reports until the template is updated to the new digest.

It holds tools only: report sources, issues, logos and fonts stay in each private audit repository.

Each push to `main` builds the image, renders a small XeLaTeX document with the packages the report uses, checks
Python, then pushes `latest` and the commit's tag. The run summary prints the digest to pin.
