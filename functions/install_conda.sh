# https://bioconda.github.io/
# Python 3 version

if [[ $(uname -s) = "Linux" ]]; then
    wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
elif [[ $(uname -s) = "Darwin" ]]; then
    wget https://repo.continuum.io/miniconda/Miniconda3-latest-MacOSX-x86_64.sh
else
    echo "$(uname -s) operating system not supported"
    return 1
fi

bash Miniconda3-latest-*-x86_64.sh

echo "conda install succeeded. Shell must be reloaded."
return 1
