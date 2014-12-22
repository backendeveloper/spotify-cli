case "$OCAML_VERSION,$OPAM_VERSION" in
3.12.1,1.2.0) ppa=avsm/ocaml312+opam12 ;;
4.00.1,1.2.0) ppa=avsm/ocaml40+opam12 ;;
4.01.0,1.2.0) ppa=avsm/ocaml41+opam12 ;;
4.02.1,1.2.0) ppa=avsm/ocaml42+opam12 ;;
*) echo Unknown $OCAML_VERSION,$OPAM_VERSION; exit 1 ;;
esac

# install opam
echo "yes" | sudo add-apt-repository ppa:$ppa
sudo apt-get update -qq
sudo apt-get install -qq ocaml ocaml-native-compilers camlp4-extra opam
export OPAMYES=1
export OPAMVERBOSE=1
echo OCaml version
ocaml -version
echo OPAM versions
opam --version
opam --git-version

# setup opam
opam init
eval `opam config env`
opam remote add johnelse git://github.com/johnelse/opam-repo-johnelse

# install opam-installext
git clone git://github.com/johnelse/opam-installext /tmp/opam-installext
opam pin add opam-installext /tmp/opam-installext

# install deps
opam pin add spotify-cli $PWD -n
opam installext spotify-cli
opam install spotify-cli --deps-only

# test the build
./configure
make
