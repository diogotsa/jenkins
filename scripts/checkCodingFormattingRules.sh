#!/bin/bash

if [ $# -eq 0 ]
then
    NB_FILES_TO_FORMAT=`astyle --dry-run --options=scripts/astyle-options.txt --recursive *.c *.h | grep -c Formatted `
    echo "common/utils/itti/assertions.h openair1/PHY/LTE_UE_TRANSPORT/dlsch_demodulation.c openair1/SCHED_UE/phy_procedures_lte_ue.c openair1/SIMULATION/LTE_PHY/dlsim.c openair1/SIMULATION/LTE_PHY/ulsim.c openair2/ENB_APP/enb_config.c openair2/ENB_APP/flexran_agent_ran_api.c openair2/LAYER2/MAC/eNB_scheduler_phytest.c openair2/LAYER2/RLC/rlc.c openair2/RRC/LTE/rrc_eNB.c openair2/RRC/LTE/rrc_UE.c" > oai_warning_files_list.txt
    echo "Nb Files that do NOT follow OAI rules: $NB_FILES_TO_FORMAT"
    exit 0
fi

if [ $# -eq 2 ]
then
    # Merge request scenario

    SOURCE_BRANCH=$1
    echo "Source Branch  is : $SOURCE_BRANCH"

    TARGET_BRANCH=$2
    echo "Target Branch is  : $TARGET_BRANCH"

    MERGE_COMMMIT=`git log -n1 | grep commit | sed -e "s@commit @@"`
    echo "Merged Commit is  : $MERGE_COMMMIT"
    TARGET_INIT_COMMIT=`cat .git/refs/remotes/origin/$TARGET_BRANCH`
    echo "Target Init   is  : $TARGET_INIT_COMMIT"

    # Retrieve the list of modified files since the latest develop commit
    MODIFIED_FILES=`git log $TARGET_INIT_COMMIT..$MERGE_COMMMIT --oneline --name-status | egrep "^M|^A" | sed -e "s@^M\t*@@" -e "s@^A\t*@@" | sort | uniq`
    NB_TO_FORMAT=0
    for FULLFILE in $MODIFIED_FILES
    do
        echo $FULLFILE
        filename=$(basename -- "$FULLFILE")
        EXT="${filename##*.}"
        if [ $EXT = "c" ] || [ $EXT = "h" ] || [ $EXT = "cpp" ] || [ $EXT = "hpp" ]
        then
            TO_FORMAT=`astyle --dry-run --options=scripts/astyle-options.txt $FULLFILE | grep -c Formatted `
            NB_TO_FORMAT=$((NB_TO_FORMAT + TO_FORMAT))
        fi
    done
    echo "Nb Files that do NOT follow OAI rules: $NB_TO_FORMAT"
    echo $NB_TO_FORMAT > ./oai_rules_result.txt
    echo "common/utils/itti/assertions.h openair1/PHY/LTE_UE_TRANSPORT/dlsch_demodulation.c openair1/SCHED_UE/phy_procedures_lte_ue.c openair1/SIMULATION/LTE_PHY/dlsim.c openair1/SIMULATION/LTE_PHY/ulsim.c openair2/ENB_APP/enb_config.c openair2/ENB_APP/flexran_agent_ran_api.c openair2/LAYER2/MAC/eNB_scheduler_phytest.c openair2/LAYER2/RLC/rlc.c openair2/RRC/LTE/rrc_eNB.c openair2/RRC/LTE/rrc_UE.c" > oai_warning_files_list.txt

    exit 0
fi

if [ $# -ne 0 ] || [ $# -ne 2 ]
then
    echo "Syntax error: $0 without any option will check all files in repository"
    echo "          or: $0 source-branch target-branch"
    echo "              will only check files that are pushed for a merge-request"
    exit 1
fi
