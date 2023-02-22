# sava-vrbas
SAVA project (Vrbas team)
# Introduction

This document serves as a guideline for manipulating the required components and taking the necessary actions for the proper functioning and verification of the SAVA-Vrbas project.

# Required equipment

The development board DE1-Soc was used as necessary for the creation of the project, which specifications can be found [here](http://www.ee.ic.ac.uk/pcheung/teaching/ee2_digital/de1-soc_user_manual.pdf). The layout of the development board is shown in the picture below.

![DE1-SoC_top45_01](https://user-images.githubusercontent.com/116347913/220632817-d351121d-7827-47f0-aab2-e9430506ee71.jpg)



As for the needs of the project it is necessary to parameterize the CODEC from the development board, for this purpose Raspberry Pi was used as the second necessary module. A picture of used Raspberry Pi is shown below.

![Raspberry Pi 3 B+ 1-500x500](https://user-images.githubusercontent.com/116347913/220616330-d2458f93-0a0a-4ea2-9335-869936a38a03.jpg)

# Modules connection 

As the CODEC configuration takes place using the I2C interface, it is necessary to connect the DE1-SoC development board and the Raspberry Pi using the appropriate pins. It is necessary to connect the line for the common clock signal (SCL), for the data stream (SD) and the common ground (GND). The layout of the corresponding pins required to correctly connect these modules is shown in the figure below.

<img width="500x600"  src=https://user-images.githubusercontent.com/116347913/220618673-819eb58e-7d17-4794-97b3-24f2f1055219.jpg>

The final layout of all interconnected modules and the necessary equipment is shown in the picture below.

``` 
Note: Don't forget to push the red button.
```

<img width="600x700" src=https://user-images.githubusercontent.com/116347913/220627767-0db57c58-3e14-4722-8290-6a42627d771d.jpg>

# Starting up

After connecting all the necessary modules, it is necessary to run the CODEC configuration script. The script is located in the software/src folder called i2c_conf.sh. Running the script is done using the following command:
``` 
sudo sh ./i2c_adc_dac.sh
```
