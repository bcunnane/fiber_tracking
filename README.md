[Home](https://bcunnane.github.io/)    [GitHub repository](https://github.com/bcunnane/fiber_tracking)

# Muscle fiber strain determined from motion tracking

Muscle fiber strain is important

# 1. Data collection

Data is collected in a 1.5T GE scanner at UC San Diego's Radiology Imaging Laboratory. The patient's dominant leg is positioned on the scanner bed in a foot pedal fixture. The subject is first scanned with a fast spin echo sequence to provide high resolution images of their leg. From these, an optimal slice is chosen for the dynamic imaging. Next, the subjects maximum pressing force is determined. The foot pedal fixture records their maximum pressing force, and the average of 3 trials is set as their maximum voluntary contraction (MVC). The subject is then prompted via projector to repeatedly press their foot with a high or low percentage of MVC, and the dynamic imaging sequence collects velocity encoded phase contrast (VEPC) images of the subjects leg during foot presses. Each press acts as a trigger that is sent to the scanner via the ECG system. This process is repeated for 3 foot positions: dorsiflexion, neutral, and plantar flexion.

![Foot Positions](images/foot positions.png)

# 2. Data processing & strain analysis

I wrote a script to organize data processing so that the collected data is automatically saved as MATLAB structures. 

The fiber endpoints are identified on the first image frame (this may be done manually or by DTI eigenvector analysis). These endpoints are then progressively tracked through each frame using the VEPC veloctiy data. Once the endpoint locations are known, fiber elongation and therefore fiber strain may be calculated for each frame. I also wrote MATLAB functions to automatically create animations of fiber motion and plot strain over the cycle. The examples below show the results for neutral (N) foot position at 29% MVC for a subject.

![Fiber motion animation example](images/210818-BC-N 29% MVC animation.gif)

![Fiber result plot example](images/210818-BC-N 29% MVC plots.png)
