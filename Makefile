build-website:
	echo "Building the website"
	@hugo build . --config hugo.yml
	echo "Building caddy server"
	@docker build --platform linux/amd64 -t drake/smoker .

ship-container:
	echo "Saving and shipping docker image"
	rm -rf dimage
	mkdir -p dimage
	docker image save -o dimage/smoker.tar.gz drake/smoker
	scp dimage/smoker.tar.gz login.smokeysmokerson.com:/root/website

all: build-website ship-container


## serve the productin site locally with watch and open in a browser
serve:
	hugo server serve --config hugo.yml --environment production --disableFastRender -w -O

setup:
	git clone https://github.com/adityatelange/hugo-PaperMod themes/PaperMod --depth=1
