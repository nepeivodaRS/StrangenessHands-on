#!/bin/bash
# log file where the terminal output will be saved
STEP="step0"
LOGFILE="log-${STEP}.txt"

# directory of this script
DIR_THIS="$(dirname "$(realpath "$0")")"

OPTION="-b --configuration json:/$DIR_THIS/jsonConfig/$STEP.json"
#OPTION="-b --aod-file /Users/rnepeiv/workLund/PhD_work/run3omega/data/used_in_analysis_note/29aug_localGT_anchored/user/r/rnepeivo/strange_prod/forthcoming/526641/556/AO2D.root"

o2-analysis-timestamp ${OPTION} \
| o2-analysis-event-selection ${OPTION} \
| o2-analysis-bc-converter ${OPTION} \
| o2-analysis-tracks-extra-converter  ${OPTION} \
| o2-analysis-lf-lambdakzerobuilder ${OPTION} \
| o2-analysistutorial-lf-strangeness-$STEP ${OPTION} \
> "$LOGFILE" 2>&1

# report status
rc=$?
if [ $rc -eq 0 ]; then
  echo "No problems!"
  mkdir -p "$DIR_THIS/results/$STEP"
  mv "AnalysisResults.root" "$DIR_THIS/results/$STEP/AnalysisResults.root"
  mv "dpl-config.json" "$DIR_THIS/jsonConfig/$STEP.json"
else
  echo "Error: Exit code $rc"
  echo "Check the log file $LOGFILE"
  exit $rc
fi
