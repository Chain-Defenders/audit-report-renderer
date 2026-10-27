# The environment the Chain Defenders audit report workflow renders in: TeX Live, pandoc and Ghostscript from
# Ubuntu 24.04 (the same packages the workflow installed on every run before), and Python 3.11.
#
# Public on purpose: it holds tools only. Report sources, issues, logos and fonts stay in each private audit
# repository; nothing about a client is ever in this image.
FROM ubuntu:24.04

COPY --from=ghcr.io/astral-sh/uv:0.4.30 /uv /usr/local/bin/uv

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    UV_PYTHON_INSTALL_DIR=/opt/python

# Exactly the packages the workflow used to install with apt (recommended packages included, as apt does), plus git
# and certificates so actions/checkout and the issue export work inside the container.
RUN apt-get update \
 && apt-get install -y pandoc texlive-xetex texlive-latex-extra texlive-fonts-recommended texlive-lang-chinese ghostscript \
      git ca-certificates \
 && rm -rf /var/lib/apt/lists/*

# Python 3.11, as the workflow used (Ubuntu 24.04 ships 3.12, which the pinned PyYAML 6.0 has no wheel for).
# The report tool's own requirements are installed by the workflow from its requirements.txt, so they stay pinned
# by the report tool, not by this image.
RUN uv python install 3.11 \
 && uv venv --seed --python 3.11 /opt/venv
ENV VIRTUAL_ENV=/opt/venv \
    PATH=/opt/venv/bin:$PATH

RUN python --version && xelatex --version | head -1 && pandoc --version | head -1 && gs --version
