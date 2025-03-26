# chek directory
if [ ! -d /usr/local/etc/pkg/repos ]; then
    mkdir -p /usr/local/etc/pkg/repos
fi

mv /etc/pkg/FreeBSD.conf /usr/local/etc/pkg/repos/; pkg update
################################################################
# chek directory
if [ ! -d /usr/local/repo ]; then
    mkdir -p /usr/local/repo
fi
# * pkg fetch -d: downnload packages.
# * -r FreeBSD: Use Repository FreeBSD to local.
# * -o /usr/local/repo: Save packeges to /usr/local/repo.
# * $(pkg query -e '%a = 0' '%o'): Get a list of all installed packages.
pkg fetch -d -r FreeBSD -o /usr/local/repo $(pkg query -e '%a = 0' '%o')
# Create index repos.
pkg repo /usr/local/repo
# Config client pkg.
cat <<EOF | tee /usr/local/etc/pkg/repos/FreeBSD.conf
localRepo: {
  url: "file:///usr/local/repo",
  enabled: yes
}
EOF
#update respos
pkg update -r localRepo
