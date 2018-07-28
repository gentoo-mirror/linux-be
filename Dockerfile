FROM gentoo/portage as portage
FROM gentoo/stage3-amd64 as setup
ENV installed_overlay /var/git/linux-be

RUN mkdir /etc/portage/repos.conf &&\
    echo -e "\
    [linux-be]\n\
    location = $installed_overlay\n\
    auto-sync = no"\
    >> /etc/portage/repos.conf/linux-be

RUN mkdir -p /etc/portage/package.accept_keywords &&\
    echo -e "\
    # unmask everything in linux-be\n\
    */*::linux-be ~amd64"\
    >> /etc/portage/package.accept_keywords/main

RUN echo -e "\
    # For branch following master\n\
    =sys-fs/zfs-9999 **\n\
    =sys-fs/zfs-kmod-9999 **\n\
    =sys-kernel/spl-9999 **"\
    >> /etc/portage/package.accept_keywords/master

RUN echo -e "\
    # For branch following lastest release\n\
    =sys-fs/zfs-0.7.9999 **\n\
    =sys-fs/zfs-kmod-0.7.9999 **\n\
    =sys-kernel/spl-0.7.9999 **"\
    >> /etc/portage/package.accept_keywords/release

COPY --from=portage /usr/portage /usr/portage

RUN echo "dev-vcs/git -gpg -iconv -nls -pcre-jit -pcre -perl -python -webdav" >> /etc/portage/package.use/git
RUN echo "sys-kernel/gentoo-sources symlink" >> /etc/portage/package.use/kernel

RUN emerge dev-vcs/git
RUN emerge -o "sys-kernel/spl"

RUN cd /usr/src/linux && make defconfig
RUN cd /usr/src/linux && make

ADD --chown=portage:portage . $installed_overlay
