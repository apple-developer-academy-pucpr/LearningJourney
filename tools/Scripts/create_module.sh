# !/bin/sh


# Jump to repository root
cd "$(git rev-parse --show-toplevel)"

moduleName=$1
moduleType=$2

# Copy and enten on template folder
templatePath="tools/ModuleTemplate"

case "$moduleType" in
core) modulePath="LearningJourney/Modules/Core/${moduleName}" ;;
feature) modulePath="LearningJourney/Modules/Features/${moduleName}" ;;
*) echo "Module type must be either CORE or FEATURE"; exit 1 ;;
esac

cp -R "${templatePath}" "${modulePath}"


cd "${modulePath}"


# Rename module file and folder name templates
rename(){
  while read oldName
  do    
    newName=$(echo $oldName | sed "s/<module_name>/$moduleName/")
    mv "$oldName" "$newName"
  done
}

find . -type d -name "<module_name>*" | rename
find . -type f -name "<module_name>*" | rename

# Rename module content templates
find . ! -name ".*" -type f -exec sh -c "sed -i '' 's/<module_name>/$1/g' '{}'" \;

xcodegen

exit 1

# Integrate on project.yml
sed -i '' '1,/dependencies:/s/dependencies:/&\
      - framework: '"$moduleName"'.framework\
        implicit: true/' AppPicPay/project.yml

sed -i '' '1,/projectReferences:/s/projectReferences:/&\
  '"$moduleName"':\
    path: ..\/Modules\/'"$moduleName"'\/'"$moduleName"'.xcodeproj/' AppPicPay/project.yml

if [ "$moduleType" != interface ]
then
  sed -i '' '1,/coverageTargets: \[PicPay, /s/coverageTargets: \[PicPay, /&'"$moduleName"'\/'"$moduleName"', /' AppPicPay/project.yml

  sed -i '' '1,/randomExecutionOrder: true/s/randomExecutionOrder: true/&\
        - name: '"$moduleName"'\/'"$moduleName"Tests'\
          parallelizable: false\
          randomExecutionOrder: true/' AppPicPay/project.yml
fi
