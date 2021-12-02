[Home](https://bcunnane.github.io/)  
[View Code](https://github.com/bcunnane/fiber_tracking)

## Muscle fiber strain determined from motion tracking

The muscle fiber endpoints determined in 1a are used in an experiment that analyzes MG muscle strain for young and old subjects at different foot positions using 2D dynamic MRI. The subject’s foot is positioned in a foot pedal fixture in the bore of a 1.5T scanner. A projector prompts them to repeatedly press the pedal at different levels of their maximum pressing force while a velocity encoded phase contrast (VEPC) sequence collects dynamic MR data of their calf. This procedure is repeated for high and low pressing forces at three foot positions: dorsiflexion, neutral, and plantar flexion (Figure 1). 

[Figure 1](images/Figure 1 Foot positions with angles and moment arms.png)
> *Large FOV sagittal images of two subjects (top vs bottom row) at foot positions D, N, and P from left to right. The foot angles were measured from horizontal, and the moment arms (ma) were measured from the ankle joint to the Achilles tendon.*

I assisted in data collection and wrote a MATLAB script to organize fiber tracking (via velocities changing position through each frame); calculations of fiber length, strain, and angle; and data visualization (Figures 2, 3, & 4). This effort utilized equipment and code (for image processing and fiber motion tracking) from my research group’s past projects (see references), requiring me to adapt old tools for new applications. This experiment demonstrated relationships between foot position and strain, which could reveal physiological relationships between fiber length or angle and overall force generation.

[Figure 2](images/Figure 2 210818-BC-D 43% MVC animation.gif)
> *Average muscle fibers (yellow) identified from DTI data for the proximal, middle, and distal regions of the MG muscle. Cine image shows change in fiber length and angle over contraction cycle for a subject in the dorsiflexed foot position.*

[Figure 3](images/Figure 3 BC results over contraction cycle.png)
> *Change in fiber angle, length, and strain vs temporal cycle for the three foot positions. Determined from tracking change in position of the DTI-identified fibers throughout the muscle contraction cycle. The results for the fibers in the proximal, middle, and distal regions of the MG muscle were averaged for each percent MVC.*

[Table 1](images/*Figure 4 average data table.PNG*)
> *Averaged MG muscle fiber tracking results for all subjects at high and low percentages of MVC for the three foot positions.*

## References
Malis, V. (2020). Study of Human Muscle Structure and Function with Velocity Encoded Phase Contrast and Diffusion Tensor Magnetic Resonance Imaging Techniques. UC San Diego. ProQuest ID: Malis_ucsd_0033D_19166. Merritt ID: ark:/13030/m5tn2jhg. Retrieved from https://escholarship.org/uc/item/9x42v0wq
