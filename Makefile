publish-to-github-pages:
	@rm -rf _site
	@rm -rf ../distribution
	@bundle exec jekyll build
	@mv _site ../distribution
	@cd ../distribution
	@git init --bare .
	@git config user.email "travisci@shoss.de"
	@git config user.name "Travis-CI for Sebastian Hoß"
	@git add .
	@git commit -a -s -m "Travis #${TRAVIS_BUILD_NUMBER}"
	@git remote add github https://${GH_TOKEN}@github.com/sebhoss/sebhoss.github.io.git
	@git push --quiet --force github master
