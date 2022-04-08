generate: ## Generate projects, workspace and install pods
	@$(MAKE) generateprojects

generateprojects: ## Generate only .xcodeproj projects using Xcodegen
	
	@echo "\nGenerating modules projects"
	@find LearningJourney/Modules -type d -depth 2 -exec sh -c "cd {}; echo 'Generating {}'; [ -f ./project.yml ] && xcodegen" \;
	
	@echo "\nGenerating main projects"
	@(cd LearningJourney/App; xcodegen;)

open: ## Opens the main XCode project
	@(open LearningJourney/App/LearningJourney.xcodeproj)

create_module: ## Create module. Usage: make create_module NAME=Name TYPE=FEATURE | CORE
	./tools/Scripts/create_module.sh ${NAME} ${TYPE}

dep_graph: ## Copy GraphViz dependency graph to clipboard
	@((cd LearningJourney/App; xcodegen dump --type graphviz) | pbcopy)
	
run_tests: ## Run automated tests
	./tools/Scripts/run_tests.sh

clean: ## Cleanup projects 
	rm -rf LearningJourney/LearningJourney.xcworkspace
	-@find LearningJourney -maxdepth 10 -name "*.xcodeproj" -exec rm -r {} \;
