#!/bin/sh
pip install cython jupyter pandas networkx numpy scipy==1.5.0rc1 jupyterlab bokeh 
NODE_OPTIONS=--max-old-space-size=1024 jupyter labextension install @jupyter-widgets/jupyterlab-manager
NODE_OPTIONS=--max-old-space-size=1024 jupyter labextension install @jupyterlab/geojson-extension
# NODE_OPTIONS=--max-old-space-size=1024 jupyter labextension install @jupyterlab/github
# NODE_OPTIONS=--max-old-space-size=1024 jupyter labextension install @jupyterlab/git
NODE_OPTIONS=--max-old-space-size=1024 jupyter labextension install @bokeh/jupyter_bokeh

