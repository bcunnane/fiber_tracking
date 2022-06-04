[Home](https://bcunnane.github.io/) • [Code](https://github.com/bcunnane/fiber_tracking)

This project develops MRI image processing methods to study muscle fiber strains in the medial gastrocnemius (MG) of the human calf. Specifically, it examines the effects of different ankle angles and exertion levels to identify the dependence of muscle force on muscle architecture.

### Collect Data
Data was collected for 6 subjects in a 1.5T MRI scanner as shown in Figure 1. The subject’s foot is positioned in a foot pedal fixture that records their pressing force. A projector prompts them to repeatedly press the pedal at a certain percentage of their maximum voluntary contraction (% MVC). This procedure is repeated for high (50% MVC) and low (25% MVC) pressing forces at three foot positions: dorsiflexion, neutral, and plantar flexion. Several different MRI sequences were utilzed to collect different image types, including:
1. Large field of view images to measure the subject's ankle position (see Figure 2)
2. Multiple slices of high resolution images to scout for an ideal slice with clear fibers
3. Diffusion images for the chosen slice
4. Dynamic (i.e. video) velocity images for the chosen slice

![Experimental Setup](files/Research experimental setup.png)
> *Figure 1. Experimental Setup*

![Ankle Angles](files/Foot Angles.png)
> *Figure 2. Ankle angle measurements for all subjects. Top row shows dorsiflexion, middle shows neutral, and bottom shows plantar flextion.*

### Identify Muscle Fibers from Diffusion Tensors
Diffusion tensors are calculated from the diffusion images. Since the primary direction of water diffusion within skeletal muscle is along the muscle fiber, the diffusion tensor's principal eigenvector follows the muscle fiber's direction. An outline of the MG muscle was manually identified, then split into three equal-size regions: proximal, middle, and distal. Then the principal eigenvectors in each region were extracted and averaged to form representative fibers (see Figure 3).

![DTI image](files/220311-BC-D DTI results cropped.png)
> *Figure 3. Left: Manual outline of MG muscle. Center: Masks of the three regions of MG muscle. Right: Muscle fibers determined for later analysis (yellow).*

### Track Muscle Fibers and Analyze Changes
The endpoints of the DTI-identified muscle fibers were tracked through each frame of the dynamic study (See Figure 4). Changes in fiber angle were calculated with respect to the vertical in the image. Changes in fiber length were calculated with respect to initial length, leading to changes in Lagrangian strain. The results of the three muscle fibers were averaged together (see Figure 5). 

![Fiber Gif](files/220311-BC animation.gif)
> *Figure 4. Average muscle fibers identified from diffusion tensor data for the proximal, middle, and distal regions of the MG muscle. Cine image shows change in fiber length and angle over contraction cycle for all exertion levels and ankle angles of a single subject.*

![Result Plot](files/Temporal Plots.png)
> *Figure 5. Change in fiber angle, length, and strain vs temporal cycle for the three foot positions. Determined from tracking change in position of the DTI-identified fibers throughout the muscle contraction cycle. The results for the fibers in the proximal, middle, and distal regions of the MG muscle were averaged for each percent MVC.*

### Statistical Analysis and Results
Table 1 shows the averages and standard deviations (in brackets) of the results across all subject. Significant differences in outcomes for the particular foot angles and submaximal force levels were assessed using two-way analysis of variance (ANOVA) and paired t-testing.

![Table](files/Table 1.PNG)
> *Table 1. Averaged and standard deviation (in brackets) MG muscle fiber tracking results for all subjects at high and low percentages of MVC for the three foot positions.*
