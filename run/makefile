clean:
	rm -fr work *~ *.log .*.sv.un~ .*.un~ work transcript *.wlf *.vcd

	
	#rm -fr tb *~ .*.sv.un~ .*.un~ 
	#//Use rm -rf * to delete all files in the directory without any prompt. Prompt occurs when rm encounters any errors such as write access protection. This option helps to avoid it.	
testcase1 = test1
testcase2 = test2
testcase3 = test3
testcase4 = test4
testcase5 = test5
testcase6 = test6
testcase7 = test7
#VSIMBATCH= -c -acdb_file test_cov.acdb  -do "toggle -toggle_type full -ports -rec /tb_top/*;log -rec *;run -all; exit"

# +coverage=bcfst  {note where b=branch
#                            c=code
#							 f=funtion 
#							 s=statement 
#							 t=toggle }
#
# ucbd =unified civerage database

#The acdb_file option is used to specify the name of the coverage database file that is created during simulation. The coverage database file is used to store the coverage data generated during simulation. 

#You can use the vcover command to generate coverage reports from the coverage database file. You can refer to Questa User Manual for more details about UCDB file 

#Unified Coverage Database (UCDB) is a database developed by Mentor Graphics for capture of code coverage, functional coverage, and other metrics together in one place for post-regression analysis and reporting

#  -voptargs is a command line option in Questasim that allows you to pass additional options to the vopt optimization tool. 

#The -voptargs option is used to specify options for the vopt optimization tool. 

#The +acc option is used to enable full visibility of your design. 

#Adding -voptargs=+acc to the Questasim command line will turn off all optimizations and allow all signals to be visible

#-f used for find the test name

# -fr is used for forceful recursive



test:clean 
	vlib work  
	vlog +acc -sv  ../dut/apb_slave.v +indir+../dut ../tb/testbench.sv +indir+../tb -l comp.log 
	vsim -i tb_top +UVM_OBJECTION_TRACE +UVM_TESTNAME=apb_test  -do "add wave -position insertpoint sim:/tb_top/intf/*; coverage save -onexit <TESTSET_CODE_COVER>.ucdb;run -all;quit" -coverage -voptargs="+cover=bcfst" -l sim.log

test1:clean
	vlib work  
	vlog +acc -sv  ../dut/apb_slave.v +indir+../dut ../tb/testbench.sv +indir+../tb -l comp.log
	vsim -i tb_top +UVM_TESTNAME=wrt_only -do "add wave -position insertpoint sim:/tb_top/intf/*; coverage save -onexit <TESTSET_CODE_COVER>.ucdb; run -all;quit" -coverage -voptargs="+cover=bcfst" -l sim.log

test2:clean
	vlib work  	
	vlog +acc -sv  ../dut/apb_slave.v +indir+../dut ../tb/testbench.sv +indir+../tb -l comp.log
	vsim -i tb_top +UVM_TESTNAME=rd_only -do "add wave -position insertpoint sim:/tb_top/intf/*;coverage save -onexit <TESTSET_CODE_COVER>.ucdb; run -all;quit" -coverage -voptargs="+cover=bcfst" -l sim.log

test3:clean
	vlib work  
	vlog +acc -sv ../dut/apb_slave.v +indir+../dut ../tb/testbench.sv +indir+../tb -l comp.log
	vsim -i tb_top +UVM_TESTNAME=wrt_fldb_rd -do "add wave -position insertpoint sim:/tb_top/intf/*; coverage save -onexit <TESTSET_CODE_COVER>.ucdb; run -all;quit" -coverage -voptargs="+cover=bcfst" -l sim.log


test4:clean
	vlib work  
	vlog +acc -sv ../dut/apb_slave.v +indir+../dut ../tb/testbench.sv +indir+../tb -l comp.log
	vsim -i -vopt tb_top +UVM_TESTNAME=rnd_wrt_rd -do "add wave -position insertpoint sim:/tb_top/intf/*; coverage save -onexit <TESTSET_CODE_COVER>.ucdb; run -all;quit" -coverage -voptargs="+cover=bcfst" -l sim.log


test5:clean #wait state 
	vlib work  
	vlog +acc -sv ../dut/apb_slave.v +indir+../dut ../tb/testbench.sv +indir+../tb -l comp.log
	vsim -i tb_top +UVM_TESTNAME=wrt_rd_wit_st -do "add wave -position insertpoint sim:/tb_top/intf/*; coverage save -onexit <TESTSET_CODE_COVER>.ucdb; run -all;quit" -coverage -voptargs="+cover=bcfst" -l sim.log


regression :clean $(testcase1) $(testcase2) $(testcase3) $(testcase4) 
		
	#//vsim -i tb_top add wave -r sim:/tb_top/*; run -all; sim.log
	#//vsim tb_top +UVM_TESTNAME=apb_test; add wave -r sim:/tb_top/*; run -al/
       
