function dicom_struct = dicom_data_read()
%DICOM_DATA_READ creates a data structure from raw dicom

warning('off', 'images:dicominfo:fileVRDoesNotMatchDictionary')

[file, path] = uigetfile("*.dcm",'Select dicom file.');

dicom_struct.image=dicomread([path,file]);
dicom_struct.header=dicominfo([path,file]);
dicom_struct.echoN = dicom_struct.header.EchoNumbers;
dicom_struct.TE = dicom_struct.header.EchoTime;
dicom_struct.location=dicom_struct.header.SliceLocation;
end




