#!/usr/bin/env bash

usage()
{
   echo "Usage:"
   echo "       ${0##*/} [-a ACCOUNT] [-m] EXP YEAR"
   echo
   echo " Submit chain of CRESCENDO post-processing jobs,"
   echo "  for one YEAR of data for experiment EXP"
   echo
   echo "Options are:"
   echo "   -a ACCOUNT  : specify a different special project for accounting (default: ${ECE3_POSTPROC_ACCOUNT:-unknown})"
   echo "   -m          : use if EC-Earth is run in monthly chunks, and"
   echo "                  needs to be converted to a yearly run first."
   echo
   echo "                 ** THE -m OPTION WORKS ONLY FOR 2-YEAR SIMULATIONS **"
   echo "                 **    and can only be used ONCE for a given EXP    **"
}

set -eu

convert=0
account="${ECE3_POSTPROC_ACCOUNT-}"

# -- options
while getopts "hma:" opt; do
    case "$opt" in
        h)
            usage
            exit 0
            ;;
        a)  account=$OPTARG
            ;;
        m)  convert=1
            ;;
        *)  usage
            exit 1
    esac
done
shift $((OPTIND-1))

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

runid=$1
year=$2

# -- Scratch dir (created scripts, logs)
OUT=$SCRATCH/tmp_crescendo_pp
mkdir -p $OUT/log

# --- Create the scripts and submit ---

#- MM2YYYY conversion
cnv_script=$OUT/mm2yyyy.${runid}.${year}.job
dependency=

if (( convert ))
then
    sed -e "s|<RUNID>|${runid}|g" \
        -e "s|<TEMP>|$OUT|g" \
        <mm2yyyy_leg.sh.tmpl >$cnv_script

    [[ -n $account ]] && \
        sed -i "s/<ACCOUNT>/$account/" $cnv_script || \
        sed -i "/<ACCOUNT>/ d" $cnv_script

    dependency=$(qsub $cnv_script)
    printf "\n\tSubmitted mm2yyyy conversion script\n"
fi

#- IFS post-processing
first_script=$OUT/pp_ifs_monthly.${runid}.${year}.job

sed -e "s|yyyy|${year}|g" \
    -e "s|idid|${runid}|g" \
    -e "s|<TEMP>|$OUT|g" \
    <pp_ifs_monthly_auto.job.tmpl >$first_script

[[ -n $dependency ]] && \
    sed -i "s/<DEPENDENCY>/$dependency/" $first_script || \
    sed -i "/<DEPENDENCY>/ d" $first_script

[[ -n $account ]] && \
    sed -i "s/<ACCOUNT>/$account/" $first_script || \
    sed -i "/<ACCOUNT>/ d" $first_script


#- second job triggered by first one
snd_script=$OUT/pp_ifs+tm5_merge_copy.${runid}.${year}.job

sed -e "s|yyyy|${year}|g" \
    -e "s|idid|${runid}|g" \
    -e "s|<TEMP>|$OUT|g" \
    <pp_ifs+tm5_merge_copy_auto.job.tmpl >${snd_script}

[[ -n $account ]] && \
    sed -i "s/<ACCOUNT>/$account/" $snd_script || \
    sed -i "/<ACCOUNT>/ d" $snd_script


qsub $first_script
