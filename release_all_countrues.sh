#!/bin/bash

# Input environment and release numbers

echo " "
echo -e "Enter environment. \e[33mUAT\e[0m or \e[33mPROD\e[0m"
read ENV

if [ $ENV = UAT ] || [ $ENV = PROD ]
  then 
    echo " "
  else
    echo "Please enter correct environment"	  
    exit 1
fi

echo " "
echo -e "Enter zone according RunDeck/MP Manifest: \e[33ma\e[0m (A1, UAT), \e[33md\e[0m (F1, SIT), \e[33ms\e[0m (F2, STQA), \e[33me\e[0m (A2, UAT2), \e[33mp\e[0m (P1, PROD), \e[33mr\e[0m (R1, Preprod)"
read zone

if [ $zone = a ] || [ $zone = d ] || [ $zone = s ]  || [ $zone = e ] || [ $zone = p ] || [ $zone = r ]
  then
    echo " "
  else
    echo "Please enter correct zone"
    exit 1
fi

echo -e "Enter release number. For example \e[33m1.9.2.1\e[0m"
read release

echo " "
echo -e "Enter release number with "+". For example \e[33m1.9.2.1+6\e[0m"
read releaseplus

# Adding info about releases to manifest

cd ~/primark/manifest-marketplace/
echo "Working with repo"
pwd
echo " "
echo "git pull"
git pull
echo "Adding info about releases to manifest..."
echo "{{ emitnx_marketplace_release(R, '$releaseplus') }}" >> ~/primark/manifest-marketplace/marketplace/marketplace/releases-$zone.yaml
echo " "
echo "Pushing changes to git"
echo " "
git add .
git commit -m "$releaseplus release added"
git push

# Create profile template
cd ~/primark/profuse-settings/
echo " "
echo "Working with repo"
pwd
echo " "
echo "git pull"
git pull

cat << EOF > ./$ENV-XX-04-MARKETPLACE-$release
[40:Market Place application versions]

posserver.fjpkglist.pos[0001]=marketplace-pos-server=$releaseplus
posclient.fjpkglist.pos[0001]=marketplace-pos-till=$releaseplus
EOF

# Create arrays with zone names
declare -a co=("at" "be" "cz" "de" "es" "fr" "gb" "gr" "hu" "ie" "it" "nl" "pl" "pt" "ro" "si" "sk" "us")
declare -a CO=("AT" "BE" "CZ" "DE" "ES" "FR" "GB" "GR" "HU" "IE" "IT" "NL" "PL" "PT" "RO" "SI" "SK" "US")

# Copy profile to folder and rename it
echo " "
for i in {0..17};
do
  if [ $ENV = PROD ]	
    then 
    cp ./$ENV-XX-04-MARKETPLACE-$release ~/primark/profuse-settings/cmdb/profiles/${co[$i]}/prod/ &&
    mv ~/primark/profuse-settings/cmdb/profiles/${co[$i]}/prod/$ENV-XX-04-MARKETPLACE-$release ~/primark/profuse-settings/cmdb/profiles/${co[$i]}/prod/$ENV-${CO[$i]}-04-MARKETPLACE-$release && 
    echo -e "Profile \e[32m$ENV-${CO[$i]}-04-MARKETPLACE-$release\e[0m for \e[32m${CO[$i]}\e[0m successfully created"
  else
    cp ./$ENV-XX-04-MARKETPLACE-$release  ~/primark/profuse-settings/cmdb/profiles/${co[$i]}/uat/ && 
    mv  ~/primark/profuse-settings/cmdb/profiles/${co[$i]}/uat/$ENV-XX-04-MARKETPLACE-$release  ~/primark/profuse-settings/cmdb/profiles/${co[$i]}/uat/$ENV-${CO[$i]}-04-MARKETPLACE-$release &&
    echo -e "Profile \e[32m$ENV-${CO[$i]}-04-MARKETPLACE-$release\e[0m for \e[32m${CO[$i]}\e[0m successfully created"
  fi
done

rm $ENV-XX-04-MARKETPLACE-$release
echo " "

echo "Pushing changes to git"
echo " "
git add .
git commit -m "Profile $ENV-XX-04-MARKETPLACE-$release added for $ENV"
git push
