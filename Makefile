all:	
	vivado -mode batch -source build.tcl	
	#ln -s ../src/sdk/ rsa_project/rsa_project.sdk

open:
	#vivado rsa_project/rsa_project.xpr -tempDir /tmp &
	# source /users/students/data/eagle_repository/eagle.rc
	# source ~micasusr/design/scripts/xilinx_vivado_2017.1.rc
	vivado thesis_des/thesis_des.xpr -tempDir /tmp &

uart:
	screen /dev/ttyUSB1 115200

clean:
	rm vivado.* vivado_* .Xil/ -rf webtalk* -f

cleanall: clean
	#rm -rf rsa_project

