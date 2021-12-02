[Home](https://bcunnane.github.io/)  
[View Code](https://github.com/bcunnane/fiber_tracking)

## Muscle fiber strain determined from motion tracking

The muscle fiber endpoints determined in 1a are used in an experiment that analyzes MG muscle strain for young and old subjects at different foot positions using 2D dynamic MRI. The subject’s foot is positioned in a foot pedal fixture in the bore of a 1.5T scanner. A projector prompts them to repeatedly press the pedal at different levels of their maximum pressing force while a velocity encoded phase contrast (VEPC) sequence collects dynamic MR data of their calf. This procedure is repeated for high and low pressing forces at three foot positions: dorsiflexion, neutral, and plantar flexion (Figure 1). I assisted in data collection and wrote a MATLAB script to organize fiber tracking (via velocities changing position through each frame); calculations of fiber length, strain, and angle; and data visualization (Figures 2, 3, & 4). This effort utilized equipment and code (for image processing and fiber motion tracking) from my research group’s past projects (see references), requiring me to adapt old tools for new applications. This experiment demonstrated relationships between foot position and strain, which could reveal physiological relationships between fiber length or angle and overall force generation.




This project is an extension of prior work by Malis (see reference section below) and utilized its hardware (foot pedal fixture, data acquisition) and software (DICOM processing, VEPC motion tracking).

### 1. Data collection

Data is collected in a 1.5T GE scanner at UC San Diego's Radiology Imaging Laboratory. The patient's dominant leg is positioned on the scanner bed in a foot pedal fixture. The subject is first scanned with a fast spin echo sequence to provide high resolution images of their leg. From these, an optimal slice is chosen for the dynamic imaging. Next, the subjects maximum pressing force is determined. The foot pedal fixture records their maximum pressing force, and the average of 3 trials is set as their maximum voluntary contraction (MVC). The subject is then prompted via projector to repeatedly press their foot with a high or low percentage of MVC, and the dynamic imaging sequence collects velocity encoded phase contrast (VEPC) images of the subjects leg during foot presses. Each press acts as a trigger that is sent to the scanner via the ECG system. This process is repeated for 3 foot positions: dorsiflexion, neutral, and plantar flexion.



## References
Malis, V. (2020). Study of Human Muscle Structure and Function with Velocity Encoded Phase Contrast and Diffusion Tensor Magnetic Resonance Imaging Techniques. UC San Diego. ProQuest ID: Malis_ucsd_0033D_19166. Merritt ID: ark:/13030/m5tn2jhg. Retrieved from https://escholarship.org/uc/item/9x42v0wq
