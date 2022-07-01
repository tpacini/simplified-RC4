//-----------------------------------------------------------------------------------------
module rc4_decr_tb_checks;

    reg clk = 1'b0;
    always #5 clk = !clk;
  
    reg rst_n = 1'b0;
    initial #12.8 rst_n = 1'b1;


    localparam NULL = 8'b0;
    
    reg        din_valid;
    reg  [7:0] seed          [15:0]; 
    reg  [7:0] cipher_bytes0 [10:0]; 
    reg  [7:0] plain_bytes0  [10:0];
    reg  [7:0] cipher_bytes1 [333:0]; 
    reg  [7:0] plain_bytes1  [333:0];
    reg  [7:0] cipher_byte;

    reg  [8:0] index = 0;

    wire [7:0] dout;
    wire       dout_ready;
    wire       init_done;
    
    rc4_decryption instance_rc4(
        .clk (clk),
        .rst_n (rst_n),
        .seed (seed),
        .din (cipher_byte),
        .din_valid (din_valid),
        .dout_ready (dout_ready),
        .dout(dout),
        .init_done (init_done)
    );

    reg  [8:0] QUEUE1 [$];
    reg        QUEUE2 [$];
    reg        DIN_VALID;
    reg  [8:0] INDEX;


    initial begin
        @(posedge rst_n); // wait for rst_n
        $readmemb("tv/seed0.txt", seed);
        $readmemb("tv/cipher0.txt", cipher_bytes0); // 11 bytes
        $readmemb("tv/plain0.txt", plain_bytes0); // 11 bytes

        @(posedge clk);
        din_valid = 0;
        
        @(posedge init_done); // Wait for initialization
        $display("Init done!");
      

        /* Assert din_valid=0 for three times and check if the output
           is consistent with the specifications (use seed0) */
        fork 

            begin: INVALID_IN_3
                for(int i = 0; i < 14; i++) begin
                    if(i == 1 || i == 5 || i == 8) begin
                        din_valid = 0;
                        // cipher_byte = previous_value;
                        @(posedge clk);

                        QUEUE1.push_back(index);
                        QUEUE2.push_back(din_valid);

                    end else begin
                        din_valid = 1;
                        cipher_byte = cipher_bytes0[index];
                        @(posedge clk);

                        QUEUE1.push_back(index);
                        QUEUE2.push_back(din_valid);
                        index += 1;
                    end
   
                end
            end: INVALID_IN_3

            begin: CHECK_DOUT_3
                @(posedge clk);
                $display(" #| %-9s, %-2s", "dout", "dout_ready");
                for(int i = 0; i < 14; i++) begin
                    @(posedge clk);

                    INDEX = QUEUE1.pop_front();
                    DIN_VALID = QUEUE2.pop_front();

                    if (DIN_VALID == 0) begin
                        $display("%2d| %-10s %1d %1d %-5s", i, dout, dout_ready, 0, 0 === dout_ready ? "OK" : "ERROR");
                        if(0 != dout_ready) begin 
                            $stop;
                        end
                    
                    end else begin
                        $display("%2d| %-1s %-1s %-5s, %1d %1d %-5s", i, dout, plain_bytes0[INDEX], 
                            plain_bytes0[INDEX] === dout ? "OK" : "ERROR", dout_ready, 1, 
                            1 === dout_ready ? "OK" : "ERROR");
                        if(plain_bytes0[INDEX] !== dout || 1 != dout_ready) begin 
                            $stop;
                        end
                
                    end 
                end
            end: CHECK_DOUT_3
        
        join // --------------------------------------------------------------------


        din_valid = 0;
        cipher_byte = NULL;
        rst_n = 1'b0;
        @(posedge clk);
        //$readmemb("tv/seed0.txt", seed);
        $readmemb("tv/cipher1.txt", cipher_bytes1); // 334 bytes
        $readmemb("tv/plain1.txt", plain_bytes1); // 334 bytes
        @(posedge clk);
        rst_n = 1'b1;
        $display("Reset done!");

        @(posedge init_done); // Wait for initialization
        $display("Init done!");
      
        /* Long ciphertext (cipher1) with same seed as before (seed0) */ 
        fork
            begin: LONG_CIPHERTEXT_5
                index = 0;
                for(int i = 0; i < 334; i++) begin
                    din_valid = 1;
                    cipher_byte = cipher_bytes1[index];
                    @(posedge clk);

                    QUEUE1.push_back(index);
                    index += 1;
                end 
            end: LONG_CIPHERTEXT_5

            begin: CHECK_DOUT_5
                @(posedge clk);
                for(int i = 0; i < 334; i++) begin
                    @(posedge clk);

                    INDEX = QUEUE1.pop_front();

                    if(plain_bytes1[INDEX] !== dout || 1 != dout_ready) begin
                        $display("%3d| %-1s %-1s %-5s, %1d %1d %-5s", i, dout, plain_bytes1[INDEX], 
                            plain_bytes1[INDEX] === dout ? "OK" : "ERROR", dout_ready, 1, 
                            1 === dout_ready ? "OK" : "ERROR");
                        $display("LONG CIPHERTEXT ERROR"); 
                        $stop;
                    end 
                end

                $display("LONG CIPHERTEXT OK");
            end: CHECK_DOUT_5

        join // --------------------------------------------------------------------

        $display("Done!");
        $stop;
    end

