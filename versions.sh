git submodule foreach -q \
	'printf "${name}-$(grep -E ^version build.gradle)\n"' | \
	sed -e 's/-/_/' | \
	sed -e 's/-/_/' | \
	tr -d " "
