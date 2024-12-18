# Download
https://github.com/ljw20180420/sx_lcy/releases

# Install
It is recommanded to use rearr in docker. If you want to install natively, cd into the project fold and execute `./install.sh` core sx.

# Install rootless docker
First, install docker engine: https://docs.docker.com/engine/install
Then install rootless docker: https://docs.docker.com/engine/security/rootless/#install

# Usage
See `rearrTest.sh`.
If you use docker, first login into docker.
```bash
./loginWorker.sh
```
Then just use as native.

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
First, you need docker: https://docs.docker.com/engine/install.
Maybe you need to configure the proxy of docker daemon: https://docs.docker.com/engine/daemon/proxy.
To access host loopback in rootless docker: https://forums.docker.com/t/no-longer-able-to-access-local-ips-in-rootless-docker-after-update/141890.
Docker buildx does not respect the daemon proxy. One has to use system proxy, say
```bash
HTTPS_PROXY=socks5://127.0.0.1:1080 docker compose build
```
```bash
cd sx_lcy
./compose.sh
```

# TODO
```[tasklist]
- [ ] kvm
- [ ] javascript -> html -> css -> typescript -> tamper monkey -> selenium
- [ ] add CDCI support by github (git -> github docs|skills|support|community -> docker registery)
- [ ] vue -> uniapp -> tauri2
- [ ] add benchmark for SIQ: https://github.com/RobinVanSchendel/SIQ
- [ ] convert alg to sam
- [ ] Celery flower does not work properly on server. Maybe permission problem.
- [ ] asgi is more advance than wsgi
- [ ] unittest
- [ ] resemble indelphi
- [ ] implement tidymodels (need to install tidymodels in shiny rocker, which must not be installed through CRAN)
- [ ] explore base
- [ ] feature choose
- [ ] AI review
- [ ] PCR
- [ ] CDN
- [ ] Add 3D structure prediction shiny App
- [ ] Add large language model for DNA
- [ ] Use explicit base in shiny app microHomology
- [ ] Deploy to JCloud
- [ ] Use probability language to inplement Gibbs sampling for predicting the frequencies of blunt end cleavage events
- [ ] Automatic document
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