SHELL := fish

.PHONY: dev deploy

dev:
	-fisher remove ribeiroevandro/skills-fish
	fisher install ~/workspace/opensource/skills-fish/

deploy:
	-fisher remove ~/workspace/opensource/skills-fish/
	fisher install ribeiroevandro/skills-fish