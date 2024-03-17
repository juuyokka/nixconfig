{
  disko.devices =
    let
      boot-disk = "/dev/disk/by-id/nvme-CT1000T700SSD3_2339E87A058B";
      storage-disk = "/dev/disk/by-id/ata-ST8000VN004-3CP101_WWZ3TJSP";
      cache-disk = "/dev/disk/by-id/nvme-SPCC_M.2_PCIe_SSD_AA230717NV204801137";

      storage-vg = "vgstorage";
    in
    {
      disk = {
        boot = {
          type = "disk";
          device = boot-disk;
          content = {
            type = "gpt";
            partitions = {
              ESP = {
                type = "EF00";
                size = "500M";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                  mountOptions = [ "umask=0077" ];
                };
              };
              swap = {
                type = "8200";
                size = "8G";
                content = {
                  type = "swap";
                };
              };
              root = {
                type = "8E00";
                size = "100%";
                content = {
                  type = "lvm_pv";
                  vg = "vgroot";
                };
              };
            };
          };
        };

        storage = {
          type = "disk";
          device = storage-disk;
          content = {
            type = "gpt";
            partitions = {
              primary = {
                type = "8E00";
                size = "100%";
                content = {
                  type = "lvm_pv";
                  vg = storage-vg;
                };
              };
            };
          };
        };

        cache = {
          type = "disk";
          device = cache-disk;
          content = {
            type = "gpt";
            partitions = {
              primary = {
                type = "8E00";
                size = "100%";
                content = {
                  type = "lvm_pv";
                  vg = storage-vg;
                };
              };
            };
          };
        };
      };
      lvm_vg = {
        vgroot = {
          type = "lvm_vg";
          lvs = {
            rootfs = {
              size = "100%FREE";
              content = {
                type = "filesystem";
                format = "xfs";
                mountpoint = "/";
              };
            };
          };
        };

        ${storage-vg} = {
          type = "lvm_vg";
          lvs = {
            pool = {
              size = "100%FREE";
              priority = 1000;
              content = {
                type = "filesystem";
                format = "xfs";
                mountpoint = "/storage";
              };
              extraArgs = [
                storage-vg
                "/dev/disk/by-partlabel/disk-storage-primary"
                "; : << '    ${storage-vg}' #"
              ];
            };

            cachevol = {
              size = "100%FREE";
              extraArgs = [
                "--cache"
                "--chunksize"
                "2M"
                "${storage-vg}/pool"
                "/dev/disk/by-partlabel/disk-cache-primary"
                "; : << '    ${storage-vg}' #"
              ];
            };
          };
        };
      };
    };
}
