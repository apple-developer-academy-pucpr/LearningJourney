generate: ## Generate projects, workspace and install pods
	@$(MAKE) generateprojects

generateprojects: ## Generate only .xcodeproj projects using Xcodegen
	
	@echo "\nGenerating modules projects"
	@find LearningJourney/Modules -type d -depth 2 -exec sh -c "cd {}; [ -f ./project.yml ] && xcodegen" \;
	
	@echo "\nGenerating main projects"
	@(cd LearningJourney/App; xcodegen; open LearningJourney.xcodeproj)

create_module:
	./tools/Scripts/create_module.sh ${NAME} ${TYPE}
