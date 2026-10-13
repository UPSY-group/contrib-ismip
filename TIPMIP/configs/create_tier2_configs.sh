#!/bin/bash

PARTS=(p0 p1 p2 p3 p4)

for PART in "${PARTS[@]}"; do
  # Experiment 2
  DEST="Tier2/E2${PART}.cfg"
  cp "Tier1/E1${PART}.cfg" "$DEST"
  # Experiment name
  sed -i "s/E1${PART}/E2${PART}/g" "$DEST"
  sed -i "s/Exp01/Exp02/g" "$DEST"
  sed -i "s/-def/-LowAtm/g" "$DEST"
  # Parameter value
  sed -i 's/lapse_rate_temp_ANT_config[[:space:]]*=[[:space:]]*7.5E-3/lapse_rate_temp_ANT_config = 5.0E-3/g' "$DEST"
  # Possible restart files
  sed -i "s/E1p0/E2p0/g" "$DEST"
  sed -i "s/E1p1/E2p1/g" "$DEST"
  sed -i "s/E1p3/E2p3/g" "$DEST"

  # Experiment 3
  DEST="Tier2/E3${PART}.cfg"
  cp "Tier1/E1${PART}.cfg" "$DEST"
  sed -i "s/E1${PART}/E3${PART}/g" "$DEST"
  sed -i "s/Exp01/Exp03/g" "$DEST"
  sed -i "s/-def/-HighAtm/g" "$DEST"
  sed -i 's/lapse_rate_temp_ANT_config[[:space:]]*=[[:space:]]*7.5E-3/lapse_rate_temp_ANT_config = 10.0E-3/g' "$DEST"
  sed -i "s/E1p0/E3p0/g" "$DEST"
  sed -i "s/E1p1/E3p1/g" "$DEST"
  sed -i "s/E1p3/E2p3/g" "$DEST"

  # Experiment 4
  DEST="Tier2/E4${PART}.cfg"
  cp "Tier1/E1${PART}.cfg" "$DEST"
  sed -i "s/E1${PART}/E4${PART}/g" "$DEST"
  sed -i "s/Exp01/Exp04/g" "$DEST"
  sed -i "s/-def/-LowOcn/g" "$DEST"
  sed -i 's/laddie_drag_coefficient_top_config[[:space:]]*=[[:space:]]*0.9E-3/laddie_drag_coefficient_top_config = 0.5E-3/g' "$DEST"
  sed -i "s/E1p0/E4p0/g" "$DEST"
  sed -i "s/E1p1/E4p1/g" "$DEST"
  sed -i "s/E1p3/E4p3/g" "$DEST"

  # Experiment 5
  DEST="Tier2/E5${PART}.cfg"
  cp "Tier1/E1${PART}.cfg" "$DEST"
  sed -i "s/E1${PART}/E5${PART}/g" "$DEST"
  sed -i "s/Exp01/Exp05/g" "$DEST"
  sed -i "s/-def/-HighOcn/g" "$DEST"
  sed -i 's/laddie_drag_coefficient_top_config[[:space:]]*=[[:space:]]*0.9E-3/laddie_drag_coefficient_top_config = 1.4E-3/g' "$DEST"
  sed -i "s/E1p0/E5p0/g" "$DEST"
  sed -i "s/E1p1/E5p1/g" "$DEST"
  sed -i "s/E1p3/E5p3/g" "$DEST"

done
