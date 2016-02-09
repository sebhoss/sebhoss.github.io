publish-to-github-pages:
	rm -rf _site
	jekyll build
	cd _site
	git init
	git config user.email "travisci@shoss.de"
	git config user.name "Travis-CI for Sebastian Hoß"
	git add .
	git commit -a -s -m "Travis #$TRAVIS_BUILD_NUMBER"
	git remote add github-pages https://${GH_TOKEN}@github.com:sebhoss/sebhoss.github.io.git
	git push --force github-pages master
