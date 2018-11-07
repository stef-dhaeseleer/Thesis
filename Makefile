all:	
	vivado -mode batch -source tcl/build.tcl	
	#ln -s ../src/sdk/ rsa_project/rsa_project.sdk

source:
	# source /users/students/data/eagle_repository/eagle.rc
	# source ~micasusr/design/scripts/xilinx_vivado_2017.1.rc

open:
	vivado &

des:
	#vivado thesis_des/thesis_des.xpr -tempDir /tmp &
	vivado -mode batch -source tcl/open_des.tcl

axi:
	#vivado test_axi_2/test_axi_2.xpr -tempDir /tmp &
	vivado -mode batch -source tcl/open_axi.tcl

uart:
	screen /dev/ttyACM0 115200

clean:
	rm vivado.* vivado_* .Xil/ -rf webtalk* -f

cleanall: clean
	#rm -rf rsa_project

