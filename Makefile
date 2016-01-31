release:
	rm -rf _site
	jekyll build
	(cd _site && git init)
	(cd _site && git add .)
	(cd _site && git commit -a -S -m "prepare project for deployment")
	(cd _site && git remote add pages git@github.com:sebhoss/sebhoss.github.io.git)
	(cd _site && git push --force pages master)
