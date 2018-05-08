gluster volume create k8s-volume transport tcp test1-tianyu.io:/opt/gfs_data/ test2-tianyu.io:/opt/gfs_data/ test3-tianyu.io:/opt/gfs_data/ force
gluster volume start k8s-volume
