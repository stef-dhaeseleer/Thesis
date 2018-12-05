set count 0
set name "des_axi_8_rounds_"

set fp [open "key_data.txt" r]
set file_data [read $fp]

set data [split $file_data "\n"]
foreach line $data {

    if {$count != 32} {
        set a $name$count

        set test 0xff

        set_property -dict [list CONFIG.key_select {$test}] [get_bd_cells $a]
        set_property -dict [list CONFIG.region {32}] [get_bd_cells  $a]
        puts stdout "Core $count key set to $line"

        incr count
    }
    
}


