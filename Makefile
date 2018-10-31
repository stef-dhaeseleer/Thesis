all:	
	vivado -mode batch -source build.tcl	
	#ln -s ../src/sdk/ rsa_project/rsa_project.sdk

source:
	# source /users/students/data/eagle_repository/eagle.rc
	# source ~micasusr/design/scripts/xilinx_vivado_2017.1.rc

open:
	vivado &

des:
	vivado thesis_des/thesis_des.xpr -tempDir /tmp &

axi:
	vivado test_axi_2/test_axi_2.xpr -tempDir /tmp &

uart:
	screen /dev/ttyACM0 115200

clean:
	rm vivado.* vivado_* .Xil/ -rf webtalk* -f

cleanall: clean
	#rm -rf rsa_project

