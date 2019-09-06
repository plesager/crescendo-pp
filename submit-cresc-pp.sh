#!/usr/bin/env bash

usage()
{
   echo "Usage:"
   echo "       ${0##*/} EXP YEAR"
   echo
   echo " CRESCENDO post-processing: one YEAR of data for experiment EXP"
}

# -- Check arguments
if [ $# -ne 2 ]; then
   usage
   exit 1
fi

if [[ ! $1 =~ ^[a-zA-Z0-9_]{4}$ ]]
then
    echo; echo "*EE* argument EXP (=$1) should be a 4-letter string"; echo
    usage
    exit 1
fi

if [[ ! $2 =~ ^[0-9]{4}$ ]]
then
    printf "\n\targument YEAR (=$2) should be a 4-digit integer\n\n"
    usage
    exit 1
fi

# -- Scratch dir (created scripts, logs)
OUT=$SCRATCH/tmp_crescendo_pp
mkdir -p $OUT/log

# -- Create the scripts and submit
runid=$1
year=$2

first_script=$OUT/pp_ifs_monthly.${runid}.${year}.job 

sed -e "s|yyyy|${year}|g" \
    -e "s|idid|${runid}|g" \
    <pp_ifs_monthly_auto.job.tmpl >$first_script

sed -i "s|<TEMP>|$OUT|g" $first_script

snd_script=$OUT/pp_ifs+tm5_merge_copy.${runid}.${year}.job 

sed -e "s|yyyy|${year}|g" \
    -e "s|idid|${runid}|g" \
    <pp_ifs+tm5_merge_copy_auto.job.tmpl >${snd_script}

sed -i "s|<TEMP>|$OUT|g" ${snd_script}

qsub $first_script
