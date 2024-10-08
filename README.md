# Download
https://github.com/ljw20180420/sx_lcy/releases

# Install
```{bash}
It is recommanded to use rearr in docker. If you want to install natively, cd into the project fold and execute ./install/sh core sx
```

# Install rootless docker
First, install docker engine (refer to https://docs.docker.com/engine/install)
Then install rootless docker (https://docs.docker.com/engine/security/rootless/#install)

# Usage
```{bash}
See rearrTest.sh
If you use docker, first login into a docker by ./loginWorker.sh dataPath. dataPath will be mounted to /app/data in docker. Then just use as native.
```

# Parameters
```{list}
ref1: reference string of locus 1
ref2: reference string of locus 2 (for single cut, ref2 = ref1)
cut1: cut point for ref1
cut2: cut point for ref2
NGGCCNtype1: ref1 is on the NGG strand or the CCN strand
NGGCCNtype2: ref2 is on the NGG strand or the CCN strand
```

# Output
```{list}
target.count: file of target and pair without duplicates
target.demultiplex: file after demultiplex
target.post: file ready to align
target.alg: alignments
```

# Setup the docker based server
First, you need docker: https://docs.docker.com/engine/install/ubuntu
Maybe you need to configure the proxy of docker daemon: https://docs.docker.com/config/daemon/systemd
```{list}
cd sx_lcy
./pre-compose-up.sh
docker compose up -d
```

# TODO
```[tasklist]
- [ ] convert alg to sam
- [ ] use iframe output for diffloopAnalysis(Pair)
- [ ] add shiny python to nginx server
- [ ] rewrite vueflow by reactiveVal
- [ ] use fuzzy render for heatmap
- [ ] add info to shiny app widget
- [ ] Celery flower does not work properly on server. Maybe permission problem.
- [ ] fix one alignment bug in shiny server docker (gawk: fatal: cannot open source file `correct_micro_homology.awk' for reading: No such file or directory; cannot create dir '/srv/shiny-server/downstreamAnalysis/app_cache', reason 'Permission denied')
- [ ] asgi is more advance than wsgi
- [ ] unittest
- [ ] DuckDB is faster than tidyverse
- [ ] add a link to genome in install.sh
- [ ] add a snakemake workflow
- [ ] add CDCI support by github action
- [ ] resemble indelphi
- [ ] implement tidymodels (need to install tidymodels in shiny rocker, which must not be installed through CRAN)
- [ ] explore base
- [ ] feature choose
- [ ] AI review
- [ ] PCR
- [ ] CDN
- [ ] Modulerize native installation
- [ ] Substitute native installation into Dockerfiles
- [ ] Optimize DockerFiles by merge install commands
- [ ] Move sed/awk/perl codes embedded in bash scripts to individual files for easier debugging and reusing
- [ ] stage docker build process (say a celery image can be used for both flask image and worker image)
- [ ] Add tls
- [ ] Install necessary dependencies to shiny server
- [ ] Organize the whole project to a more extensible form (easily add now function both natively, in docker, or online)
- [ ] Add 3D structure prediction shiny App
- [ ] Add large language model for DNA
- [ ] Use explicit base in shiny app microHomology
- [ ] Add shiny app to predict indel events
- [ ] Add shiny app for kpLogo
- [ ] Deploy to JCloud
- [ ] Use probability language to inplement Gibbs sampling for predicting the frequencies of blunt end cleavage events
- [ ] Automatic document
- [ ] Python program all run in shiny, so only need a python shiny docker
- [ ] R program all run in shiny, so only need rocker/shiny-verse image
```

# TODO (Long term)
```[tasklist]
- [ ] 4C normalization algorithm
- [ ] Use GNU autotools to install Rearrangement
- [ ] Hi-C apps
- [ ] DeepFri
- [ ] PDB structure prediction
- [ ] molecular dynamics simulation
- [ ] Call TADs
```