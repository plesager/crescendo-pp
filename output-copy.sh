#!/bin/bash
set -ex

usage()
{
   echo "Usage:"
   echo "       ${0##*/} EXP YEAR"
   echo
   echo " Process TM5 data (mainly copy) and make tarball of all"
   echo "  results (IFS + TM5) for year YEAR of experiment EXP."
}

# Experiment id, model year
runid=$1
yyyy=$2

# final output dir (inc. tarfile)
basepath=${SCRATCH}/CRESCENDO

# gather directory
outdir=${basepath}/amip-${runid}-${yyyy}
mkdir -p ${outdir}

# directory name fo raw model output
year0=$(head -5 ${SCRATCH}/ECEARTH-RUNS/${runid}/ece.info |tail -1|cut -b 29-32)
temp=$((yyyy-year0+1))
leg=`printf %03d $temp`

echo "*II* Start TM5 data processing for leg $leg of experiment ${runid}"

datapath=${SCRATCH}/ECEARTH-RUNS/${runid}/output/tm5/${leg}

# --- TM5 ---
#mon2d
cp ${datapath}/ptp_AERmon_* ${outdir}/
cp ${datapath}/tatp_AERmon_* ${outdir}/
cp ${datapath}/ztp_AERmon_* ${outdir}/
cp ${datapath}/bldep_AERmon_* ${outdir}/
cp ${datapath}/pr_AERmon_* ${outdir}/
cp ${datapath}/ps_AERmon_* ${outdir}/
#cp ${datapath}/lai_AERmon_* ${outdir}/
#cp ${datapath}/cnpz_AERmon_* ${outdir}/
#cp ${datapath}/snc_AERmon_* ${outdir}/
cp ${datapath}/toz_AERmon_* ${outdir}/
cp ${datapath}/tropoz_AERmon_* ${outdir}/
cp ${datapath}/dryo3_AERmon_* ${outdir}/
cp ${datapath}/od550aer_AERmon_* ${outdir}/
cp ${datapath}/od870aer_AERmon_* ${outdir}/
cp ${datapath}/od440aer_AERmon_* ${outdir}/
cp ${datapath}/od550so4_AERmon_* ${outdir}/
cp ${datapath}/od550bc_AERmon_* ${outdir}/
cp ${datapath}/od550oa_AERmon_* ${outdir}/
cp ${datapath}/od550soa_AERmon_* ${outdir}/
cp ${datapath}/od550no3_AERmon_* ${outdir}/
cp ${datapath}/od550ss_AERmon_* ${outdir}/
cp ${datapath}/od550dust_AERmon_* ${outdir}/
cp ${datapath}/od550aerh2o_AERmon_* ${outdir}/
#cp ${datapath}/emioa_AERmon_* ${outdir}/

#add emioa and chepsoa into temp file
cdo merge ${datapath}/emioa_AERmon_EC-Earth3-AerChem_${runid}_r1i1p1f1_gn_${yyyy}01-${yyyy}12.nc  ${datapath}/chepsoa_AERmon_EC-Earth3-AerChem_${runid}_r1i1p1f1_gn_${yyyy}01-${yyyy}12.nc ${basepath}/${runid}.emioa.temp.aermon.${yyyy}.nc
# do sum of emioa and chepsoa as per data request
cdo expr,'emioa=emioa+chepsoa;' ${basepath}/${runid}.emioa.temp.aermon.${yyyy}.nc ${outdir}/emioa_AERmon_EC-Earth3-AerChem_${runid}_r1i1p1f1_gn_${yyyy}01-${yyyy}12.nc
# remove temp file
rm -f ${basepath}/${runid}.emioa.temp.aermon.${yyyy}.nc

#cp ${datapath}/wetoa_AERmon_* ${outdir}/

#add wetoa and chepsoa into temp file
cdo merge ${datapath}/wetoa_AERmon_EC-Earth3-AerChem_${runid}_r1i1p1f1_gn_${yyyy}01-${yyyy}12.nc  ${datapath}/wetsoa_AERmon_EC-Earth3-AerChem_${runid}_r1i1p1f1_gn_${yyyy}01-${yyyy}12.nc ${basepath}/${runid}.wetoa.temp.aermon.${yyyy}.nc
# do sum of wetoa and chepsoa as per data request
cdo expr,'wetoa=wetoa+wetsoa;' ${basepath}/${runid}.wetoa.temp.aermon.${yyyy}.nc ${outdir}/wetoa_AERmon_EC-Earth3-AerChem_${runid}_r1i1p1f1_gn_${yyyy}01-${yyyy}12.nc
# remove temp file
rm -f ${basepath}/${runid}.wetoa.temp.aermon.${yyyy}.nc
#add dryoa and chepsoa into temp file
cdo merge ${datapath}/dryoa_AERmon_EC-Earth3-AerChem_${runid}_r1i1p1f1_gn_${yyyy}01-${yyyy}12.nc  ${datapath}/drysoa_AERmon_EC-Earth3-AerChem_${runid}_r1i1p1f1_gn_${yyyy}01-${yyyy}12.nc ${basepath}/${runid}.dryoa.temp.aermon.${yyyy}.nc
# do sum of dryoa and chepsoa as per data request
cdo expr,'dryoa=dryoa+drysoa;' ${basepath}/${runid}.dryoa.temp.aermon.${yyyy}.nc ${outdir}/dryoa_AERmon_EC-Earth3-AerChem_${runid}_r1i1p1f1_gn_${yyyy}01-${yyyy}12.nc
# remove temp file
rm -f ${basepath}/${runid}.dryoa.temp.aermon.${yyyy}.nc

