# Changelog

## v1.5.2 (2020-12-29)

- Bugfix: Removing old and creating new symlink [Uwe Gehring] 3a99a6c

## v1.5.1 (2020-12-29)

- Updated README.md [Uwe Gehring] e1f0a28

## v1.5.0 (2020-12-29)

- Finished manpage of kirbychangeversion [Uwe Gehring] 319e4fd
- First working version [Uwe Gehring] 2a1bef4
- Added reference to new script kirbychangeversion [Uwe Gehring] 2150bf7
- New PHP script getConfig.php [Uwe Gehring] 12318cc
- Create .kirbydocroot to identify document root of a kirby vhost [Uwe Gehring] be9068c
- Define PHPBIN for usage of php [Uwe Gehring] a3e60b1
- Changed color definition [Uwe Gehring] e4d9a2b
- Added return codes to save_* functions [Uwe Gehring] 8655981
- Added dependency bash >= 4 [Uwe Gehring] 408f252
- Reworked the structure [Uwe Gehring] 5e7922f
- Added variable and functions to find next version [Uwe Gehring] 42f261b
- Added basic structure for kirby dir/symlink [Uwe Gehring] 3f05e9e
- Bugfix to find only real vhosts [Uwe Gehring] 285a748
- Adding new script kirbychangeversion [Uwe Gehring] bb14ffd
- Adding new script kirbychangeversion [Uwe Gehring] 0d7ab07

## v1.4.4 (2020-09-02)

- Bugfix for function askTag [Uwe Gehring] 84fa33c

## v1.4.3 (2020-09-02)

- Bugfix for function askTag [Uwe Gehring] 7dff4d2
- Change: Read version from changelog [Uwe Gehring] 1f705c9

## v1.4.2 (2020-06-18)

- Changed order of last section with templates [Uwe Gehring] 977adf3

## v1.4.1 (2020-06-16)

- Fixed typo [Uwe Gehring] 2f41fad
- Changed README [Uwe Gehring] b2702d7

## v1.4.0 (2020-06-14)

