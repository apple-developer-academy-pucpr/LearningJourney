# !/bin/sh


# Jump to repository root
cd "$(git rev-parse --show-toplevel)"

moduleName=$1
moduleType=$2

if [ -z "${moduleName}" ]; then
    echo "You must provide a module name"
fi

# Copy and enten on template folder
templatePath="tools/ModuleTemplate"

case "$moduleType" in
CORE) modulePath="LearningJourney/Modules/Core/${moduleName}" ;;
FEATURE) modulePath="LearningJourney/Modules/Features/${moduleName}" ;;
*) echo "Module type must be either CORE or FEATURE. $moduleType is invalid"; exit 1 ;;
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
