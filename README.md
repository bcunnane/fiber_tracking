[Home](https://bcunnane.github.io/)

# Muscle fiber strain determined from motion tracking via VEPC and Dynamic MRI

Muscle fiber strain is important

# 1. Data collection

Data is collected in a 1.5T GE scanner at UC San Diego's Radiology Imaging Laboratory. The patient's dominant leg is positioned on the scanner bed in a foot pedal fixture. The fixture record's their pressing force as they flex their foot in response to visual cues. The force data is saved on an externa laptop in the console room. The subject is first scanned with a fast spin echo sequence to provide high resolution images of their leg. From these, an optimal slice is chosen for the dynamic imaging. The dynamic imaging sequence collects velocity encoded phase contrast (VEPC) images of the subjects leg during foot presses. Finally, a diffusion tensor imaging (DTI) sequence is performed if fiber tracking is desired. This process is repeated for 3 foot positions: dorsiflexion, neutral, and plantar flexion. 

Note: discuss MVC 

[Foot Positions]

# 2. Data processing

I wrote a script to automate processing the force data and dynamic imaging data.

# 3. Strain analysis

The fiber endpoints are tracked using the VEPC data so that each endpoint's location is known for all frames. These locations are analyzed, and changes in the fiber's length over time are calculatated. The motion of the fiber's endpoints is recorded in a gif animation. 

[Fiber motion animations]

[Fiber strain charts]