#cp ${datapath}/dryoa_AERmon_* ${outdir}/
cp ${datapath}/emiso2_AERmon_* ${outdir}/
cp ${datapath}/emiso4_AERmon_* ${outdir}/
cp ${datapath}/emidms_AERmon_* ${outdir}/
cp ${datapath}/dryso2_AERmon_* ${outdir}/
cp ${datapath}/dryso4_AERmon_* ${outdir}/
cp ${datapath}/wetso4_AERmon_* ${outdir}/
cp ${datapath}/wetso2_AERmon_* ${outdir}/
cp ${datapath}/eminh3_AERmon_* ${outdir}/
cp ${datapath}/drynh3_AERmon_* ${outdir}/
cp ${datapath}/drynh4_AERmon_* ${outdir}/
cp ${datapath}/wetnh4_AERmon_* ${outdir}/
cp ${datapath}/wetnh3_AERmon_* ${outdir}/
cp ${datapath}/eminox_AERmon_* ${outdir}/
#cp ${datapath}/emianox_AERmon_* ${outdir}/
cp ${datapath}/drynoy_AERmon_* ${outdir}/
cp ${datapath}/wetnoy_AERmon_* ${outdir}/
cp ${datapath}/emiss_AERmon_* ${outdir}/
cp ${datapath}/dryss_AERmon_* ${outdir}/
cp ${datapath}/wetss_AERmon_* ${outdir}/
cp ${datapath}/emidust_AERmon_* ${outdir}/
cp ${datapath}/drydust_AERmon_* ${outdir}/
cp ${datapath}/wetdust_AERmon_* ${outdir}/
cp ${datapath}/emico_AERmon_* ${outdir}/
#cp ${datapath}/emibvoc_AERmon_* ${outdir}/
cp ${datapath}/emiisop_AERmon_* ${outdir}/
cp ${datapath}/albsrfc_AERmon_* ${outdir}/

cp ${datapath}/dryno3_AERmon_* ${outdir}/

#aer6hr3d
#cp ${datapath}/bs550aer_AERmon_* ${outdir}/
cp ${datapath}/ec550aer_AER6hr* ${outdir}/


#aer6hr2d
cdo merge ${datapath}/emioa_crescendo_AER6hr_EC-Earth3-AerChem_${runid}_r1i1p1f1_gn_${yyyy}01010000-${yyyy}12311800.nc  ${datapath}/chepsoa2d_crescendo_AER6hr_EC-Earth3-AerChem_${runid}_r1i1p1f1_gn_${yyyy}01010000-${yyyy}12311800.nc ${basepath}/${runid}.emioa.temp.${yyyy}.nc
# do sum of emioa and chepsoa as per data request
cdo expr,'emioa=emioa+chepsoa2d;' ${basepath}/${runid}.emioa.temp.${yyyy}.nc ${outdir}/emioa_AER6hr_EC-Earth3-AerChem_${runid}_r1i1p1f1_gn_${yyyy}01010000-${yyyy}12311800.nc
# remove temp file
rm -f ${basepath}/${runid}.emioa.temp.${yyyy}.nc

#hour2d
cp ${datapath}/ps_AERhr* ${outdir}/
cp ${datapath}/tas_AERhr* ${outdir}/
cp ${datapath}/sfo3_AERhr* ${outdir}/
cp ${datapath}/sfpm25_AERhr* ${outdir}/
cp ${datapath}/sfno2_AERhr* ${outdir}/

#day3d
#cp ${datapath}/co_AERday* ${outdir}/
#cp ${datapath}/od5503ddust_AERday* ${outdir}/

#day2d
cp ${datapath}/sfo3max_AERday* ${outdir}/
cp ${datapath}/tas_AERday* ${outdir}/
#missing ps
#cp ${datapath}/ps_AERday* ${outdir}/
cdo daymean  ${datapath}/ps_AERhr_EC-Earth3-AerChem_${runid}_r1i1p1f1_gn_${yyyy}01010000-${yyyy}12312359.nc  ${outdir}/ps_AERday_EC-Earth3-AerChem_${runid}_r1i1p1f1_gn_${yyyy}0101-${yyyy}1231.nc
cp ${datapath}/tasmin_AERday* ${outdir}/
cp ${datapath}/tasmax_AERday* ${outdir}/
cp ${datapath}/pr_AERday* ${outdir}/


