[Home](https://bcunnane.github.io/)

# Muscle fiber strain determined from motion tracking via VEPC and Dynamic MRI

Muscle fiber strain is important

# 1. Data collection

Data is collected in a 1.5T GE scanner at UC San Diego's Radiology Imaging Laboratory. The patient's dominant leg is positioned on the scanner bed in a foot pedal fixture. The subject is first scanned with a fast spin echo sequence to provide high resolution images of their leg. From these, an optimal slice is chosen for the dynamic imaging. Next, the subjects maximum pressing force is determined. The foot pedal fixture records their maximum pressing force, and the average of 3 trials is set as their maximum voluntary contraction (MVC). The subject is then prompted via projector to repeatedly press their foot with a high or low percentage of MVC, and the dynamic imaging sequence collects velocity encoded phase contrast (VEPC) images of the subjects leg during foot presses. Each press acts as a trigger that is sent to the scanner via the ECG system. This process is repeated for 3 foot positions: dorsiflexion, neutral, and plantar flexion.

![Foot Positions](images/foot positions.png)

# 2. Data processing & strain analysis

I wrote several scripts and functions to 

The fiber endpoints are tracked using the VEPC data so that each endpoint's location is known for all frames. These locations are analyzed, and changes in the fiber's length over time are calculatated. The motion of the fiber's endpoints is recorded in a gif animation. 

[Fiber motion animations]

[Fiber strain charts]
