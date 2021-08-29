function recon = recon_fs(dynamic_dir)

orientation = 0;
home_dir = pwd;

cd(dynamic_dir)
dicom_path = dir('*dcm');
im_data=vepc_2d_imsort(dicom_path,orientation);

load(im_data);
recon = struct;
recon.series = Series_name;
recon.location = SliceLocation;
recon.M = im_m;
recon.Vx = v_rl;
recon.Vy = v_ap;
recon.Vz = v_si;

cd(home_dir)
end