endmodule





//-----------------------------------------------------------------------------
// Decrypts an encrypted file (in RC4 with the same key) into dec.txt and then 
// there is the possibility to check if the decrypted file is equal 
// to the golden-model-generated plaintext file (plain_file.txt)
//-----------------------------------------------------------------------------
module rc4_decr_tb_file;

    reg clk = 1'b0;
    always #5 clk = !clk;
  
    reg rst_n = 1'b0;
    initial #12.8 rst_n = 1'b1;


    localparam NULL = 8'b0; 

    reg        din_valid;
    reg  [7:0] seed          [15:0];
    reg  [7:0] cipher_byte;

    wire [7:0] dout;
    wire       dout_ready;
    wire       init_done;
    
    rc4_decryption instance_rc4(
        .clk (clk),
        .rst_n (rst_n),
        .seed (seed),
        .din (cipher_byte),
        .din_valid (din_valid),
        .dout_ready (dout_ready),
        .dout(dout),
        .init_done (init_done)
    );

    int FP_CTXT;
    int FP_DTXT;
    reg [7:0] char;
    reg [7:0] PTXT [$];
    reg [7:0] CTXT [$];

    initial begin
        @(posedge rst_n);
        $readmemb("tv/seed_file.txt", seed);

        @(posedge clk)
        din_valid = 0;
        FP_CTXT = $fopen("tv/cipher_file.txt", "r");
        $display("Decrypting file 'tv/cipher_file.txt' to 'tv/dec.txt'...");
    
        @(posedge init_done); // Wait for initialization
        $display("Init done!");

        fork
            begin: DECRYPT_1
                while (!$feof(FP_CTXT)) begin
                    $fscanf(FP_CTXT,"%8b ", char);
                    cipher_byte = char;
                    din_valid = 1;
                    @(posedge clk);
                     
                end
                
                din_valid = 0;
                cipher_byte = NULL;
            end: DECRYPT_1

            begin: PUSH_PTXT_1
                @(posedge clk);
                @(posedge clk);
                while (dout_ready == 1) begin
                    
                    PTXT.push_back(dout);
                    @(posedge clk);

                end
            end: PUSH_PTXT_1
        join
            
        $fclose(FP_CTXT);

        // Writing the decrypted text on dec.txt
        FP_DTXT = $fopen("tv/dec.txt", "w");
        foreach(PTXT[i])
            $fwrite(FP_DTXT, "%c", PTXT[i]);
        $fclose(FP_DTXT);
    
        $display("Done!");
        
        $stop;
    end

endmodule