#!/bin/bash
set -ex
# figure out how to retrieve start year from ece.info
runid=$1

month=$(printf %02d $2)
echo 'processing month ' $month

year=$3
name="CRESCENDO"

cd ${SCRATCH}/ECEARTH-RUNS/${runid}/

year0=$(head -5 ${SCRATCH}/ECEARTH-RUNS/${runid}/ece.info |tail -1|cut -b 29-32)
temp=$((year-year0+1))
leg=`printf %03d $temp`
echo "running leg ${temp} ${leg}"

#runid="crsp"

basepath=${SCRATCH}/CRESCENDO
#outdir=${basepath}/amip-pd-${yyyy}
datapath=${SCRATCH}/ECEARTH-RUNS/${runid}/output/ifs/${leg}

IFStemp=${basepath}/ifstemp/${runid}/

aermon3d='AERmon'
aerday2d='AERday'
aermon2d='AERmon'
aer6hr='AER6hr'

exp=$runid
#'crsp'



#outdir=${IFStemp}${year}
mkdir -p ${IFStemp}
#clear data for currently processed month 
rm -f ${IFStemp}/*_${year}${month}.nc
rm -f ${MONTHFStemp}/*_${year}${month}.mm.nc

#cdo -t ecmwf -R splitzaxis -setreftime,1750-1-1,00:00:00,days -shifttime,-6hour ${datapath}/ICMGG${exp}+${year}${month} ${IFStemp}/ICMGG${exp}_${year}${month}_split
#cdo -t ecmwf -R splitzaxis  -setreftime,1750-1-1,00:00:00,days  -shifttime,-6hour  ${datapath}/ICMSH${exp}+${year}${month} ${IFStemp}/ICMSH${exp}_${year}${month}_split
cdo -t ecmwf -R splitzaxis ${datapath}/ICMGG${exp}+${year}${month} ${IFStemp}/ICMGG${exp}_${year}${month}_split
cdo -t ecmwf -R splitzaxis ${datapath}/ICMSH${exp}+${year}${month} ${IFStemp}/ICMSH${exp}_${year}${month}_split

    #aermon-2d
cdo  -t ecmwf -f nc4 -R expr,"tos=SSTK;" -setreftime,1750-1-1,00:00:00,days -shifttime,-6hour ${IFStemp}/ICMGG${exp}_${year}${month}_split01.grb ${IFStemp}/tos_${aermon2d}_${year}${month}.nc
cdo  -t ecmwf -f nc4 -R expr,"sic=CI;" -setreftime,1750-1-1,00:00:00,days -shifttime,-6hour ${IFStemp}/ICMGG${exp}_${year}${month}_split01.grb  ${IFStemp}/sic_${aermon2d}_${year}${month}.nc
# upward part is  STR-STRD,but here the convention is down positive, CMIPoutput requires upwards positive
# -> rlus=-(STR-STRD)
cdo -t ecmwf -f nc4 -R expr,"rlus=-(STR-STRD)/(6.0*3600.0);" -setreftime,1750-1-1,00:00:00,days -shifttime,-6hour ${IFStemp}/ICMGG${exp}_${year}${month}_split01.grb ${IFStemp}/rlus_${aermon2d}_${year}${month}.nc
# upward part is  SSR-SSRD,but here the convention is down positive, CMIPoutput requires upwards positive
# -> rsus=-(SSR-SSRD)
cdo -t ecmwf -f nc4 -R expr,"rsus=-(SSR-SSRD)/(6.0*3600.0);" -setreftime,1750-1-1,00:00:00,days -shifttime,-6hour ${IFStemp}/ICMGG${exp}_${year}${month}_split01.grb ${IFStemp}/rsus_${aermon2d}_${year}${month}.nc

cdo -t ecmwf -f nc4 -R expr,"rsds=SSRD/(6.0*3600.0);" -setreftime,1750-1-1,00:00:00,days -shifttime,-6hour ${IFStemp}/ICMGG${exp}_${year}${month}_split01.grb ${IFStemp}/rsds_${aermon2d}_${year}${month}.nc
cdo  -t ecmwf -f nc4 -R expr,"rlds=STRD/(6.0*3600.0);" -setreftime,1750-1-1,00:00:00,days -shifttime,-6hour ${IFStemp}/ICMGG${exp}_${year}${month}_split01.grb ${IFStemp}/rlds_${aermon2d}_${year}${month}.nc
# SI-TSR(C)  
cdo  -t ecmwf -f nc4 -R expr,"rsutcs=(SI-TSRC)/(6.0*3600.0);" -setreftime,1750-1-1,00:00:00,days -shifttime,-6hour ${IFStemp}/ICMGG${exp}_${year}${month}_split01.grb ${IFStemp}/rsutcs_${aermon2d}_${year}${month}.nc
cdo  -t ecmwf -f nc4 -R expr,"rsut=(SI-TSR)/(6.0*3600.0);" -setreftime,1750-1-1,00:00:00,days -shifttime,-6hour ${IFStemp}/ICMGG${exp}_${year}${month}_split01.grb ${IFStemp}/rsut_${aermon2d}_${year}${month}.nc
# down is positive for TTRC and TTR, Upwards positive for CMIP6 -> -TTRC, -TTR
cdo  -t ecmwf -f nc4 -R expr,"rlutcs=-TTRC/(6.0*3600.0);" -setreftime,1750-1-1,00:00:00,days -shifttime,-6hour ${IFStemp}/ICMGG${exp}_${year}${month}_split01.grb ${IFStemp}/rlutcs_${aermon2d}_${year}${month}.nc
cdo  -t ecmwf -f nc4 -R expr,"rlut=-TTR/(6.0*3600.0);" -setreftime,1750-1-1,00:00:00,days -shifttime,-6hour ${IFStemp}/ICMGG${exp}_${year}${month}_split01.grb ${IFStemp}/rlut_${aermon2d}_${year}${month}.nc

cdo  -t ecmwf -f nc4 -R expr,"uas=U10M;" -setreftime,1750-1-1,00:00:00,days -shifttime,-6hour ${IFStemp}/ICMGG${exp}_${year}${month}_split01.grb ${IFStemp}/uas_${aermon2d}_${year}${month}.nc
cdo -t ecmwf -f nc4 -R expr,"vas=V10M;" -setreftime,1750-1-1,00:00:00,days -shifttime,-6hour ${IFStemp}/ICMGG${exp}_${year}${month}_split01.grb ${IFStemp}/vas_${aermon2d}_${year}${month}.nc
cdo -t ecmwf -f nc4 -R expr,"sfcWind=sqrt(V10M*V10M+U10M*U10M);" -setreftime,1750-1-1,00:00:00,days -shifttime,-6hour ${IFStemp}/ICMGG${exp}_${year}${month}_split01.grb ${IFStemp}/sfcWind_${aermon2d}_${year}${month}.nc
cdo -t ecmwf -f nc4 -R expr,"albsrfc=FAL;" -setreftime,1750-1-1,00:00:00,days -shifttime,-6hour ${IFStemp}/ICMGG${exp}_${year}${month}_split01.grb ${IFStemp}/albsrf_${aermon2d}_${year}${month}.nc
cdo -t ecmwf -f nc4 -R expr,"pr=LSP+CP;" -setreftime,1750-1-1,00:00:00,days -shifttime,-6hour ${IFStemp}/ICMGG${exp}_${year}${month}_split01.grb ${IFStemp}/pr_${aermon2d}_${year}${month}.nc
#SH
cdo -t ecmwf -f nc4 -R expr,"ps=exp(LNSP);" -setreftime,1750-1-1,00:00:00,days -shifttime,-6hour -sp2gp ${IFStemp}/ICMSH${exp}_${year}${month}_split04.grb  ${IFStemp}/ps_${aermon2d}_${year}${month}.nc
    #aer6hr-2d
cdo  -t ecmwf -f nc4 -R expr,"uas=U10M;" -setreftime,1750-1-1,00:00:00,days -shifttime,-6hour ${IFStemp}/ICMGG${exp}_${year}${month}_split01.grb ${IFStemp}/uas_${aer6hr}_${year}${month}.nc
cdo -t ecmwf -f nc4 -R expr,"vas=V10M;" -setreftime,1750-1-1,00:00:00,days -shifttime,-6hour ${IFStemp}/ICMGG${exp}_${year}${month}_split01.grb ${IFStemp}/vas_${aer6hr}_${year}${month}.nc
#aer6hr-3d
cdo -t ecmwf -f nc4 -R expr,"clt=CC;" -setreftime,1750-1-1,00:00:00,days -shifttime,-6hour ${IFStemp}/ICMGG${exp}_${year}${month}_split07.grb ${IFStemp}/clt_${aer6hr}_${year}${month}.nc

    #aerdaily-2d
cdo -t ecmwf -f nc4 -R expr,"tas=T2M;" -setreftime,1750-1-1,00:00:00,days -shifttime,-6hour ${IFStemp}/ICMGG${exp}_${year}${month}_split01.grb ${IFStemp}/tas_${aerday2d}_${year}${month}.nc
cdo -t ecmwf -f nc4 -R expr,"tasmax=MX2T;" -setreftime,1750-1-1,00:00:00,days -shifttime,-6hour ${IFStemp}/ICMGG${exp}_${year}${month}_split01.grb ${IFStemp}/tasmax_${aerday2d}_${year}${month}.nc
cdo -t ecmwf -f nc4 -R expr,"tasmax=MN2T;" -setreftime,1750-1-1,00:00:00,days -shifttime,-6hour ${IFStemp}/ICMGG${exp}_${year}${month}_split01.grb ${IFStemp}/tasmin_${aerday2d}_${year}${month}.nc
cdo -t ecmwf -f nc4 -R expr,"precip=LSP+CP;" -setreftime,1750-1-1,00:00:00,days -shifttime,-6hour ${IFStemp}/ICMGG${exp}_${year}${month}_split01.grb ${IFStemp}/pr_${aerday2d}_${year}${month}.nc
cdo -t ecmwf -f nc4 -R expr,"sfsh=Q;" -setreftime,1750-1-1,00:00:00,days -shifttime,-6hour -sellevel,91 ${IFStemp}/ICMGG${exp}_${year}${month}_split07.grb ${IFStemp}/sfsh_${aerday2d}_${year}${month}.nc
cdo -t ecmwf -f nc4 expr,"ps=exp(LNSP);" -setreftime,1750-1-1,00:00:00,days -shifttime,-6hour -sp2gp ${IFStemp}/ICMSH${exp}_${year}${month}_split04.grb  ${IFStemp}/ps_${aerday2d}_${year}${month}.nc    
    #aermon-3d
cdo -t ecmwf -f nc4 -R expr,"clt=CC;" -setreftime,1750-1-1,00:00:00,days -shifttime,-6hour ${IFStemp}/ICMGG${exp}_${year}${month}_split07.grb ${IFStemp}/clt_${aermon3d}_${year}${month}.nc
#OBSOLETE cdo -t ecmwf -f nc4 -R expr,"cdnc=var101/var105;" -setreftime,1750-1-1,00:00:00,days -shifttime,-6hour ${IFStemp}/ICMGG${exp}_${year}${month}_split07.grb ${IFStemp}/cdnc_${aermon3d}_${year}${month}.nc

    # CDNC and Liquid Cloud Time from EC-Earth grib table (126)
cdo select,param=20.126 ${IFStemp}/ICMGG${exp}_${year}${month}_split07.grb ${IFStemp}/${exp}_${year}${month}_CDNC.grb
cdo select,param=22.126 ${IFStemp}/ICMGG${exp}_${year}${month}_split07.grb ${IFStemp}/${exp}_${year}${month}_LQCT.grb
cdo div ${IFStemp}/${exp}_${year}${month}_CDNC.grb ${IFStemp}/${exp}_${year}${month}_LQCT.grb ${IFStemp}/${exp}_${year}${month}_CdivL.grb
cdo -f nc4 -R setname,'cdnc' -setreftime,1750-1-1,00:00:00,days -shifttime,-6hour  ${IFStemp}/${exp}_${year}${month}_CdivL.grb ${IFStemp}/cdnc_${aermon3d}_${year}${month}.nc

rm -f ${IFStemp}/${exp}_${year}${month}_CdivL.grb ${IFStemp}/${exp}_${year}${month}_CDNC.grb ${IFStemp}/${exp}_${year}${month}_LQCT.grb 

#SH file
cdo -t ecmwf -f nc4 expr,"ua=U;" -setreftime,1750-1-1,00:00:00,days -shifttime,-6hour -sp2gp ${IFStemp}/ICMSH${exp}_${year}${month}_split03.grb ${IFStemp}/ua_${aermon3d}_${year}${month}.nc
cdo -t ecmwf -f nc4 expr,"va=V;" -setreftime,1750-1-1,00:00:00,days -shifttime,-6hour -sp2gp ${IFStemp}/ICMSH${exp}_${year}${month}_split03.grb ${IFStemp}/va_${aermon3d}_${year}${month}.nc
cdo -t ecmwf -f nc4 expr,"wa=Z;" -setreftime,1750-1-1,00:00:00,days -shifttime,-6hour -sp2gp ${IFStemp}/ICMSH${exp}_${year}${month}_split03.grb ${IFStemp}/wa_${aermon3d}_${year}${month}.nc
if [ ${month} -eq "01" ]; then
    cdo -t ecmwf -f nc4 -R gridarea ${IFStemp}/ICMGG${exp}_${year}01_split01.grb ${IFStemp}/areacella_AERfx_${year}.temp.nc
fi
#cdo -t ecmwf -f nc4 -R gridarea ${IFStemp}/ICMGG${exp}_${year}01_split01.grb ${IFStemp}/areacella_AERfx_${year}.nc
#rm -f *_${year}${month}.mm.nc

for varfile in ${IFStemp}/*_AERmon_${year}${month}.nc
do
    cdo monmean $varfile  ${IFStemp}/$(basename $varfile .nc).mm.nc

done 
for varfile in ${IFStemp}/*_AERday_${year}${month}.nc
do
    cdo daymean $varfile  ${IFStemp}/$(basename $varfile .nc).mm.nc

done 

