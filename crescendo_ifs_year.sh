#!/bin/bash

set -ex

usage()
{
   echo "Usage:"
   echo "       ${0##*/} EXP YEAR"
   echo
   echo " Merge monthly/daily files of year YEAR of experiment EXP"
}

runid=$1
yyyy=$2

# outfile name stems
aermon3dout=AERmon_EC-Earth3-AerChem_${runid}_r1i1p1f1_gn-IFS_${yyyy}01-${yyyy}12
aerday2dout=AERday_EC-Earth3-AerChem_${runid}_r1i1p1f1_gn-IFS_${yyyy}0101-${yyyy}1231
aermon2dout=AERmon_EC-Earth3-AerChem_${runid}_r1i1p1f1_gn-IFS_${yyyy}01-${yyyy}12
aer6hrout=AER6hr_EC-Earth3-AerChem_${runid}_r1i1p1f1_gn-IFS_${yyyy}01010000-${yyyy}12311800
aerfxout=AERfx_EC-Earth3-AerChem_${runid}_r1i1p1f1_gn-IFS_${yyyy}

# infile name stems
aermon3d='AERmon'
aerday2d='AERday'
aermon2d='AERmon'
aer6hr='AER6hr'

# -- PATHs
# processed output
basepath=${SCRATCH}/CRESCENDO

# output directory
outdir=${basepath}/amip-${runid}-${yyyy}

# temp for ifs files
IFStemp=${basepath}/ifstemp/${runid}/

