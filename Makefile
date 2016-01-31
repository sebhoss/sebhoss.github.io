release:
	rm -rf _site
	jekyll build
	(cd _site && git init)
	(cd _site && git add .)
	(cd _site && git commit -a -S -m "prepare project for deployment")
