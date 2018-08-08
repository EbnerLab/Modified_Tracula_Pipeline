# Modified_Tracula_Pipeline
A modified version of the Freesurfer 6.0.0 Tracula pipeline using MRIcron dcm2niix for file conversion. This should be performed only after automated parcellation and segmentation with Freesurfer 6.0.0. Freesurfer 6.0.0, FSL 5.0.10 or higher, and the most recent version of MRIcron is needed.

It is strongly recommended that parallel processing for bedpostx be used when processing multiple subjects. Eddy current correction may also be run in parallel jobs for multiple subjects provided that the first portion of the pipeline is run in two separate steps. Tracula priors may also be run in parallel per subject and parallel processing pipelines are in the works to this end.
