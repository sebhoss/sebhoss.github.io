publish-to-github-pages:
	@rm -rf _site
	@jekyll build
	@git clone https://${GH_TOKEN}@github.com/sebhoss/sebhoss.github.io.git ../master
	@rm -rf ../master/*
	@cp -R _site/* ../master
	@cd ../master
	@git config user.email "travisci@shoss.de"
	@git config user.name "Travis-CI for Sebastian Hoß"
	@git add .
	@git commit -a -s -m "Travis #${TRAVIS_BUILD_NUMBER}"
	@git push --quiet --force origin master
