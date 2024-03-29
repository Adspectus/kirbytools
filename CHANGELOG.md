# Changelog

## v1.5.6 (2024-03-21)

- Fixed issue with symlinked kirby folder [Uwe Gehring] [2953cc3](https://github.com/Adspectus/kirbytools/commit/2953cc36ee1ad8f5a4365e7e3d1bd26672b1541b)
- Changed variable presets [Uwe Gehring] [62ad1f8](https://github.com/Adspectus/kirbytools/commit/62ad1f8314ed1b4fa740389cb035759dda89153e)
- Fixed docdir instead of packagedir [Uwe Gehring] [39fa544](https://github.com/Adspectus/kirbytools/commit/39fa544ea995b3c9f3d475c8ecc67b6b48be41a8)
- Ecplicitly set xz for compression [Uwe Gehring] [29e16c3](https://github.com/Adspectus/kirbytools/commit/29e16c3bfdeae7aeca4a98cc6b18bc287f8ae513)

## v1.5.5 (2024-03-21) Release 1.5.5 (Removed php dependency)

- Changed to an universal PHPBIN replacement [Uwe Gehring] [10614a9](https://github.com/Adspectus/kirbytools/commit/10614a963bef4e15868836245993f1663084554b)
- Added -f in fron of script for PHPBIN [Uwe Gehring] [bc71fa9](https://github.com/Adspectus/kirbytools/commit/bc71fa9dae33dc60b01b79417d7ca66423e5b39e)
- Added createUserByDocker example script [Uwe Gehring] [4258562](https://github.com/Adspectus/kirbytools/commit/4258562948c4f3a6b7849b4933f73b378dc88081)
- Provide local modifications which should not be ov erwritten [Uwe Gehring] [5235f50](https://github.com/Adspectus/kirbytools/commit/5235f5040a4bbda012d23783f03288e148627241)
- Added note in case of empty PHPBIN [Uwe Gehring] [096eb3d](https://github.com/Adspectus/kirbytools/commit/096eb3d51af6cc5cef7dc3f4c245d3bd5597e6f7)
- Only run PHPBIN if it is not empty [Uwe Gehring] [e96adaa](https://github.com/Adspectus/kirbytools/commit/e96adaacd120a8f8255d6756543d3a1b4a6e94a5)
- Removed dependency to PHP and added it as suggestion together with docker [Uwe Gehring] [9d9d780](https://github.com/Adspectus/kirbytools/commit/9d9d7805e3c3f812a742ca03c7e5b0bb4d0f2282)

## v1.5.4 (2022-01-27) Release 1.5.4

- Updated README [Uwe Gehring] [0243254](https://github.com/Adspectus/kirbytools/commit/024325461cd4fad5fea38c206df3b8c076018044)
- Added cleanup of cache and sessions dirs [Uwe Gehring] [a2b8944](https://github.com/Adspectus/kirbytools/commit/a2b8944b1df04b2ce89ca384dc048f33c6b5e26f)

## v1.5.3 (2021-05-09) Release 1.5.3

- Changed the default vhost name [Uwe Gehring] [bf039e5](https://github.com/Adspectus/kirbytools/commit/bf039e5c4777a7a962c206a21ee741a735c7e2f5)

## v1.5.2 (2020-12-29) Release 1.5.2

- Bugfix: Removing old and creating new symlink [Uwe Gehring] [3a99a6c](https://github.com/Adspectus/kirbytools/commit/3a99a6c31438f0c11a195e3f27b1c858911c5ffc)

## v1.5.1 (2020-12-29) Release 1.5.1

- Updated README.md [Uwe Gehring] [e1f0a28](https://github.com/Adspectus/kirbytools/commit/e1f0a28da6d30adc25cbc8de95a02f337d235f34)

## v1.5.0 (2020-12-29) Release 1.5.0

- Finished manpage of kirbychangeversion [Uwe Gehring] [319e4fd](https://github.com/Adspectus/kirbytools/commit/319e4fd3bd9ae1a7608a6bc16937accfe09851d1)
- First working version [Uwe Gehring] [2a1bef4](https://github.com/Adspectus/kirbytools/commit/2a1bef42b6da43c0e7e541d51efb1a4951290853)
- Added reference to new script kirbychangeversion [Uwe Gehring] [2150bf7](https://github.com/Adspectus/kirbytools/commit/2150bf78c158cedf52ae6e4b144dfd2ff193ee38)
- New PHP script getConfig.php [Uwe Gehring] [12318cc](https://github.com/Adspectus/kirbytools/commit/12318cc565a39f072b8dcae8fe5a68f872b7cd2f)
- Create .kirbydocroot to identify document root of a kirby vhost [Uwe Gehring] [be9068c](https://github.com/Adspectus/kirbytools/commit/be9068c3a17c3cc8f2e83fb27716a6913bf98275)
- Define PHPBIN for usage of php [Uwe Gehring] [a3e60b1](https://github.com/Adspectus/kirbytools/commit/a3e60b1ec308dff90eb195bc82845015af6ca8b4)
- Changed color definition [Uwe Gehring] [e4d9a2b](https://github.com/Adspectus/kirbytools/commit/e4d9a2bbef4124b7803a81a0ca42feb9c00223cd)
- Added return codes to save_* functions [Uwe Gehring] [8655981](https://github.com/Adspectus/kirbytools/commit/8655981484ee193cf2c28b1edbf113c8ac3080f2)
- Added dependency bash >= 4 [Uwe Gehring] [408f252](https://github.com/Adspectus/kirbytools/commit/408f2526017abf64dd7578fc04bde97196331e1d)
- Reworked the structure [Uwe Gehring] [5e7922f](https://github.com/Adspectus/kirbytools/commit/5e7922fa551a38a618aec57e2092180edf38374f)
- Added variable and functions to find next version [Uwe Gehring] [42f261b](https://github.com/Adspectus/kirbytools/commit/42f261bb453d7b9926ba3d77585801df2e9da78c)
- Added basic structure for kirby dir/symlink [Uwe Gehring] [3f05e9e](https://github.com/Adspectus/kirbytools/commit/3f05e9eaab6edff5b127b37747c67a59ee5e4ff0)
- Bugfix to find only real vhosts [Uwe Gehring] [285a748](https://github.com/Adspectus/kirbytools/commit/285a748e2be654fc33eacf8649214facfd44c6e4)
- Adding new script kirbychangeversion [Uwe Gehring] [bb14ffd](https://github.com/Adspectus/kirbytools/commit/bb14ffd12311a649ba0b120bebd01bac14e51279)
- Adding new script kirbychangeversion [Uwe Gehring] [0d7ab07](https://github.com/Adspectus/kirbytools/commit/0d7ab071a844d9f5a0c0de4bf58aa58756701072)

## v1.4.4 (2020-09-02) Release 1.4.4

- Bugfix for function askTag [Uwe Gehring] [84fa33c](https://github.com/Adspectus/kirbytools/commit/84fa33c302c59a86bdd8b28b85ceb81adf55264e)

## v1.4.3 (2020-09-02) Release 1.4.3

- Bugfix for function askTag [Uwe Gehring] [7dff4d2](https://github.com/Adspectus/kirbytools/commit/7dff4d266fe826aaa24d6de63c8900175641f22a)
- Change: Read version from changelog [Uwe Gehring] [1f705c9](https://github.com/Adspectus/kirbytools/commit/1f705c9858cec4a811449dfa1dfe092e299c3428)

## v1.4.2 (2020-06-18) Release 1.4.2

- Changed order of last section with templates [Uwe Gehring] [977adf3](https://github.com/Adspectus/kirbytools/commit/977adf3feb5c43ab2ed15b36ddf7508fd736a9b7)

## v1.4.1 (2020-06-16) Release 1.4.1

- Fixed typo [Uwe Gehring] [2f41fad](https://github.com/Adspectus/kirbytools/commit/2f41fad147dad7f344714c569a000790d20fa179)
- Changed README [Uwe Gehring] [b2702d7](https://github.com/Adspectus/kirbytools/commit/b2702d75f9f878d684b9b1cde046ee26ea1e7920)

## v1.4.0 (2020-06-14) Release 1.4.0

- Restart apache2 only if necessary [Uwe Gehring] [a57e63e](https://github.com/Adspectus/kirbytools/commit/a57e63e33fcf3674a929e7b8a7b0f5d4a378ad9b)
- Ask for confirmation before apache2 restart [Uwe Gehring] [164686d](https://github.com/Adspectus/kirbytools/commit/164686d4f059a2c996c675bae896b21c7be93945)
- Finalized README.templates [Uwe Gehring] [0113a12](https://github.com/Adspectus/kirbytools/commit/0113a12fdb1fa1312708a6144755e723446613ce)
- Changed and removed obsolete parts [Uwe Gehring] [d39e874](https://github.com/Adspectus/kirbytools/commit/d39e874fcce1ba521771dced79a6aa60a16f0cc0)
- Removed kirbydownload, will be done by kirbyinstall [Uwe Gehring] [c06e988](https://github.com/Adspectus/kirbytools/commit/c06e988f653d6dcb045695389c9d7757e6096d14)
- Added function for save restart of apache2 [Uwe Gehring] [4e84851](https://github.com/Adspectus/kirbytools/commit/4e84851f3dddf0c1fa34b693f4ce03945e5ddd40)
- Change: Option -w is required [Uwe Gehring] [782163e](https://github.com/Adspectus/kirbytools/commit/782163ec854c2905e1ee492b590dec4a7f98459d)
- Fix: kirbydownload -l only when called with -l [Uwe Gehring] [a0c4b9f](https://github.com/Adspectus/kirbytools/commit/a0c4b9f7c53688c36c1eaffe0f7aafc4e2c693ce)
- Adopted manpage to examples location [Uwe Gehring] [92116bd](https://github.com/Adspectus/kirbytools/commit/92116bde2ebd6bb3941834bdd795ab8cfb4051d4)
- Moved examples to its designated place [Uwe Gehring] [69bf49f](https://github.com/Adspectus/kirbytools/commit/69bf49f9732fcb3e51fa5cdd79d14d6ef62dfc81)
- Finalized README [Uwe Gehring] [24710e4](https://github.com/Adspectus/kirbytools/commit/24710e49bdde402e165409d42540ab26b0804655)
- First version of README [Uwe Gehring] [7c2ef5f](https://github.com/Adspectus/kirbytools/commit/7c2ef5fe529215ca28771e35e5033a9c1ec1b2f0)
- Removed obsolete option l [Uwe Gehring] [42454fe](https://github.com/Adspectus/kirbytools/commit/42454fee95b84cdb02744e0909f722c27bef6330)
- Adding LICENSE [Uwe Gehring] [d56ffc0](https://github.com/Adspectus/kirbytools/commit/d56ffc080b0627460e7dd95a6f6074abf6f89f6e)
- Changed description [Uwe Gehring] [b4247cb](https://github.com/Adspectus/kirbytools/commit/b4247cb0b6eabdc5568f42bea1f16ebac7695e54)
- Initial version [Uwe Gehring] [013f2a6](https://github.com/Adspectus/kirbytools/commit/013f2a65301d271905af1b96cf9ab17d5a62ecc3)
- Changed enablement of site [Uwe Gehring] [148f699](https://github.com/Adspectus/kirbytools/commit/148f699bac06bedfdb27f5b4032834695f9c3984)
- Ignore manpages [Uwe Gehring] [a1d3376](https://github.com/Adspectus/kirbytools/commit/a1d3376aee59086703e65b73a9207461b4fb1f3a)
- Untrack manpages because they can be created from xml [Uwe Gehring] [bce848d](https://github.com/Adspectus/kirbytools/commit/bce848dd85a5bb4f041f683426ec8f387e38462b)
- Changed documentation [Uwe Gehring] [0bddcf9](https://github.com/Adspectus/kirbytools/commit/0bddcf9c09c6ff9ca2b7eb8ab2d3700a9e2b2bde)
- Change: apache2 not really necessary [Uwe Gehring] [9411f75](https://github.com/Adspectus/kirbytools/commit/9411f75597d5cb0e7c22a96c73cd6a24c4d8efc9)
- Bugfix: Handling of apache vhost configuration  templates [Uwe Gehring] [3e8ae59](https://github.com/Adspectus/kirbytools/commit/3e8ae5915d40a128c62876f34513f0d21d59730d)
- Added completion for kirbyinstall -p [Uwe Gehring] [bf4a7a2](https://github.com/Adspectus/kirbytools/commit/bf4a7a29e4baf011b401188e731a79f2cd05d03a)
- Bugfix: Remove noglob after set COMPREPLY [Uwe Gehring] [9264f11](https://github.com/Adspectus/kirbytools/commit/9264f11faebb9b406f2efc2819c317fe3225c1e0)
- Reworked manpages [Uwe Gehring] [2057139](https://github.com/Adspectus/kirbytools/commit/20571394d70e38a04f44445a862749066727e249)
- Obsolete [Uwe Gehring] [032c59c](https://github.com/Adspectus/kirbytools/commit/032c59c83e377f4869d462f539bcdc498c3a3bbe)
- Adopted to other changes [Uwe Gehring] [9990403](https://github.com/Adspectus/kirbytools/commit/999040393c991bd93e9eb234f3297bf45f442159)
- Adopted to changed variables and cosmetic changes [Uwe Gehring] [3521380](https://github.com/Adspectus/kirbytools/commit/3521380dd9eb5ef944f670a9c57806e362e57edf)
- Cosmetic changes [Uwe Gehring] [f5042c5](https://github.com/Adspectus/kirbytools/commit/f5042c581fd5ef1202258dc32a7098afeea4730e)
- Removed -l option and canged deletion [Uwe Gehring] [f9a2d5f](https://github.com/Adspectus/kirbytools/commit/f9a2d5fd8459af37c3a54570803e7ffd68d1976c)
- Added apache config variables [Uwe Gehring] [3ceb826](https://github.com/Adspectus/kirbytools/commit/3ceb826278ee834e33189da0e1552627ea12377a)
- Make apache2 config only an example [Uwe Gehring] [9c20bae](https://github.com/Adspectus/kirbytools/commit/9c20bae3b353f0261b2c985b265d099f6c02fd87)
- Make apache2 config only an example [Uwe Gehring] [5e1a1c9](https://github.com/Adspectus/kirbytools/commit/5e1a1c9bb8c932f6320a9b12f1c36271ee574813)
- Removed dependency apache2 and changed vhostmanage [Uwe Gehring] [e45e905](https://github.com/Adspectus/kirbytools/commit/e45e905f1614ebfd21239bebf5094d07e3da2ea5)
- Write tmp file first [Uwe Gehring] [448cd8a](https://github.com/Adspectus/kirbytools/commit/448cd8aa8441b4a46fdde3b2bca90aa31881e504)
- Changed wording [Uwe Gehring] [5f4ddf9](https://github.com/Adspectus/kirbytools/commit/5f4ddf959f6e7730b062ca2a611e79a2012ecd2f)
- Many changes [Uwe Gehring] [3e55e75](https://github.com/Adspectus/kirbytools/commit/3e55e7543538ce965d378bb988279f991b3f9221)
- Changed wording and removed templates [Uwe Gehring] [49c18da](https://github.com/Adspectus/kirbytools/commit/49c18da8cd2308c726651267fb885f2e4fa4d3e7)
- Changed for apache conf [Uwe Gehring] [dc8cf60](https://github.com/Adspectus/kirbytools/commit/dc8cf608ad7c8e2c65b0c5a1e829553df9eff71e)
- Added 2 files [Uwe Gehring] [66014e0](https://github.com/Adspectus/kirbytools/commit/66014e0ae133776d7604a29fcfe1457c7e2e9568)
- Initial version [Uwe Gehring] [f4d5005](https://github.com/Adspectus/kirbytools/commit/f4d500587dde0b4ded45a7cae9503be7c0caad9e)
- Enhanced bash_completion [Uwe Gehring] [b15a558](https://github.com/Adspectus/kirbytools/commit/b15a5581ac9d73d85de4f2fec00c54aeb4aa0c34)
- Changed to be an example [Uwe Gehring] [8362655](https://github.com/Adspectus/kirbytools/commit/83626556f8f8ac944909fb684faaeeb624e85483)
- Initial version [Uwe Gehring] [ada2cea](https://github.com/Adspectus/kirbytools/commit/ada2ceaadd3faeedff16e32a5e4296c08416208e)
- Implement kirbyconfigure [Uwe Gehring] [b92ad5f](https://github.com/Adspectus/kirbytools/commit/b92ad5f5fe17cb97281d4235a5535015d5ebcef2)
- Add kirbyconfigure and put templates in examples dir [Uwe Gehring] [5d47bf5](https://github.com/Adspectus/kirbytools/commit/5d47bf52c634543d6d5cd1f934e01f603e826352)
- Changed variables test [Uwe Gehring] [26201f5](https://github.com/Adspectus/kirbytools/commit/26201f5fbb795f1d7746031e0919fd7358213e87)
- Updated manpages [Uwe Gehring] [827fdf3](https://github.com/Adspectus/kirbytools/commit/827fdf3f51a8aa8c408075effaabc1ea9eccc743)
- Updated manpages [Uwe Gehring] [e55def5](https://github.com/Adspectus/kirbytools/commit/e55def5f03c80e9f540495fec21e0f80a671da5a)
- Reorg and changed logic [Uwe Gehring] [23193d1](https://github.com/Adspectus/kirbytools/commit/23193d142944fbfcc840e46990621e83982c5c8e)
- Removed obsolete files [Uwe Gehring] [d9dc940](https://github.com/Adspectus/kirbytools/commit/d9dc94007f8ea9bb7d7f213229db20812d621d36)
- Initial version [Uwe Gehring] [cb05534](https://github.com/Adspectus/kirbytools/commit/cb0553486c122deef29d680e95211669af42b67c)
- Changed EMail address [Uwe Gehring] [9bb568e](https://github.com/Adspectus/kirbytools/commit/9bb568e0c2a2a63d5c9a381b543cc421687df92f)
- Initial versions of manpages [Uwe Gehring] [4ab179e](https://github.com/Adspectus/kirbytools/commit/4ab179e27544a5822e8588489e986480e8c58a22)
- Small wording correction [Uwe Gehring] [fea58a2](https://github.com/Adspectus/kirbytools/commit/fea58a28c53d7621f42792e9d70f410f5fbb6eef)
- Prepare manpages and reorg source files [Uwe Gehring] [3353e15](https://github.com/Adspectus/kirbytools/commit/3353e152334917fa8f283ccb07e431334c3510a5)
- Changed suggests vhostmange instead recommends [Uwe Gehring] [3611d4c](https://github.com/Adspectus/kirbytools/commit/3611d4cd04ad27f4195601be0e77f610b7aa675c)
- Changed output format at the end [Uwe Gehring] [e828c2f](https://github.com/Adspectus/kirbytools/commit/e828c2f5457580faabf401ffa1133bdf1ea88796)
- Added option -f and make kirbylib owned by root [Uwe Gehring] [475a92b](https://github.com/Adspectus/kirbytools/commit/475a92b8edf66e2d0f0651ed7b11233b0947d8c0)
- Bugfix: Not reading bash source files [Uwe Gehring] [03925da](https://github.com/Adspectus/kirbytools/commit/03925da7f0de379b92f35a3b05be6a1e1b39870e)
- kirbytools.links replaced postinst and postrm [Uwe Gehring] [aed02b3](https://github.com/Adspectus/kirbytools/commit/aed02b39d6ed2ddd695e45197fcd610f63097cbe)
- Remove links in /usr/bin when purge|remove [Uwe Gehring] [8f7447b](https://github.com/Adspectus/kirbytools/commit/8f7447b0b5a5b842728a6c360f3f0fd6c77d733c)
- New file to display msg about downloads and links [Uwe Gehring] [a0076f8](https://github.com/Adspectus/kirbytools/commit/a0076f89e90eab1e306297ddb8f3229af327bb5f)
- Minor cosmetic changes [Uwe Gehring] [02bb40c](https://github.com/Adspectus/kirbytools/commit/02bb40c4864b02b6bcdeb4d70b057554c86004ef)
- Changed dependencies for php [Uwe Gehring] [6604a9d](https://github.com/Adspectus/kirbytools/commit/6604a9d664a5f9dce6e0510dc0425b28d046ba73)
- Replaced site-available/enabled with variables [Uwe Gehring] [ea2a75a](https://github.com/Adspectus/kirbytools/commit/ea2a75abd0f754ec9febce4be3c0f9d971a1c3ad)
- Remove old bins in HOME/bin [Uwe Gehring] [3fc9717](https://github.com/Adspectus/kirbytools/commit/3fc9717743a655609cdd2ddb2de807375c7cbd2f)
- Reworked directory structure [Uwe Gehring] [f91f22d](https://github.com/Adspectus/kirbytools/commit/f91f22d558abb8eec25958b60b536e3be3b9cd8a)
- Reworked directory structure [Uwe Gehring] [a5dafc7](https://github.com/Adspectus/kirbytools/commit/a5dafc7e62bdfdb9d205782691a642dc1639390d)
- Added copyright for debian/* files [Uwe Gehring] [8a75799](https://github.com/Adspectus/kirbytools/commit/8a757998b19b59d6284b11af4c36bf38e863c363)
- Fixed vhostenable section [Uwe Gehring] [b9a2e4e](https://github.com/Adspectus/kirbytools/commit/b9a2e4e91f12a463bf848a3ebf7e578c6efd623b)
- Copy templates to templatedir [Uwe Gehring] [77ea277](https://github.com/Adspectus/kirbytools/commit/77ea277969dee1fe7ed412cbb624900432f1685e)
- Fixed permissions when creating link (run as sudo) [Uwe Gehring] [16d9179](https://github.com/Adspectus/kirbytools/commit/16d9179dc2b873f8a66f9df918cb50906a7b92b3)
- Changed comment [Uwe Gehring] [120390d](https://github.com/Adspectus/kirbytools/commit/120390dd7b9587ec42d70a91336dde51c7d36a3e)
- Added comment [Uwe Gehring] [89e382e](https://github.com/Adspectus/kirbytools/commit/89e382e5f1697b84711e1f957cba3ea9fefe72ec)
- Ignore packages in root dir [Uwe Gehring] [47d5dfc](https://github.com/Adspectus/kirbytools/commit/47d5dfc89fde1e52a362e4668c30660e5b28ae9e)
- Renamed base directory [Uwe Gehring] [c084385](https://github.com/Adspectus/kirbytools/commit/c0843859c669a032b4883114b5a6fc4c7a875f83)
- Complete rebuild [Uwe Gehring] [84af3e5](https://github.com/Adspectus/kirbytools/commit/84af3e50e9d7a519c77a9440db491e0fd513cdd4)
- Changes to structure [Uwe Gehring] [6b2e508](https://github.com/Adspectus/kirbytools/commit/6b2e508ffdcc9a83f170d20e7c0014728267f2aa)
- Changed complete structure [Uwe Gehring] [f094c39](https://github.com/Adspectus/kirbytools/commit/f094c39611a3a739f5768644f905f88c463be737)
- Fixed error from debuild [Uwe Gehring] [200d970](https://github.com/Adspectus/kirbytools/commit/200d970e86e9630a284cb58d8998cdea793b8826)
- Fixed warnings from lintian [Uwe Gehring] [f576b63](https://github.com/Adspectus/kirbytools/commit/f576b63c6b353a03b44730c02e6e736d7753aded)
- Fixed errors from lintian [Uwe Gehring] [a7e286e](https://github.com/Adspectus/kirbytools/commit/a7e286e27d3bc61b6fbb7f45026a081bbc7d2fa0)
- Fixed name [Uwe Gehring] [5ff81c1](https://github.com/Adspectus/kirbytools/commit/5ff81c1be93df38090ebf63b748b3934b9c1e4c7)
- Fix pre/post install scripts [Uwe Gehring] [c3409db](https://github.com/Adspectus/kirbytools/commit/c3409dbdf9107365244b791ad7ec215c41ef4152)
- Initial versions for debian package [Uwe Gehring] [87c0bd2](https://github.com/Adspectus/kirbytools/commit/87c0bd2c57960f2891b397dbd20dcec4940bf43e)

