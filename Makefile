publish-to-github-pages:
	rm -rf _site
	jekyll build
	(cd _site && git init)
	(cd _site && git config user.email "mail@shoss.de")
	(cd _site && git config user.name "Sebastian Hoß")
	(cd _site && git add .)
	(cd _site && git commit -a -s -m "locally built")
	(cd _site && git remote add github-pages git@github.com:sebhoss/sebhoss.github.io.git)
	(cd _site && git push --force github-pages master)
