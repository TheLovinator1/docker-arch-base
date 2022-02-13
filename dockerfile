FROM archlinux

# Add mirrors for Sweden. You can add your own mirrors to the mirrorlist file. Should probably use reflector.
ADD mirrorlist /etc/pacman.d/mirrorlist

# NOTE: For Security Reasons, archlinux image strips the pacman lsign key.
# This is because the same key would be spread to all containers of the same
# image, allowing for malicious actors to inject packages (via, for example,
# a man-in-the-middle).
RUN gpg --refresh-keys && pacman-key --init && pacman-key --populate archlinux

# Set locale. Needed for some programs.
# https://wiki.archlinux.org/title/locale
RUN echo "en_US.UTF-8 UTF-8" >"/etc/locale.gen" && locale-gen && echo "LANG=en_US.UTF-8" >"/etc/locale.conf"

# Create a new user with id 1000 and name "lovinator".
# https://linux.die.net/man/8/useradd
# https://linux.die.net/man/8/groupadd
RUN groupadd --gid 1000 lovinator && \
useradd -m --uid 1000 --gid 1000 lovinator

# Update the system
RUN pacman -Syu --noconfirm

# Remove cache. TODO: add more cleanup. Should we remove pacman?
RUN rm -rf /var/cache/*
