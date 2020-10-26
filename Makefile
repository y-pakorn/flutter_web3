.PHONY: build run bump publish

bump:
	docker run --rm -it -v ${CURDIR}:/app -w /app treeder/bump --filename pubspec.yaml bump

publish: bump
	git commit -am "bump version"
	flutter pub publish -f