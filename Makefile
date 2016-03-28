publish-to-github-pages:
	@rm -rf _site
	@bundle exec jekyll build
	@(cd _site && git init)
	@(cd _site && git config user.email "travisci@shoss.de")
	@(cd _site && git config user.name "Travis-CI for Sebastian Hoß")
	@(cd _site && git add .)
	@(cd _site && git commit -a -s -m "Travis #${TRAVIS_BUILD_NUMBER}")
	@(cd _site && git remote add github-pages https://${GH_TOKEN}@github.com/sebhoss/sebhoss.github.io.git)
	@(cd _site && git push --quiet --force github-pages master > /dev/null 2>&1)

serve-locally:
	@bundle exec jekyll serve --watch