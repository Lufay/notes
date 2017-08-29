# 磁盘管理

在linux 中，磁盘设备本身就是一种块文件，一般都位于/dev 下
一般不会对这些块文件直接进行读写，而是将其挂载起来，进入挂载目录再进行读写

## mount
```
mount [-t vfstype] [-o options] device dir
```
1. -t vfstype 指定文件系统的类型，通常不必指定。mount 会自动选择正确的类型。常用类型有：
	+ 光盘或光盘镜像：iso9660
	+ DOS fat16 文件系统：msdos
	+ Windows 9x fat32 文件系统：vfat
	+ Windows NT ntfs 文件系统：ntfs
	+ Mount Windows 文件网络共享：smbfs
	+ UNIX(LINUX) 文件网络共享：nfs
    + Linux下一种基于RAM做存储的文件系统: ramfs
1. -o options 主要用来描述设备或档案的挂接方式。常用的参数有：
	+ loop：挂载回旋设备，用来把一个文件当成硬盘分区挂接上系统
	+ ro：采用只读方式挂接设备
	+ rw：采用读写方式挂接设备
	+ iocharset：指定访问文件系统所用字符集，简体中文一般用cp936或gb2312
	+ codepage=XXX 指定文件系统的代码页，简体中文中文代码是936
	+ remount ：重新挂载
    + size: 指定大小，但对于ramfs 并不起作用
1. device 要挂接(mount)的设备，可以使用网络设备
    + 如果使用none，表示mount 点没有对应的物理磁盘分区，用于虚拟文件系统，如shm, ramfs, proc 和tmpfs
1. dir 设备在系统上的挂接点(mount point)

对linux系统而言，USB接口的移动硬盘是当作SCSI设备对待的。
可以使用fdisk –l 或 more /proc/partitions查看系统的硬盘和硬盘分区情况。

Windows网络共享的核心是SMB/CIFS，在linux下要挂接(mount)windows的磁盘共享，就必须安装和使用samba 软件包。现在流行的linux发行版绝大多数已经包含了samba软件包，如果安装linux系统时未安装samba请首先安装samba。
当windows系统共享设置好以后，就可以在linux客户端挂接(mount)了

```
mount --bind olddir newdir
```
将一个目录中的内容挂载到另一个目录上，newdir 目录原来的内容并没有被删除，而是当访问到newdir 时原iNode 结点被屏蔽，转到访问olddir 上
有的像链接，但该挂载信息是保存在内存里，如果重启mount 关系会取消掉
该选项只能绑定一个单独的文件系统，而不包含其下级子目录上的文件系统。如果想要递归绑定整个目录树上所有的文件系统，可以使用`--rbind`

```
mount --move olddir newdir
```
移动挂载点，olddir 是一个挂载点，newdir 是一个新的挂载点，该命令把原挂载点的内容移到新位置，而文件的物理位置不变
olddir 不能位于带有"shared"属性的挂载点之下
[提示]可以使用`findmnt -o TARGET,PROPAGATION /dir`命令查看挂载点 /dir 的属性


如果想要开机自动挂载，可以在/etc/fstab 文件中添加挂载记录


譬如 /dev/hda5 已经挂载在/mnt/hda5上,用一下三条命令均可卸载挂载的文件系统
```
umount /dev/hda5
umount /mnt/hda5
umount /dev/hda5 /mnt/hda5
```
如果有程序正在访问这个设备，那么umount 将显示device busy 而无法卸载
最简单的办法就是让访问该设备的程序退出以后再umount。
可能有时候用户搞不清除究竟是什么程序在访问设备，如果用户不急着umount，则可以用-l 选项，并不是马上umount，而是在该目录空闲后再umount

### 举例
#### 挂载光盘镜像
```
mount /dev/cdrom /mnt/cdrom
mount -o loop -t iso9660 /usr/mydisk.iso /mnt/vcdrom
```
#### 挂载USB移动硬盘
```
mount -t ntfs -o iocharset=cp936 /dev/sdc1 /mnt/usbhd1
mount -t vfat -o iocharset=cp936 /dev/sdc5 /mnt/usbhd2
```
#### 挂载windows文件共享
```
mount -t smbfs -o username=admin,password=888888 //192.168.1.2/c$ /mnt/samba
mount -t cifs -o username=xxx,password=xxx //IP/sharename /mnt/dirname
```
### 挂载nfs共享
```
mount -t nfs -o rw 192.168.1.2:/export/home/sunky /mnt/nfs
```