- Restart apache2 only if necessary [Uwe Gehring] a57e63e
- Ask for confirmation before apache2 restart [Uwe Gehring] 164686d
- Finalized README.templates [Uwe Gehring] 0113a12
- Changed and removed obsolete parts [Uwe Gehring] d39e874
- Removed kirbydownload, will be done by kirbyinstall [Uwe Gehring] c06e988
- Added function for save restart of apache2 [Uwe Gehring] 4e84851
- Change: Option -w is required [Uwe Gehring] 782163e
- Fix: kirbydownload -l only when called with -l [Uwe Gehring] a0c4b9f
- Adopted manpage to examples location [Uwe Gehring] 92116bd
- Moved examples to its designated place [Uwe Gehring] 69bf49f
- Finalized README [Uwe Gehring] 24710e4
- First version of README [Uwe Gehring] 7c2ef5f
- Removed obsolete option l [Uwe Gehring] 42454fe
- Adding LICENSE [Uwe Gehring] d56ffc0
- Changed description [Uwe Gehring] b4247cb
- Initial version [Uwe Gehring] 013f2a6
- Changed enablement of site [Uwe Gehring] 148f699
- Ignore manpages [Uwe Gehring] a1d3376
- Untrack manpages because they can be created from xml [Uwe Gehring] bce848d
- Changed documentation [Uwe Gehring] 0bddcf9
- Change: apache2 not really necessary [Uwe Gehring] 9411f75
- Bugfix: Handling of apache vhost configuration  templates [Uwe Gehring] 3e8ae59
- Added completion for kirbyinstall -p [Uwe Gehring] bf4a7a2
- Bugfix: Remove noglob after set COMPREPLY [Uwe Gehring] 9264f11
- Reworked manpages [Uwe Gehring] 2057139
- Obsolete [Uwe Gehring] 032c59c
- Adopted to other changes [Uwe Gehring] 9990403
- Adopted to changed variables and cosmetic changes [Uwe Gehring] 3521380
- Cosmetic changes [Uwe Gehring] f5042c5
- Removed -l option and canged deletion [Uwe Gehring] f9a2d5f
- Added apache config variables [Uwe Gehring] 3ceb826
- Make apache2 config only an example [Uwe Gehring] 9c20bae
- Make apache2 config only an example [Uwe Gehring] 5e1a1c9
- Removed dependency apache2 and changed vhostmanage [Uwe Gehring] e45e905
- Write tmp file first [Uwe Gehring] 448cd8a
- Changed wording [Uwe Gehring] 5f4ddf9
- Many changes [Uwe Gehring] 3e55e75
- Changed wording and removed templates [Uwe Gehring] 49c18da
- Changed for apache conf [Uwe Gehring] dc8cf60
- Added 2 files [Uwe Gehring] 66014e0
- Initial version [Uwe Gehring] f4d5005
- Enhanced bash_completion [Uwe Gehring] b15a558
- Changed to be an example [Uwe Gehring] 8362655
- Initial version [Uwe Gehring] ada2cea
- Implement kirbyconfigure [Uwe Gehring] b92ad5f
- Add kirbyconfigure and put templates in examples dir [Uwe Gehring] 5d47bf5
- Changed variables test [Uwe Gehring] 26201f5
- Updated manpages [Uwe Gehring] 827fdf3
- Updated manpages [Uwe Gehring] e55def5
- Reorg and changed logic [Uwe Gehring] 23193d1
- Removed obsolete files [Uwe Gehring] d9dc940
- Initial version [Uwe Gehring] cb05534
- Changed EMail address [Uwe Gehring] 9bb568e
- Initial versions of manpages [Uwe Gehring] 4ab179e
- Small wording correction [Uwe Gehring] fea58a2
- Prepare manpages and reorg source files [Uwe Gehring] 3353e15
- Changed suggests vhostmange instead recommends [Uwe Gehring] 3611d4c
- Changed output format at the end [Uwe Gehring] e828c2f
- Added option -f and make kirbylib owned by root [Uwe Gehring] 475a92b
- Bugfix: Not reading bash source files [Uwe Gehring] 03925da
- kirbytools.links replaced postinst and postrm [Uwe Gehring] aed02b3
- Remove links in /usr/bin when purge|remove [Uwe Gehring] 8f7447b
- New file to display msg about downloads and links [Uwe Gehring] a0076f8
- Minor cosmetic changes [Uwe Gehring] 02bb40c
- Changed dependencies for php [Uwe Gehring] 6604a9d
- Replaced site-available/enabled with variables [Uwe Gehring] ea2a75a
- Remove old bins in HOME/bin [Uwe Gehring] 3fc9717
- Reworked directory structure [Uwe Gehring] f91f22d
- Reworked directory structure [Uwe Gehring] a5dafc7
- Added copyright for debian/* files [Uwe Gehring] 8a75799
- Fixed vhostenable section [Uwe Gehring] b9a2e4e
- Copy templates to templatedir [Uwe Gehring] 77ea277
- Fixed permissions when creating link (run as sudo) [Uwe Gehring] 16d9179
- Changed comment [Uwe Gehring] 120390d
- Added comment [Uwe Gehring] 89e382e
- Ignore packages in root dir [Uwe Gehring] 47d5dfc
- Renamed base directory [Uwe Gehring] c084385
- Complete rebuild [Uwe Gehring] 84af3e5
- Changes to structure [Uwe Gehring] 6b2e508
- Changed complete structure [Uwe Gehring] f094c39
- Fixed error from debuild [Uwe Gehring] 200d970
- Fixed warnings from lintian [Uwe Gehring] f576b63
- Fixed errors from lintian [Uwe Gehring] a7e286e
- Fixed name [Uwe Gehring] 5ff81c1
- Fix pre/post install scripts [Uwe Gehring] c3409db
- Initial versions for debian package [Uwe Gehring] 87c0bd2

