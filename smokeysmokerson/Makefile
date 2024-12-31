build-website:
	echo "Building the website"
	@docker build -t drake/smoker .

ship-container:
	echo "Saving and shipping docker image"
	@mkdir -p dimage
	@docker image save -o dimage/smoker.tar.gz drake/smoker
  @scp dimage/smoker.tar.gz smokeysmokerson.com:/root/website

all: build-website ship-container
