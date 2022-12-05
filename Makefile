all: system.png
	feh system.png

system.png: spice.sh
	./spice.sh | { echo -e "digraph {\nrankdir=\"TB\";" ; cat -; echo "}"; } | dot -Tpng > system.png
