all:	
	#vivado -mode batch -source build.tcl	
	#ln -s ../src/sdk/ rsa_project/rsa_project.sdk

open:
	#vivado rsa_project/rsa_project.xpr -tempDir /tmp &
	# source /users/students/data/eagle_repository/eagle.rc
	vivado thesis_des/thesis_des.xpr -nolog -nojournal -tempDir /tmp &

uart:
	screen /dev/ttyUSB1 115200

clean:
	#rm vivado.* vivado_* .Xil/ -rf webtalk* -f

cleanall: clean
	#rm -rf rsa_project

