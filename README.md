# EIC
Contributions to EIC work
This repository contains contributions to the EIC work, the main bulk on the analysis of SiPm's of interest for the EIC. The repository is organized as follows:

Janus_scan.ps1: This is a powershell script that takes in a sample Janus configuration file "./test_config.txt" and generates more configuration files sufficient for a run on the Janus software sweeping through the appropriate bias voltages and high gain shaping times. Adjustments to the bias voltage, shaping time, sleep time, as well as increment sizes for former two can be made. Additionally, the runs generated are forward-to-back Generated runs will be placed in the "./Generated_config_files" directory. To run this script, open a powershell terminal and type in the following command in the current directory:

./Janus_scan.ps1

Final_runs/: This is the raw data from the runs using the Janus software on a single SiPm. The data is acquired using the config files within the "./Generated_config_files" directory. The data is organized as as "LED_runs" and "Pedestal_runs" for the LED and pedestal runs respectively.

SB_res.ipynb: This is a jupyter notebook that analyzes the data from the runs in the "./Final_runs" directory. The notebook generates plots from the high gain channel for each run and plots the resolution of the SiPm for each bias voltage and shaping time. The notebook takes into account the forward-to-back sweep and plots both resolutions. 

Resolution Sweep.pptx: Documenting the ongoing ramblings of a madman and his quest to find the optimal bias voltage and shaping time for the SiPm.
