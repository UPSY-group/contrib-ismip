### contrib-ismip

In this repo, we gather configs etc for the ISMIP7 contribution of UFEMISM/LADDIE

### Preparing your forcing files
Below is the file structure for input files to run the example config files. Rather than copy/pasting your data (wherever you have it), use soft links:

```
ln -s ACTUAL_FORCING_DIR input
ln -s ACTUAL_RESTART_DIR restart
```

This way, whenever you have a nice new initialisation, you just need to update the `restart` link to the new folder (and perhaps modify the times in the config file), rather than copying files and renaming all of these config variables.

### Expected file structure:
```
contrib-ismip
├── scripts/
│   └── run_ufemism.sh
├── input/
│   └── AIS/
│       ├── CESM2-WACCM/
│       │   ├── ssp585/
│       │   │   ├── ocean/
│       │   │   │   ├── so/
│       │   │   │   │   └── v3/
│       │   │   │   │       ├── so_AIS... .nc
│       │   │   │   │       └── ...
│       │   │   │   └── thetao/
│       │   │   │       └── v3/
│       │   │   │           ├── thetao_AIS... .nc
│       │   │   │           └── ...
│       │   │   └── SDBN1-8000km/
│       │   │       ├── acabf/
│       │   │       │   └── v2/
│       │   │       │       └── acabf_AIS... .nc
│       │   │       └── all other SMB and climate variables...
│       │   └── all other scenarios of the same model...
│       └── all other models...
└── restart/
    ├── main_output_ANT_00001.nc
    └── ...
```
