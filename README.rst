Goatse MBR
==========

A 512-byte bootloader displaying ASCII Goatse on boot.

Bootable USB
============

Create the ``goatse.mbr`` by running ``make``, then copy it onto your USB
drive of choice using ``dd``. Please verify which device points to your USB
using ``fdisk -l``, in the following example we assume it's ``/dev/sdb``::

    dd if=goatse.mbr of=/dev/sdb bs=1 count=512
