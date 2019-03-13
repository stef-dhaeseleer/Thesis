
`timescale 1 ns / 1 ps

	module full_axi_four_cores_zcu102_v1_0_S00_AXI #
	    (
            // Users to add parameters here
    
            // User parameters ends
            // Do not modify the parameters beyond this line
    
            // Width of S_AXI data bus
            parameter integer C_S_AXI_DATA_WIDTH    = 32,
            // Width of S_AXI address bus
            parameter integer C_S_AXI_ADDR_WIDTH    = 5
        )
        (
            // Users to add ports here
    
            output wire [31:0] CMD_DATA,
            output wire CMD_DATA_VALID,
            input wire CMD_DATA_READ_0,
            input wire DES_DONE_0,
            input wire CMD_DATA_READ_1,
            input wire DES_DONE_1,
            input wire CMD_DATA_READ_2,
            input wire DES_DONE_2,
            input wire CMD_DATA_READ_3,
            input wire DES_DONE_3,
            input wire [63:0] DES_COUNTER_0,
            input wire [63:0] DES_COUNTER_1,
            input wire [63:0] DES_COUNTER_2,
            input wire [63:0] DES_COUNTER_3,
            output wire [31:0] DATA_UPPER,
            output wire [31:0] DATA_LOWER,
            output wire ACTIVE_CORE_0,
            output wire ACTIVE_CORE_1,
            output wire ACTIVE_CORE_2,
            output wire ACTIVE_CORE_3,
    
            // User ports ends
            // Do not modify the ports beyond this line
    
            // Global Clock Signal
            input wire  S_AXI_ACLK,
            // Global Reset Signal. This Signal is Active LOW
            input wire  S_AXI_ARESETN,
            // Write address (issued by master, acceped by Slave)
            input wire [C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_AWADDR,
            // Write channel Protection type. This signal indicates the
                // privilege and security level of the transaction, and whether
                // the transaction is a data access or an instruction access.
            input wire [2 : 0] S_AXI_AWPROT,
            // Write address valid. This signal indicates that the master signaling
                // valid write address and control information.
            input wire  S_AXI_AWVALID,
            // Write address ready. This signal indicates that the slave is ready
                // to accept an address and associated control signals.
            output wire  S_AXI_AWREADY,
            // Write data (issued by master, acceped by Slave) 
            input wire [C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_WDATA,
            // Write strobes. This signal indicates which byte lanes hold
                // valid data. There is one write strobe bit for each eight
                // bits of the write data bus.    
            input wire [(C_S_AXI_DATA_WIDTH/8)-1 : 0] S_AXI_WSTRB,
            // Write valid. This signal indicates that valid write
                // data and strobes are available.
            input wire  S_AXI_WVALID,
            // Write ready. This signal indicates that the slave
                // can accept the write data.
            output wire  S_AXI_WREADY,
            // Write response. This signal indicates the status
                // of the write transaction.
            output wire [1 : 0] S_AXI_BRESP,
            // Write response valid. This signal indicates that the channel
                // is signaling a valid write response.
            output wire  S_AXI_BVALID,
            // Response ready. This signal indicates that the master
                // can accept a write response.
            input wire  S_AXI_BREADY,
            // Read address (issued by master, acceped by Slave)
            input wire [C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_ARADDR,
            // Protection type. This signal indicates the privilege
                // and security level of the transaction, and whether the
                // transaction is a data access or an instruction access.
            input wire [2 : 0] S_AXI_ARPROT,
            // Read address valid. This signal indicates that the channel
                // is signaling valid read address and control information.
            input wire  S_AXI_ARVALID,
            // Read address ready. This signal indicates that the slave is
                // ready to accept an address and associated control signals.
            output wire  S_AXI_ARREADY,
            // Read data (issued by slave)
            output wire [C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_RDATA,
            // Read response. This signal indicates the status of the
                // read transfer.
            output wire [1 : 0] S_AXI_RRESP,
            // Read valid. This signal indicates that the channel is
                // signaling the required read data.
            output wire  S_AXI_RVALID,
            // Read ready. This signal indicates that the master can
                // accept the read data and response information.
            input wire  S_AXI_RREADY
        );
    
        // AXI4LITE signals
        reg [C_S_AXI_ADDR_WIDTH-1 : 0]     axi_awaddr;
        reg      axi_awready;
        reg      axi_wready;
        reg [1 : 0]     axi_bresp;
        reg      axi_bvalid;
        reg [C_S_AXI_ADDR_WIDTH-1 : 0]     axi_araddr;
        reg      axi_arready;
        reg [C_S_AXI_DATA_WIDTH-1 : 0]     axi_rdata;
        reg [1 : 0]     axi_rresp;
        reg      axi_rvalid;
    
        // Example-specific design signals
        // local parameter for addressing 32 bit / 64 bit C_S_AXI_DATA_WIDTH
        // ADDR_LSB is used for addressing 32/64 bit registers/memories
        // ADDR_LSB = 2 for 32 bits (n downto 2)
        // ADDR_LSB = 3 for 64 bits (n downto 3)
        localparam integer ADDR_LSB = (C_S_AXI_DATA_WIDTH/32) + 1;
        localparam integer OPT_MEM_ADDR_BITS = 2;
        //----------------------------------------------
        //-- Signals for user logic register space example
        //------------------------------------------------
        //-- Number of Slave Registers 7
        reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg0;
        reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg1;
        reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg2;
        reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg3;
        reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg4;
        reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg5;
        reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg6;
        reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg7;
        wire     slv_reg_rden;
        wire     slv_reg_wren;
        reg [C_S_AXI_DATA_WIDTH-1:0]     reg_data_out;
        integer     byte_index;
        reg     aw_en;
    
        // I/O Connections assignments
    
        assign S_AXI_AWREADY    = axi_awready;
        assign S_AXI_WREADY    = axi_wready;
        assign S_AXI_BRESP    = axi_bresp;
        assign S_AXI_BVALID    = axi_bvalid;
        assign S_AXI_ARREADY    = axi_arready;
        assign S_AXI_RDATA    = axi_rdata;
        assign S_AXI_RRESP    = axi_rresp;
        assign S_AXI_RVALID    = axi_rvalid;
        // Implement axi_awready generation
        // axi_awready is asserted for one S_AXI_ACLK clock cycle when both
        // S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_awready is
        // de-asserted when reset is low.
    
        always @( posedge S_AXI_ACLK )
        begin
          if ( S_AXI_ARESETN == 1'b0 )
            begin
              axi_awready <= 1'b0;
              aw_en <= 1'b1;
            end 
          else
            begin    
              if (~axi_awready && S_AXI_AWVALID && S_AXI_WVALID && aw_en)
                begin
                  // slave is ready to accept write address when 
                  // there is a valid write address and write data
                  // on the write address and data bus. This design 
                  // expects no outstanding transactions. 
                  axi_awready <= 1'b1;
                  aw_en <= 1'b0;
                end
                else if (S_AXI_BREADY && axi_bvalid)
                    begin
                      aw_en <= 1'b1;
                      axi_awready <= 1'b0;
                    end
              else           
                begin
                  axi_awready <= 1'b0;
                end
            end 
        end       
    
        // Implement axi_awaddr latching
        // This process is used to latch the address when both 
        // S_AXI_AWVALID and S_AXI_WVALID are valid. 
    
        always @( posedge S_AXI_ACLK )
        begin
          if ( S_AXI_ARESETN == 1'b0 )
            begin
              axi_awaddr <= 0;
            end 
          else
            begin    
              if (~axi_awready && S_AXI_AWVALID && S_AXI_WVALID && aw_en)
                begin
                  // Write Address latching 
                  axi_awaddr <= S_AXI_AWADDR;
                end
            end 
        end       
    
        // Implement axi_wready generation
        // axi_wready is asserted for one S_AXI_ACLK clock cycle when both
        // S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_wready is 
        // de-asserted when reset is low. 
    
        always @( posedge S_AXI_ACLK )
        begin
          if ( S_AXI_ARESETN == 1'b0 )
            begin
              axi_wready <= 1'b0;
            end 
          else
            begin    
              if (~axi_wready && S_AXI_WVALID && S_AXI_AWVALID && aw_en )
                begin
                  // slave is ready to accept write data when 
                  // there is a valid write address and write data
                  // on the write address and data bus. This design 
                  // expects no outstanding transactions. 
                  axi_wready <= 1'b1;
                end
              else
                begin
                  axi_wready <= 1'b0;
                end
            end 
        end       
    
        // Implement memory mapped register select and write logic generation
        // The write data is accepted and written to memory mapped registers when
        // axi_awready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted. Write strobes are used to
        // select byte enables of slave registers while writing.
        // These registers are cleared when reset (active low) is applied.
        // Slave register write enable is asserted when valid address and data are available
        // and the slave is ready to accept the write address and write data.
        assign slv_reg_wren = axi_wready && S_AXI_WVALID && axi_awready && S_AXI_AWVALID;
    
        // ***************

        // Registers needed for the user added logic
        
        // Command and data validity registers
        reg r_cmd_data_valid;
        reg r_data_upper_valid;
        reg r_data_lower_valid;
        
        // Registers with the upper and lower part of the data
        reg [31:0] r_data_upper;
        reg [31:0] r_data_lower;
    
        reg DES_DONE_REG;   // Registers needed for synchronization (for all 4 cores)
        reg CMD_DATA_READ_REG;
        reg DES_DONE_TMP_0;
        reg DES_DONE_REG_0;
        reg CMD_DATA_READ_TMP_0;
        reg CMD_DATA_READ_REG_0;
        reg DES_DONE_TMP_1;
        reg DES_DONE_REG_1;
        reg CMD_DATA_READ_TMP_1;
        reg CMD_DATA_READ_REG_1;
        reg DES_DONE_TMP_2;
        reg DES_DONE_REG_2;
        reg CMD_DATA_READ_TMP_2;
        reg CMD_DATA_READ_REG_2;
        reg DES_DONE_TMP_3;
        reg DES_DONE_REG_3;
        reg CMD_DATA_READ_TMP_3;
        reg CMD_DATA_READ_REG_3;

        // Registers to set which core is active
        reg ACTIVE_CORE_0_REG;
        reg ACTIVE_CORE_1_REG;
        reg ACTIVE_CORE_2_REG;
        reg ACTIVE_CORE_3_REG;

        // Register containing the resulting DES counter
        reg [63:0] DES_COUNTER_REG;
    
        // ***************
    
        always @( posedge S_AXI_ACLK )
        begin
          if ( S_AXI_ARESETN == 1'b0 )
            begin
              slv_reg0 <= 0;
              slv_reg1 <= 0;
              slv_reg2 <= 0;
              slv_reg3 <= 0;
              slv_reg4 <= 0;
              slv_reg5 <= 0;
              slv_reg6 <= 0;
              slv_reg7 <= 0;
    
              // **************
              r_cmd_data_valid <= 1'b0;
              r_data_upper_valid <= 1'b0;
              r_data_lower_valid <= 1'b0;
              // **************
    
            end 
          else begin
    
            r_data_upper_valid <= 1'b0; // Set to zero when not written to, this way it only stays high one cycle
            r_data_lower_valid <= 1'b0; // Set to zero when not written to, this way it only stays high one cycle
    
            slv_reg4 <= DES_COUNTER_REG[63:32];  // Set to the upper part of the counter for the PS to read
            slv_reg5 <= DES_COUNTER_REG[31:0];   // Set to the lower part of the counter for the PS to read
    
            if (slv_reg_wren)
              begin
                case ( axi_awaddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB] )
    
                  3'h0: // THIS IS THE CMD REG
                    for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                      if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                        // Respective byte enables are asserted as per write strobes 
                        // Slave register 0
                        slv_reg0[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
    
                        // ************** 
                        // Set cmd_data_valid to one as a new valid CMD has been written
                        // Set CMD_READ register to zero to avoid issues
                        r_cmd_data_valid <= 1'b1;
                        slv_reg3 <= 1'b0;
                        // **************
    
                      end  
    
                  3'h1: // THIS IS THE DATA_UPPER REG
                    for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                      if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                        // Respective byte enables are asserted as per write strobes 
                        // Slave register 1
                        slv_reg1[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                        
                        // **************
                        r_data_upper_valid <= 1'b1;
                        // **************
    
                      end  
    
                  3'h2: // THIS IS THE DATA_LOWER REG
                    for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                      if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                        // Respective byte enables are asserted as per write strobes 
                        // Slave register 2
                        slv_reg2[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
    
                        // **************
                        r_data_lower_valid <= 1'b1;
                        // **************
    
                      end  
    
                  // *****************************************************************************************
    
                  3'h3: // THIS IS THE CMD_READ RGISTER
                    for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                      if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                        // Respective byte enables are asserted as per write strobes 
                        // Slave register 3
                        //slv_reg3[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
    
                        // slave register is used by the PL to signal to the PS
                        // This register can thus not be set by the AXI slave
                      end 
    
                  3'h4: // THIS IS THE UPPER COUNTER REG
                    for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                      if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                        // Respective byte enables are asserted as per write strobes 
                        // Slave register 4
                        //slv_reg4[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
    
                        // slave register is used by the PL to signal to the PS
                        // This register can thus not be set by the AXI slave
                      end  
    
                  3'h5: // THIS IS THE LOWER COUNTER REG
                    for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                      if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                        // Respective byte enables are asserted as per write strobes 
                        // Slave register 5
                        //slv_reg5[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
    
                        // slave register is used by the PL to signal to the PS
                        // This register can thus not be set by the AXI slave
                      end  
    
                  3'h6:  // THIS IS THE DONE REGISTER
                    for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                      if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                        // Respective byte enables are asserted as per write strobes 
                        // Slave register 6
                        //slv_reg6[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
    
                        // slave register is used by the PL to signal to the PS
                        // This register can thus not be set by the AXI slave
                      end

                  3'h7: // THIS IS THE CORE SELECT REGISTER
                    for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                      if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                        // Respective byte enables are asserted as per write strobes 
                        // Slave register 7
                        slv_reg7[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                      end  
    
                  default : begin
                              slv_reg0 <= slv_reg0;
                              slv_reg1 <= slv_reg1;
                              slv_reg2 <= slv_reg2;
                              slv_reg3 <= slv_reg3;
                              slv_reg4 <= slv_reg4;
                              slv_reg5 <= slv_reg5;
                              slv_reg6 <= slv_reg6;
                              slv_reg7 <= slv_reg7;
                            end
                endcase
              end
    
              // ********************
    
              else begin
                    if (CMD_DATA_READ_REG == 1'b1) begin    // Indicates that the wrapper has read the command
                        r_cmd_data_valid <= 1'b0;           // Set to zero to communicate that we know the wrapper read the command
                        r_data_upper_valid <= 1'b0;         
                        r_data_lower_valid <= 1'b0;
                        slv_reg3 <= 1'b1;                   // CMD_READ to one for PS to read
                    end
    
                    if (CMD_DATA_VALID == 1'b1) begin
                        slv_reg6 <= 0;  // This is the done signal, set to zero when a command is received
                    end
    
                    if (r_data_upper_valid == 1'b1) begin
                       r_data_upper <= slv_reg1;   // Buffer the data upper from the slave reg into another reg
                    end
    
                    if (r_data_lower_valid == 1'b1) begin
                        r_data_lower <= slv_reg2;   // Buffer the data lower from the slave reg into another reg
                    end
    
                    if (DES_DONE_REG == 1'b1) begin
                        slv_reg6 <= 1;  // This is the done signal, set to one here when DES is done
                    end
              end
    
              // ********************
          end
        end    
    
        // Implement write response logic generation
        // The write response and response valid signals are asserted by the slave 
        // when axi_wready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted.  
        // This marks the acceptance of address and indicates the status of 
        // write transaction.
    
        always @( posedge S_AXI_ACLK )
        begin
          if ( S_AXI_ARESETN == 1'b0 )
            begin
              axi_bvalid  <= 0;
              axi_bresp   <= 2'b0;
            end 
          else
            begin    
              if (axi_awready && S_AXI_AWVALID && ~axi_bvalid && axi_wready && S_AXI_WVALID)
                begin
                  // indicates a valid write response is available
                  axi_bvalid <= 1'b1;
                  axi_bresp  <= 2'b0; // 'OKAY' response 
                end                   // work error responses in future
              else
                begin
                  if (S_AXI_BREADY && axi_bvalid) 
                    //check if bready is asserted while bvalid is high) 
                    //(there is a possibility that bready is always asserted high)   
                    begin
                      axi_bvalid <= 1'b0; 
                    end  
                end
            end
        end   
    
        // Implement axi_arready generation
        // axi_arready is asserted for one S_AXI_ACLK clock cycle when
        // S_AXI_ARVALID is asserted. axi_awready is 
        // de-asserted when reset (active low) is asserted. 
        // The read address is also latched when S_AXI_ARVALID is 
        // asserted. axi_araddr is reset to zero on reset assertion.
    
        always @( posedge S_AXI_ACLK )
        begin
          if ( S_AXI_ARESETN == 1'b0 )
            begin
              axi_arready <= 1'b0;
              axi_araddr  <= 32'b0;
            end 
          else
            begin    
              if (~axi_arready && S_AXI_ARVALID)
                begin
                  // indicates that the slave has acceped the valid read address
                  axi_arready <= 1'b1;
                  // Read address latching
                  axi_araddr  <= S_AXI_ARADDR;
                end
              else
                begin
                  axi_arready <= 1'b0;
                end
            end 
        end       
    
        // Implement axi_arvalid generation
        // axi_rvalid is asserted for one S_AXI_ACLK clock cycle when both 
        // S_AXI_ARVALID and axi_arready are asserted. The slave registers 
        // data are available on the axi_rdata bus at this instance. The 
        // assertion of axi_rvalid marks the validity of read data on the 
        // bus and axi_rresp indicates the status of read transaction.axi_rvalid 
        // is deasserted on reset (active low). axi_rresp and axi_rdata are 
        // cleared to zero on reset (active low).  
        always @( posedge S_AXI_ACLK )
        begin
          if ( S_AXI_ARESETN == 1'b0 )
            begin
              axi_rvalid <= 0;
              axi_rresp  <= 0;
            end 
          else
            begin    
              if (axi_arready && S_AXI_ARVALID && ~axi_rvalid)
                begin
                  // Valid read data is available at the read data bus
                  axi_rvalid <= 1'b1;
                  axi_rresp  <= 2'b0; // 'OKAY' response
                end   
              else if (axi_rvalid && S_AXI_RREADY)
                begin
                  // Read data is accepted by the master
                  axi_rvalid <= 1'b0;
                end                
            end
        end    
    
        // Implement memory mapped register select and read logic generation
        // Slave register read enable is asserted when valid address is available
        // and the slave is ready to accept the read address.
        assign slv_reg_rden = axi_arready & S_AXI_ARVALID & ~axi_rvalid;
        always @(*)
        begin
              // Address decoding for reading registers
              case ( axi_araddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB] )
                3'h0   : reg_data_out <= slv_reg0;
                3'h1   : reg_data_out <= slv_reg1;
                3'h2   : reg_data_out <= slv_reg2;
                3'h3   : reg_data_out <= slv_reg3;
                3'h4   : reg_data_out <= slv_reg4;
                3'h5   : reg_data_out <= slv_reg5;
                3'h6   : reg_data_out <= slv_reg6;
                3'h7   : reg_data_out <= slv_reg7;
                default : reg_data_out <= 0;
              endcase
        end
    
        // Output register or memory read data
        always @( posedge S_AXI_ACLK )
        begin
          if ( S_AXI_ARESETN == 1'b0 )
            begin
              axi_rdata  <= 0;
            end 
          else
            begin    
              // When there is a valid read address (S_AXI_ARVALID) with 
              // acceptance of read address by the slave (axi_arready), 
              // output the read dada 
              if (slv_reg_rden)
                begin
                  axi_rdata <= reg_data_out;     // register read data
                end   
            end
        end    
    
        // Add user logic here ###################################################################################

        // Assign the output wires
        assign CMD_DATA = slv_reg0;
        assign CMD_DATA_VALID = r_cmd_data_valid;
        assign DATA_UPPER = r_data_upper;
        assign DATA_LOWER = r_data_lower;

        assign ACTIVE_CORE_0 = ACTIVE_CORE_0_REG;
        assign ACTIVE_CORE_1 = ACTIVE_CORE_1_REG;
        assign ACTIVE_CORE_2 = ACTIVE_CORE_2_REG;
        assign ACTIVE_CORE_3 = ACTIVE_CORE_3_REG;
    
        // Synchronization logic for DES_DONE, CMD_DATA_READ
        always @(posedge S_AXI_ACLK) begin     // Synchronization of incomming values from different clock domain
    
            if ( S_AXI_ARESETN == 1'b0 ) begin // Reset the regs to zero
                DES_DONE_TMP_0 <= 0;
                DES_DONE_REG_0 <= 0;
                CMD_DATA_READ_TMP_0 <= 0;
                CMD_DATA_READ_REG_0 <= 0;

                DES_DONE_TMP_1 <= 0;
                DES_DONE_REG_1 <= 0;
                CMD_DATA_READ_TMP_1 <= 0;
                CMD_DATA_READ_REG_1 <= 0;

                DES_DONE_TMP_2 <= 0;
                DES_DONE_REG_2 <= 0;
                CMD_DATA_READ_TMP_2 <= 0;
                CMD_DATA_READ_REG_2 <= 0;

                DES_DONE_TMP_3 <= 0;
                DES_DONE_REG_3 <= 0;
                CMD_DATA_READ_TMP_3 <= 0;
                CMD_DATA_READ_REG_3 <= 0;
            end
            else begin
                DES_DONE_TMP_0 <= DES_DONE_0;
                DES_DONE_REG_0 <= DES_DONE_TMP_0;
                CMD_DATA_READ_TMP_0 <= CMD_DATA_READ_0;
                CMD_DATA_READ_REG_0 <= CMD_DATA_READ_TMP_0;

                DES_DONE_TMP_1 <= DES_DONE_1;
                DES_DONE_REG_1 <= DES_DONE_TMP_1;
                CMD_DATA_READ_TMP_1 <= CMD_DATA_READ_1;
                CMD_DATA_READ_REG_1 <= CMD_DATA_READ_TMP_1;

                DES_DONE_TMP_2 <= DES_DONE_2;
                DES_DONE_REG_2 <= DES_DONE_TMP_2;
                CMD_DATA_READ_TMP_2 <= CMD_DATA_READ_2;
                CMD_DATA_READ_REG_2 <= CMD_DATA_READ_TMP_2;

                DES_DONE_TMP_3 <= DES_DONE_3;
                DES_DONE_REG_3 <= DES_DONE_TMP_3;
                CMD_DATA_READ_TMP_3 <= CMD_DATA_READ_3;
                CMD_DATA_READ_REG_3 <= CMD_DATA_READ_TMP_3;
            end
        end

        // Core select output logic
        always @(posedge S_AXI_ACLK) begin     // Set output according to which core is active

            ACTIVE_CORE_0_REG <= 1'b0;
            ACTIVE_CORE_1_REG <= 1'b0;
            ACTIVE_CORE_2_REG <= 1'b0;
            ACTIVE_CORE_3_REG <= 1'b0;
    
            if ( slv_reg7 == 32'h0 ) begin // Set core 0
                ACTIVE_CORE_0_REG <= 1'b1;
                DES_COUNTER_REG <= DES_COUNTER_0;
                DES_DONE_REG <= DES_DONE_REG_0;
                CMD_DATA_READ_REG <= CMD_DATA_READ_REG_0;
            end

            if ( slv_reg7 == 32'h1 ) begin // Set core 1
                ACTIVE_CORE_1_REG <= 1'b1;
                DES_COUNTER_REG <= DES_COUNTER_1;
                DES_DONE_REG <= DES_DONE_REG_1;
                CMD_DATA_READ_REG <= CMD_DATA_READ_REG_1;
            end

            if ( slv_reg7 == 32'h2 ) begin // Set core 2
                ACTIVE_CORE_2_REG <= 1'b1;
                DES_COUNTER_REG <= DES_COUNTER_2;
                DES_DONE_REG <= DES_DONE_REG_2;
                CMD_DATA_READ_REG <= CMD_DATA_READ_REG_2;
            end

            if ( slv_reg7 == 32'h3 ) begin // set core 3
                ACTIVE_CORE_3_REG <= 1'b1;
                DES_COUNTER_REG <= DES_COUNTER_3;
                DES_DONE_REG <= DES_DONE_REG_3;
                CMD_DATA_READ_REG <= CMD_DATA_READ_REG_3;
            end
             
        end
    
        // User logic ends
    
        endmodule
