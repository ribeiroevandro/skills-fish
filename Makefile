SHELL := fish

.PHONY: dev deploy test release

dev:
	-fisher remove ribeiroevandro/skills-fish
	fisher install ~/workspace/opensource/skills-fish/

deploy:
	-fisher remove ~/workspace/opensource/skills-fish/
	fisher install ribeiroevandro/skills-fish

test:
	fish --no-execute conf.d/*.fish completions/*.fish functions/*.fish tests/*.test.fish
	fishtape tests/*.test.fish

release:
	@test -n "$(v)" || begin; echo "Erro: informe a versão. Exemplo: make release v=0.4.0"; exit 1; end
	sed -i.bak 's/_version ".*"/_version "$(v)"/' functions/skills.fish && rm functions/skills.fish.bak
	sed -i.bak 's/skills-fish [0-9.]*/skills-fish $(v)/' tests/skills.test.fish && rm tests/skills.test.fish.bak
	sed -i.bak 's/_skills_check_update [0-9.]*/_skills_check_update $(v)/' tests/skills.test.fish && rm tests/skills.test.fish.bak
	fish --no-execute conf.d/*.fish completions/*.fish functions/*.fish tests/*.test.fish
	fishtape tests/*.test.fish
	git commit -am "chore: bump version to $(v)"
	git tag -a v$(v) -m "Release v$(v)"
	git push origin main
	git push origin v$(v)