# make sure ifs temp does not have yearly files
rm -f ${IFStemp}/*_${yyyy}.nc

# make sure we have an output directory, and it is empty
mkdir -p ${outdir}
rm -f ${outdir}/*

# -- join monthly files to onefile
for i in ${IFStemp}/*_AERmon_${yyyy}01.nc
do
    #for k in 01 02 03 04 05 06 07 08 09 10 11 12
    #do 
        #cdo monmean ${IFStemp}/$(basename $i 01.nc)${k}.nc  ${IFStemp}/$(basename $i 01.nc)${k}.mm.nc
    #done
    cdo mergetime ${IFStemp}/$(basename $i 01.nc)??.mm.nc  ${IFStemp}/$(basename $i 01.nc).nc
done 

# -- join daily files to onefile
for i in ${IFStemp}/*_AERday_${yyyy}01.nc
do
    #for k in 01 02 03 04 05 06 07 08 09 10 11 12
    #do 
        #cdo daymean ${IFStemp}/$(basename $i 01.nc)${k}.nc  ${IFStemp}/$(basename $i 01.nc)${k}.mm.nc
    #done
    cdo mergetime ${IFStemp}/$(basename $i 01.nc)??.mm.nc  ${IFStemp}/$(basename $i 01.nc).nc
done 
for i in ${IFStemp}/*_AER6hr_${yyyy}01.nc
do
    cdo mergetime ${IFStemp}/$(basename $i 01.nc)??.nc  ${IFStemp}/$(basename $i 01.nc).nc
done 

# remove monthly tempfiles
rm -f ${IFStemp}/*_AER???_${yyyy}??.mm.nc
rm -f ${IFStemp}/*_AER???_${yyyy}??.nc


echo "*II* copy IFS files to final output dir: ${outdir}"
#aermon-2d${aer
cp ${IFStemp}/tos_${aermon2d}_${yyyy}.nc ${outdir}/tos_crescendo_${aermon2dout}_${yyyy}.nc
cp ${IFStemp}/sic_${aermon2d}_${yyyy}.nc ${outdir}/sic_crescendo_${aermon2dout}_${yyyy}.nc
# upward part is  STR-STRD,but here the convention is down positive, CMIPoutput requires upwards positive
# -> rlus=-(STR-STRD)
cp ${IFStemp}/rlus_${aermon2d}_${yyyy}.nc  ${outdir}/rlus_crescendo_${aermon2dout}_${yyyy}.nc
# upward part is  SSR-SSRD,but here the convention is down positive, CMIPoutput requires upwards positive
# -> rsus=-(SSR-SSRD)
cp ${IFStemp}/rsus_${aermon2d}_${yyyy}.nc  ${outdir}/rsus_crescendo_${aermon2dout}_${yyyy}.nc

cp ${IFStemp}/rsds_${aermon2d}_${yyyy}.nc ${outdir}/rsds_crescendo_${aermon2dout}_${yyyy}.nc
cp ${IFStemp}/rlds_${aermon2d}_${yyyy}.nc ${outdir}/rlds_crescendo_${aermon2dout}_${yyyy}.nc
cp ${IFStemp}/rsdt_${aermon2d}_${yyyy}.nc ${outdir}/rsdt_crescendo_${aermon2dout}_${yyyy}.nc
# SI-TSR(C)  
cp ${IFStemp}/rsutcs_${aermon2d}_${yyyy}.nc  ${outdir}/rsutcs_crescendo_${aermon2dout}_${yyyy}.nc
cp ${IFStemp}/rsut_${aermon2d}_${yyyy}.nc  ${outdir}/rsut_crescendo_${aermon2dout}_${yyyy}.nc
# down is positive for TTRC and TTR, Upwards positive for CMIP6 -> -TTRC, -TTR
cp ${IFStemp}/rlutcs_${aermon2d}_${yyyy}.nc  ${outdir}/rlutcs_crescendo_${aermon2dout}_${yyyy}.nc
cp ${IFStemp}/rlut_${aermon2d}_${yyyy}.nc ${outdir}/rlut_crescendo_${aermon2dout}_${yyyy}.nc
 
cp ${IFStemp}/uas_${aermon2d}_${yyyy}.nc ${outdir}/uas_crescendo_${aermon2dout}_${yyyy}.nc
cp ${IFStemp}/vas_${aermon2d}_${yyyy}.nc  ${outdir}/vas_crescendo_${aermon2dout}_${yyyy}.nc
cp ${IFStemp}/sfcWind_${aermon2d}_${yyyy}.nc  ${outdir}/sfcWind_crescendo_${aermon2dout}_${yyyy}.nc
cp ${IFStemp}/albsrf_${aermon2d}_${yyyy}.nc  ${outdir}/albsrf_crescendo_${aermon2dout}_${yyyy}.nc
cp ${IFStemp}/pr_${aermon2d}_${yyyy}.nc  ${outdir}/pr_crescendo_${aermon2dout}_${yyyy}.nc
#SH
cp ${IFStemp}/ps_${aermon2d}_${yyyy}.nc  ${outdir}/ps_crescendo_${aermon2dout}_${yyyy}.nc
    #aer6hr-2d
#cdo  -t ecmwf -f nc  uas_${aer6hr2d}_${yyyy}.nc
#cdo -t ecmwf -f nc  vas_${aer6hr2d}_${yyyy}.nc
cp   ${IFStemp}/uas_${aer6hr}_${yyyy}.nc  ${outdir}/uas_crescendo_${aer6hrout}_${yyyy}.nc
cp   ${IFStemp}/vas_${aer6hr}_${yyyy}.nc  ${outdir}/vas_crescendo_${aer6hrout}_${yyyy}.nc

cp ${IFStemp}/clt_${aer6hr}_${yyyy}.nc ${outdir}/clt_crescendo_${aer6hrout}_${yyyy}.nc    #aerdaily-2d


cp ${IFStemp}/tas_${aerday2d}_${yyyy}.nc  ${outdir}/tas_crescendo_${aerday2dout}_${yyyy}.nc
cp ${IFStemp}/tasmax_${aerday2d}_${yyyy}.nc   ${outdir}/tasmax_crescendo_${aerday2dout}_${yyyy}.nc
cp ${IFStemp}/tasmin_${aerday2d}_${yyyy}.nc  ${outdir}/tasmin_crescendo_${aerday2dout}_${yyyy}.nc
cp ${IFStemp}/pr_${aerday2d}_${yyyy}.nc  ${outdir}/pr_crescendo_${aerday2dout}_${yyyy}.nc
cp ${IFStemp}/sfsh_${aerday2d}_${yyyy}.nc ${outdir}/sfsh_crescendo_${aerday2dout}_${yyyy}.nc
cp ${IFStemp}/ps_${aerday2d}_${yyyy}.nc     ${outdir}/ps_crescendo_${aerday2dout}_${yyyy}.nc    


    #aermon-3d
cp ${IFStemp}/clt_${aermon3d}_${yyyy}.nc ${outdir}/clt_crescendo_${aermon3dout}_${yyyy}.nc
cp ${IFStemp}/cdnc_${aermon3d}_${yyyy}.nc ${outdir}/cdnc_crescendo_${aermon3dout}_${yyyy}.nc


#SH file
cp ${IFStemp}/ua_${aermon3d}_${yyyy}.nc ${outdir}/ua_crescendo_${aermon3dout}_${yyyy}.nc
cp ${IFStemp}/va_${aermon3d}_${yyyy}.nc ${outdir}/va_crescendo_${aermon3dout}_${yyyy}.nc
cp ${IFStemp}/wa_${aermon3d}_${yyyy}.nc ${outdir}/wa_crescendo_${aermon3dout}_${yyyy}.nc
cp ${IFStemp}/areacella_AERfx_${yyyy}.temp.nc ${outdir}/areacella_crescendo_${aerfxout}_${yyyy}.nc

echo "*II* remove intermediate files from ifstemp: ${IFStemp} for year ${yyyy}"
rm -f ${IFStemp}/*${yyyy}*

# copy remaining TM5 data to outputdir + make tarball
./output-copy.sh ${runid} ${yyyy}