#mon3d
cp ${datapath}/pfull_AERmon_* ${outdir}/
cp ${datapath}/phalf_AERmon_* ${outdir}/
cp ${datapath}/ta_AERmon_* ${outdir}/
cp ${datapath}/hus_AERmon_* ${outdir}/
cp ${datapath}/zg_AERmon_* ${outdir}/
cp ${datapath}/ua_AERmon_* ${outdir}/
cp ${datapath}/va_AERmon_* ${outdir}/
cp ${datapath}/wa_AERmon_* ${outdir}/
cp ${datapath}/o3_AERmon_* ${outdir}/
cp ${datapath}/o3ste_AERmon_* ${outdir}/
cp ${datapath}/ch4_AERmon_* ${outdir}/
#cp ${datapath}/co2_AERmon_* ${outdir}/
cp ${datapath}/co_AERmon_* ${outdir}/
cp ${datapath}/no2_AERmon_* ${outdir}/
cp ${datapath}/no_AERmon_* ${outdir}/
cp ${datapath}/oh_AERmon_* ${outdir}/
cp ${datapath}/mmrpm10_AERmon_* ${outdir}/
cp ${datapath}/mmrpm2p5_AERmon_* ${outdir}/

#cp ${datapath}/photo1d_AERmon_* ${outdir}/
cp ${datapath}/jno2_AERmon_* ${outdir}/
cp ${datapath}/airmass_AERmon_* ${outdir}/
cp ${datapath}/mmraerh2o_AERmon_* ${outdir}/
cp ${datapath}/mmroa_AERmon_* ${outdir}/
cp ${datapath}/mmrsoa_AERmon_* ${outdir}/
cp ${datapath}/mmrbc_AERmon_* ${outdir}/
cp ${datapath}/mmrso4_AERmon_* ${outdir}/
cp ${datapath}/mmrno3_AERmon_* ${outdir}/
cp ${datapath}/mmrnh4_AERmon_* ${outdir}/
cp ${datapath}/mmrss_AERmon_* ${outdir}/
cp ${datapath}/mmrdust_AERmon_* ${outdir}/
cp ${datapath}/so2_AERmon_* ${outdir}/
#molecweight wrong nacl instead of isop
#multiply with xmnacl/xmisop
cp ${datapath}/isop_AERmon_* ${outdir}/

cp ${datapath}/hcho_AERmon_* ${outdir}/
cp ${datapath}/dms_AERmon_* ${outdir}/
cp ${datapath}/hno3_AERmon_* ${outdir}/
cp ${datapath}/pan_AERmon_* ${outdir}/
cp ${datapath}/emilnox_AERmon_* ${outdir}/
cp ${datapath}/chegpso4_AERmon_* ${outdir}/
cp ${datapath}/cheaqpso4_AERmon_* ${outdir}/
cp ${datapath}/o3prod_AERmon_* ${outdir}/
cp ${datapath}/o3loss_AERmon_* ${outdir}/
#missing in crescendo branch
cp ${datapath}/lossch4_AERmon_* ${outdir}/
#fixed only available at the start of the run

cp  ${datapath}/areacella_AERfx_* ${outdir}/
cp  ${datapath}/sftlf_AERfx_* ${outdir}/
cp  ${datapath}/orog_AERfx_* ${outdir}/



cp ${datapath}/*_crescendo_* ${outdir}/

#Change the name 
cdo  expr,'chepsoa=chepsoa3d;' ${datapath}/chepsoa3d_crescendo_AERmon_EC-Earth3-AerChem_${runid}_r1i1p1f1_gn_${yyyy}01-${yyyy}12.nc  ${outdir}/chepsoa_crescendo_AERmon_EC-Earth3-AerChem_${runid}_r1i1p1f1_gn_${yyyy}01-${yyyy}12.nc 
#cp ${datapath}/chepsoa
rm  -f ${outdir}/co2mass_cre*
rm  -f ${outdir}/chepsoa3d_cre*
# not needed in the request, from earlier version...
rm  -f ${outdir}/chepsoa2d_cre*
cd ${basepath}


# remove 'crescendo' from output file names
for i in amip-${runid}-${yyyy}/*_crescendo_*
do
    mv $i ${i/_crescendo_/_}
done

tar vfcz amip-${runid}-${yyyy}.tar.gz amip-${runid}-${yyyy}

##
#if [ ${yyyy} -ge "2000" ] 
#then
#JASMINPATH
JASMIN=bergmant@jasmin-xfer1.ceda.ac.uk
JASMINPATH=/group_workspaces/jasmin2/crescendo/bergmant/
#scp amip-${runid}-${yyyy}.tar.gz ${JASMIN}:${JASMINPATH}
#fi
#rm -f amip-${runid}-${yyyy}.tar.gz
cd -
#set +x
#/perm/ms/nl/nktb/ece3-raw-backup/sub_ece3_bckp.sh ${runid} ${leg}
#set -x
