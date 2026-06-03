module rx_symbol_sync_corr(
	input [63:0] I_data_sign_i,
	input [63:0] I_data_sign_q,
	output [11:0] O_abs_Ck
);

reg [11:0] R_cmult_out_i[0:63];
reg [11:0] R_cmult_out_q[0:63];

always @(*) begin
	// conj(lts)*(1+j)
	if((I_data_sign_i[0]==0)&&(I_data_sign_q[0]==0)) begin
		R_cmult_out_i[0]<= 14;
		R_cmult_out_q[0]<= 4080;
	end
	// conj(lts)*(1-j)
	else if((I_data_sign_i[0]==0)&&(I_data_sign_q[0]==1)) begin
		R_cmult_out_i[0]<= 4080;
		R_cmult_out_q[0]<= 4082;
	end
	// conj(lts)*(-1+j)
	else if((I_data_sign_i[0]==1)&&(I_data_sign_q[0]==0)) begin
		R_cmult_out_i[0]<= 16;
		R_cmult_out_q[0]<= 14;
	end
	// conj(lts)*(-1-j)
	else begin
		R_cmult_out_i[0]<= 4082;
		R_cmult_out_q[0]<= 16;
	end
end

always @(*) begin
	// conj(lts)*(1+j)
	if((I_data_sign_i[1]==0)&&(I_data_sign_q[1]==0)) begin
		R_cmult_out_i[1]<= 19;
		R_cmult_out_q[1]<= 4087;
	end
	// conj(lts)*(1-j)
	else if((I_data_sign_i[1]==0)&&(I_data_sign_q[1]==1)) begin
		R_cmult_out_i[1]<= 4087;
		R_cmult_out_q[1]<= 4077;
	end
	// conj(lts)*(-1+j)
	else if((I_data_sign_i[1]==1)&&(I_data_sign_q[1]==0)) begin
		R_cmult_out_i[1]<= 9;
		R_cmult_out_q[1]<= 19;
	end
	// conj(lts)*(-1-j)
	else begin
		R_cmult_out_i[1]<= 4077;
		R_cmult_out_q[1]<= 9;
	end
end

always @(*) begin
	// conj(lts)*(1+j)
	if((I_data_sign_i[2]==0)&&(I_data_sign_q[2]==0)) begin
		R_cmult_out_i[2]<= 1;
		R_cmult_out_q[2]<= 23;
	end
	// conj(lts)*(1-j)
	else if((I_data_sign_i[2]==0)&&(I_data_sign_q[2]==1)) begin
		R_cmult_out_i[2]<= 23;
		R_cmult_out_q[2]<= 4095;
	end
	// conj(lts)*(-1+j)
	else if((I_data_sign_i[2]==1)&&(I_data_sign_q[2]==0)) begin
		R_cmult_out_i[2]<= 4073;
		R_cmult_out_q[2]<= 1;
	end
	// conj(lts)*(-1-j)
	else begin
		R_cmult_out_i[2]<= 4095;
		R_cmult_out_q[2]<= 4073;
	end
end

always @(*) begin
	// conj(lts)*(1+j)
	if((I_data_sign_i[3]==0)&&(I_data_sign_q[3]==0)) begin
		R_cmult_out_i[3]<= 4095;
		R_cmult_out_q[3]<= 7;
	end
	// conj(lts)*(1-j)
	else if((I_data_sign_i[3]==0)&&(I_data_sign_q[3]==1)) begin
		R_cmult_out_i[3]<= 7;
		R_cmult_out_q[3]<= 1;
	end
	// conj(lts)*(-1+j)
	else if((I_data_sign_i[3]==1)&&(I_data_sign_q[3]==0)) begin
		R_cmult_out_i[3]<= 4089;
		R_cmult_out_q[3]<= 4095;
	end
	// conj(lts)*(-1-j)
	else begin
		R_cmult_out_i[3]<= 1;
		R_cmult_out_q[3]<= 4089;
	end
end

always @(*) begin
	// conj(lts)*(1+j)
	if((I_data_sign_i[4]==0)&&(I_data_sign_q[4]==0)) begin
		R_cmult_out_i[4]<= 19;
		R_cmult_out_q[4]<= 4093;
	end
	// conj(lts)*(1-j)
	else if((I_data_sign_i[4]==0)&&(I_data_sign_q[4]==1)) begin
		R_cmult_out_i[4]<= 4093;
		R_cmult_out_q[4]<= 4077;
	end
	// conj(lts)*(-1+j)
	else if((I_data_sign_i[4]==1)&&(I_data_sign_q[4]==0)) begin
		R_cmult_out_i[4]<= 3;
		R_cmult_out_q[4]<= 19;
	end
	// conj(lts)*(-1-j)
	else begin
		R_cmult_out_i[4]<= 4077;
		R_cmult_out_q[4]<= 3;
	end
end

always @(*) begin
	// conj(lts)*(1+j)
	if((I_data_sign_i[5]==0)&&(I_data_sign_q[5]==0)) begin
		R_cmult_out_i[5]<= 4088;
		R_cmult_out_q[5]<= 4074;
	end
	// conj(lts)*(1-j)
	else if((I_data_sign_i[5]==0)&&(I_data_sign_q[5]==1)) begin
		R_cmult_out_i[5]<= 4074;
		R_cmult_out_q[5]<= 8;
	end
	// conj(lts)*(-1+j)
	else if((I_data_sign_i[5]==1)&&(I_data_sign_q[5]==0)) begin
		R_cmult_out_i[5]<= 22;
		R_cmult_out_q[5]<= 4088;
	end
	// conj(lts)*(-1-j)
	else begin
		R_cmult_out_i[5]<= 8;
		R_cmult_out_q[5]<= 22;
	end
end

always @(*) begin
	// conj(lts)*(1+j)
	if((I_data_sign_i[6]==0)&&(I_data_sign_q[6]==0)) begin
		R_cmult_out_i[6]<= 9;
		R_cmult_out_q[6]<= 4077;
	end
	// conj(lts)*(1-j)
	else if((I_data_sign_i[6]==0)&&(I_data_sign_q[6]==1)) begin
		R_cmult_out_i[6]<= 4077;
		R_cmult_out_q[6]<= 4087;
	end
	// conj(lts)*(-1+j)
	else if((I_data_sign_i[6]==1)&&(I_data_sign_q[6]==0)) begin
		R_cmult_out_i[6]<= 19;
		R_cmult_out_q[6]<= 9;
	end
	// conj(lts)*(-1-j)
	else begin
		R_cmult_out_i[6]<= 4087;
		R_cmult_out_q[6]<= 19;
	end
end

always @(*) begin
	// conj(lts)*(1+j)
	if((I_data_sign_i[7]==0)&&(I_data_sign_q[7]==0)) begin
		R_cmult_out_i[7]<= 15;
		R_cmult_out_q[7]<= 9;
	end
	// conj(lts)*(1-j)
	else if((I_data_sign_i[7]==0)&&(I_data_sign_q[7]==1)) begin
		R_cmult_out_i[7]<= 9;
		R_cmult_out_q[7]<= 4081;
	end
	// conj(lts)*(-1+j)
	else if((I_data_sign_i[7]==1)&&(I_data_sign_q[7]==0)) begin
		R_cmult_out_i[7]<= 4087;
		R_cmult_out_q[7]<= 15;
	end
	// conj(lts)*(-1-j)
	else begin
		R_cmult_out_i[7]<= 4081;
		R_cmult_out_q[7]<= 4087;
	end
end

always @(*) begin
	// conj(lts)*(1+j)
	if((I_data_sign_i[8]==0)&&(I_data_sign_q[8]==0)) begin
		R_cmult_out_i[8]<= 6;
		R_cmult_out_q[8]<= 8;
	end
	// conj(lts)*(1-j)
	else if((I_data_sign_i[8]==0)&&(I_data_sign_q[8]==1)) begin
		R_cmult_out_i[8]<= 8;
		R_cmult_out_q[8]<= 4090;
	end
	// conj(lts)*(-1+j)
	else if((I_data_sign_i[8]==1)&&(I_data_sign_q[8]==0)) begin
		R_cmult_out_i[8]<= 4088;
		R_cmult_out_q[8]<= 6;
	end
	// conj(lts)*(-1-j)
	else begin
		R_cmult_out_i[8]<= 4090;
		R_cmult_out_q[8]<= 4088;
	end
end

always @(*) begin
	// conj(lts)*(1+j)
	if((I_data_sign_i[9]==0)&&(I_data_sign_q[9]==0)) begin
		R_cmult_out_i[9]<= 15;
		R_cmult_out_q[9]<= 4081;
	end
	// conj(lts)*(1-j)
	else if((I_data_sign_i[9]==0)&&(I_data_sign_q[9]==1)) begin
		R_cmult_out_i[9]<= 4081;
		R_cmult_out_q[9]<= 4081;
	end
	// conj(lts)*(-1+j)
	else if((I_data_sign_i[9]==1)&&(I_data_sign_q[9]==0)) begin
		R_cmult_out_i[9]<= 15;
		R_cmult_out_q[9]<= 15;
	end
	// conj(lts)*(-1-j)
	else begin
		R_cmult_out_i[9]<= 4081;
		R_cmult_out_q[9]<= 15;
	end
end

always @(*) begin
	// conj(lts)*(1+j)
	if((I_data_sign_i[10]==0)&&(I_data_sign_q[10]==0)) begin
		R_cmult_out_i[10]<= 4084;
		R_cmult_out_q[10]<= 4072;
	end
	// conj(lts)*(1-j)
	else if((I_data_sign_i[10]==0)&&(I_data_sign_q[10]==1)) begin
		R_cmult_out_i[10]<= 4072;
		R_cmult_out_q[10]<= 12;
	end
	// conj(lts)*(-1+j)
	else if((I_data_sign_i[10]==1)&&(I_data_sign_q[10]==0)) begin
		R_cmult_out_i[10]<= 24;
		R_cmult_out_q[10]<= 4084;
	end
	// conj(lts)*(-1-j)
	else begin
		R_cmult_out_i[10]<= 12;
		R_cmult_out_q[10]<= 24;
	end
end

always @(*) begin
	// conj(lts)*(1+j)
	if((I_data_sign_i[11]==0)&&(I_data_sign_q[11]==0)) begin
		R_cmult_out_i[11]<= 10;
		R_cmult_out_q[11]<= 4092;
	end
	// conj(lts)*(1-j)
	else if((I_data_sign_i[11]==0)&&(I_data_sign_q[11]==1)) begin
		R_cmult_out_i[11]<= 4092;
		R_cmult_out_q[11]<= 4086;
	end
	// conj(lts)*(-1+j)
	else if((I_data_sign_i[11]==1)&&(I_data_sign_q[11]==0)) begin
		R_cmult_out_i[11]<= 4;
		R_cmult_out_q[11]<= 10;
	end
	// conj(lts)*(-1-j)
	else begin
		R_cmult_out_i[11]<= 4086;
		R_cmult_out_q[11]<= 4;
	end
end

always @(*) begin
	// conj(lts)*(1+j)
	if((I_data_sign_i[12]==0)&&(I_data_sign_q[12]==0)) begin
		R_cmult_out_i[12]<= 10;
		R_cmult_out_q[12]<= 6;
	end
	// conj(lts)*(1-j)
	else if((I_data_sign_i[12]==0)&&(I_data_sign_q[12]==1)) begin
		R_cmult_out_i[12]<= 6;
		R_cmult_out_q[12]<= 4086;
	end
	// conj(lts)*(-1+j)
	else if((I_data_sign_i[12]==1)&&(I_data_sign_q[12]==0)) begin
		R_cmult_out_i[12]<= 4090;
		R_cmult_out_q[12]<= 10;
	end
	// conj(lts)*(-1-j)
	else begin
		R_cmult_out_i[12]<= 4086;
		R_cmult_out_q[12]<= 4090;
	end
end

always @(*) begin
	// conj(lts)*(1+j)
	if((I_data_sign_i[13]==0)&&(I_data_sign_q[13]==0)) begin
		R_cmult_out_i[13]<= 4072;
		R_cmult_out_q[13]<= 18;
	end
	// conj(lts)*(1-j)
	else if((I_data_sign_i[13]==0)&&(I_data_sign_q[13]==1)) begin
		R_cmult_out_i[13]<= 18;
		R_cmult_out_q[13]<= 24;
	end
	// conj(lts)*(-1+j)
	else if((I_data_sign_i[13]==1)&&(I_data_sign_q[13]==0)) begin
		R_cmult_out_i[13]<= 4078;
		R_cmult_out_q[13]<= 4072;
	end
	// conj(lts)*(-1-j)
	else begin
		R_cmult_out_i[13]<= 24;
		R_cmult_out_q[13]<= 4078;
	end
end

always @(*) begin
	// conj(lts)*(1+j)
	if((I_data_sign_i[14]==0)&&(I_data_sign_q[14]==0)) begin
		R_cmult_out_i[14]<= 16;
		R_cmult_out_q[14]<= 14;
	end
	// conj(lts)*(1-j)
	else if((I_data_sign_i[14]==0)&&(I_data_sign_q[14]==1)) begin
		R_cmult_out_i[14]<= 14;
		R_cmult_out_q[14]<= 4080;
	end
	// conj(lts)*(-1+j)
	else if((I_data_sign_i[14]==1)&&(I_data_sign_q[14]==0)) begin
		R_cmult_out_i[14]<= 4082;
		R_cmult_out_q[14]<= 16;
	end
	// conj(lts)*(-1-j)
	else begin
		R_cmult_out_i[14]<= 4080;
		R_cmult_out_q[14]<= 4082;
	end
end

always @(*) begin
	// conj(lts)*(1+j)
	if((I_data_sign_i[15]==0)&&(I_data_sign_q[15]==0)) begin
		R_cmult_out_i[15]<= 16;
		R_cmult_out_q[15]<= 0;
	end
	// conj(lts)*(1-j)
	else if((I_data_sign_i[15]==0)&&(I_data_sign_q[15]==1)) begin
		R_cmult_out_i[15]<= 0;
		R_cmult_out_q[15]<= 4080;
	end
	// conj(lts)*(-1+j)
	else if((I_data_sign_i[15]==1)&&(I_data_sign_q[15]==0)) begin
		R_cmult_out_i[15]<= 0;
		R_cmult_out_q[15]<= 16;
	end
	// conj(lts)*(-1-j)
	else begin
		R_cmult_out_i[15]<= 4080;
		R_cmult_out_q[15]<= 0;
	end
end

always @(*) begin
	// conj(lts)*(1+j)
	if((I_data_sign_i[16]==0)&&(I_data_sign_q[16]==0)) begin
		R_cmult_out_i[16]<= 4088;
		R_cmult_out_q[16]<= 18;
	end
	// conj(lts)*(1-j)
	else if((I_data_sign_i[16]==0)&&(I_data_sign_q[16]==1)) begin
		R_cmult_out_i[16]<= 18;
		R_cmult_out_q[16]<= 8;
	end
	// conj(lts)*(-1+j)
	else if((I_data_sign_i[16]==1)&&(I_data_sign_q[16]==0)) begin
		R_cmult_out_i[16]<= 4078;
		R_cmult_out_q[16]<= 4088;
	end
	// conj(lts)*(-1-j)
	else begin
		R_cmult_out_i[16]<= 8;
		R_cmult_out_q[16]<= 4078;
	end
end

always @(*) begin
	// conj(lts)*(1+j)
	if((I_data_sign_i[17]==0)&&(I_data_sign_q[17]==0)) begin
		R_cmult_out_i[17]<= 4084;
		R_cmult_out_q[17]<= 4094;
	end
	// conj(lts)*(1-j)
	else if((I_data_sign_i[17]==0)&&(I_data_sign_q[17]==1)) begin
		R_cmult_out_i[17]<= 4094;
		R_cmult_out_q[17]<= 12;
	end
	// conj(lts)*(-1+j)
	else if((I_data_sign_i[17]==1)&&(I_data_sign_q[17]==0)) begin
		R_cmult_out_i[17]<= 2;
		R_cmult_out_q[17]<= 4084;
	end
	// conj(lts)*(-1-j)
	else begin
		R_cmult_out_i[17]<= 12;
		R_cmult_out_q[17]<= 2;
	end
end

always @(*) begin
	// conj(lts)*(1+j)
	if((I_data_sign_i[18]==0)&&(I_data_sign_q[18]==0)) begin
		R_cmult_out_i[18]<= 4071;
		R_cmult_out_q[18]<= 4087;
	end
	// conj(lts)*(1-j)
	else if((I_data_sign_i[18]==0)&&(I_data_sign_q[18]==1)) begin
		R_cmult_out_i[18]<= 4087;
		R_cmult_out_q[18]<= 25;
	end
	// conj(lts)*(-1+j)
	else if((I_data_sign_i[18]==1)&&(I_data_sign_q[18]==0)) begin
		R_cmult_out_i[18]<= 9;
		R_cmult_out_q[18]<= 4071;
	end
	// conj(lts)*(-1-j)
	else begin
		R_cmult_out_i[18]<= 25;
		R_cmult_out_q[18]<= 9;
	end
end

always @(*) begin
	// conj(lts)*(1+j)
	if((I_data_sign_i[19]==0)&&(I_data_sign_q[19]==0)) begin
		R_cmult_out_i[19]<= 4095;
		R_cmult_out_q[19]<= 23;
	end
	// conj(lts)*(1-j)
	else if((I_data_sign_i[19]==0)&&(I_data_sign_q[19]==1)) begin
		R_cmult_out_i[19]<= 23;
		R_cmult_out_q[19]<= 1;
	end
	// conj(lts)*(-1+j)
	else if((I_data_sign_i[19]==1)&&(I_data_sign_q[19]==0)) begin
		R_cmult_out_i[19]<= 4073;
		R_cmult_out_q[19]<= 4095;
	end
	// conj(lts)*(-1-j)
	else begin
		R_cmult_out_i[19]<= 1;
		R_cmult_out_q[19]<= 4073;
	end
end

always @(*) begin
	// conj(lts)*(1+j)
	if((I_data_sign_i[20]==0)&&(I_data_sign_q[20]==0)) begin
		R_cmult_out_i[20]<= 7;
		R_cmult_out_q[20]<= 11;
	end
	// conj(lts)*(1-j)
	else if((I_data_sign_i[20]==0)&&(I_data_sign_q[20]==1)) begin
		R_cmult_out_i[20]<= 11;
		R_cmult_out_q[20]<= 4089;
	end
	// conj(lts)*(-1+j)
	else if((I_data_sign_i[20]==1)&&(I_data_sign_q[20]==0)) begin
		R_cmult_out_i[20]<= 4085;
		R_cmult_out_q[20]<= 7;
	end
	// conj(lts)*(-1-j)
	else begin
		R_cmult_out_i[20]<= 4089;
		R_cmult_out_q[20]<= 4085;
	end
end

always @(*) begin
	// conj(lts)*(1+j)
	if((I_data_sign_i[21]==0)&&(I_data_sign_q[21]==0)) begin
		R_cmult_out_i[21]<= 4078;
		R_cmult_out_q[21]<= 2;
	end
	// conj(lts)*(1-j)
	else if((I_data_sign_i[21]==0)&&(I_data_sign_q[21]==1)) begin
		R_cmult_out_i[21]<= 2;
		R_cmult_out_q[21]<= 18;
	end
	// conj(lts)*(-1+j)
	else if((I_data_sign_i[21]==1)&&(I_data_sign_q[21]==0)) begin
		R_cmult_out_i[21]<= 4094;
		R_cmult_out_q[21]<= 4078;
	end
	// conj(lts)*(-1-j)
	else begin
		R_cmult_out_i[21]<= 18;
		R_cmult_out_q[21]<= 4094;
	end
end

always @(*) begin
	// conj(lts)*(1+j)
	if((I_data_sign_i[22]==0)&&(I_data_sign_q[22]==0)) begin
		R_cmult_out_i[22]<= 4092;
		R_cmult_out_q[22]<= 4086;
	end
	// conj(lts)*(1-j)
	else if((I_data_sign_i[22]==0)&&(I_data_sign_q[22]==1)) begin
		R_cmult_out_i[22]<= 4086;
		R_cmult_out_q[22]<= 4;
	end
	// conj(lts)*(-1+j)
	else if((I_data_sign_i[22]==1)&&(I_data_sign_q[22]==0)) begin
		R_cmult_out_i[22]<= 10;
		R_cmult_out_q[22]<= 4092;
	end
	// conj(lts)*(-1-j)
	else begin
		R_cmult_out_i[22]<= 4;
		R_cmult_out_q[22]<= 10;
	end
end

always @(*) begin
	// conj(lts)*(1+j)
	if((I_data_sign_i[23]==0)&&(I_data_sign_q[23]==0)) begin
		R_cmult_out_i[23]<= 15;
		R_cmult_out_q[23]<= 4073;
	end
	// conj(lts)*(1-j)
	else if((I_data_sign_i[23]==0)&&(I_data_sign_q[23]==1)) begin
		R_cmult_out_i[23]<= 4073;
		R_cmult_out_q[23]<= 4081;
	end
	// conj(lts)*(-1+j)
	else if((I_data_sign_i[23]==1)&&(I_data_sign_q[23]==0)) begin
		R_cmult_out_i[23]<= 23;
		R_cmult_out_q[23]<= 15;
	end
	// conj(lts)*(-1-j)
	else begin
		R_cmult_out_i[23]<= 4081;
		R_cmult_out_q[23]<= 23;
	end
end

always @(*) begin
	// conj(lts)*(1+j)
	if((I_data_sign_i[24]==0)&&(I_data_sign_q[24]==0)) begin
		R_cmult_out_i[24]<= 4082;
		R_cmult_out_q[24]<= 4078;
	end
	// conj(lts)*(1-j)
	else if((I_data_sign_i[24]==0)&&(I_data_sign_q[24]==1)) begin
		R_cmult_out_i[24]<= 4078;
		R_cmult_out_q[24]<= 14;
	end
	// conj(lts)*(-1+j)
	else if((I_data_sign_i[24]==1)&&(I_data_sign_q[24]==0)) begin
		R_cmult_out_i[24]<= 18;
		R_cmult_out_q[24]<= 4082;
	end
	// conj(lts)*(-1-j)
	else begin
		R_cmult_out_i[24]<= 14;
		R_cmult_out_q[24]<= 18;
	end
end

always @(*) begin
	// conj(lts)*(1+j)
	if((I_data_sign_i[25]==0)&&(I_data_sign_q[25]==0)) begin
		R_cmult_out_i[25]<= 4083;
		R_cmult_out_q[25]<= 4077;
	end
	// conj(lts)*(1-j)
	else if((I_data_sign_i[25]==0)&&(I_data_sign_q[25]==1)) begin
		R_cmult_out_i[25]<= 4077;
		R_cmult_out_q[25]<= 13;
	end
	// conj(lts)*(-1+j)
	else if((I_data_sign_i[25]==1)&&(I_data_sign_q[25]==0)) begin
		R_cmult_out_i[25]<= 19;
		R_cmult_out_q[25]<= 4083;
	end
	// conj(lts)*(-1-j)
	else begin
		R_cmult_out_i[25]<= 13;
		R_cmult_out_q[25]<= 19;
	end
end

always @(*) begin
	// conj(lts)*(1+j)
	if((I_data_sign_i[26]==0)&&(I_data_sign_q[26]==0)) begin
		R_cmult_out_i[26]<= 19;
		R_cmult_out_q[26]<= 1;
	end
	// conj(lts)*(1-j)
	else if((I_data_sign_i[26]==0)&&(I_data_sign_q[26]==1)) begin
		R_cmult_out_i[26]<= 1;
		R_cmult_out_q[26]<= 4077;
	end
	// conj(lts)*(-1+j)
	else if((I_data_sign_i[26]==1)&&(I_data_sign_q[26]==0)) begin
		R_cmult_out_i[26]<= 4095;
		R_cmult_out_q[26]<= 19;
	end
	// conj(lts)*(-1-j)
	else begin
		R_cmult_out_i[26]<= 4077;
		R_cmult_out_q[26]<= 4095;
	end
end

always @(*) begin
	// conj(lts)*(1+j)
	if((I_data_sign_i[27]==0)&&(I_data_sign_q[27]==0)) begin
		R_cmult_out_i[27]<= 4089;
		R_cmult_out_q[27]<= 7;
	end
	// conj(lts)*(1-j)
	else if((I_data_sign_i[27]==0)&&(I_data_sign_q[27]==1)) begin
		R_cmult_out_i[27]<= 7;
		R_cmult_out_q[27]<= 7;
	end
	// conj(lts)*(-1+j)
	else if((I_data_sign_i[27]==1)&&(I_data_sign_q[27]==0)) begin
		R_cmult_out_i[27]<= 4089;
		R_cmult_out_q[27]<= 4089;
	end
	// conj(lts)*(-1-j)
	else begin
		R_cmult_out_i[27]<= 7;
		R_cmult_out_q[27]<= 4089;
	end
end

always @(*) begin
	// conj(lts)*(1+j)
	if((I_data_sign_i[28]==0)&&(I_data_sign_q[28]==0)) begin
		R_cmult_out_i[28]<= 4069;
		R_cmult_out_q[28]<= 3;
	end
	// conj(lts)*(1-j)
	else if((I_data_sign_i[28]==0)&&(I_data_sign_q[28]==1)) begin
		R_cmult_out_i[28]<= 3;
		R_cmult_out_q[28]<= 27;
	end
	// conj(lts)*(-1+j)
	else if((I_data_sign_i[28]==1)&&(I_data_sign_q[28]==0)) begin
		R_cmult_out_i[28]<= 4093;
		R_cmult_out_q[28]<= 4069;
	end
	// conj(lts)*(-1-j)
	else begin
		R_cmult_out_i[28]<= 27;
		R_cmult_out_q[28]<= 4093;
	end
end

always @(*) begin
	// conj(lts)*(1+j)
	if((I_data_sign_i[29]==0)&&(I_data_sign_q[29]==0)) begin
		R_cmult_out_i[29]<= 4094;
		R_cmult_out_q[29]<= 26;
	end
	// conj(lts)*(1-j)
	else if((I_data_sign_i[29]==0)&&(I_data_sign_q[29]==1)) begin
		R_cmult_out_i[29]<= 26;
		R_cmult_out_q[29]<= 2;
	end
	// conj(lts)*(-1+j)
	else if((I_data_sign_i[29]==1)&&(I_data_sign_q[29]==0)) begin
		R_cmult_out_i[29]<= 4070;
		R_cmult_out_q[29]<= 4094;
	end
	// conj(lts)*(-1-j)
	else begin
		R_cmult_out_i[29]<= 2;
		R_cmult_out_q[29]<= 4070;
	end
end

always @(*) begin
	// conj(lts)*(1+j)
	if((I_data_sign_i[30]==0)&&(I_data_sign_q[30]==0)) begin
		R_cmult_out_i[30]<= 4086;
		R_cmult_out_q[30]<= 14;
	end
	// conj(lts)*(1-j)
	else if((I_data_sign_i[30]==0)&&(I_data_sign_q[30]==1)) begin
		R_cmult_out_i[30]<= 14;
		R_cmult_out_q[30]<= 10;
	end
	// conj(lts)*(-1+j)
	else if((I_data_sign_i[30]==1)&&(I_data_sign_q[30]==0)) begin
		R_cmult_out_i[30]<= 4082;
		R_cmult_out_q[30]<= 4086;
	end
	// conj(lts)*(-1-j)
	else begin
		R_cmult_out_i[30]<= 10;
		R_cmult_out_q[30]<= 4082;
	end
end

always @(*) begin
	// conj(lts)*(1+j)
	if((I_data_sign_i[31]==0)&&(I_data_sign_q[31]==0)) begin
		R_cmult_out_i[31]<= 4076;
		R_cmult_out_q[31]<= 4076;
	end
	// conj(lts)*(1-j)
	else if((I_data_sign_i[31]==0)&&(I_data_sign_q[31]==1)) begin
		R_cmult_out_i[31]<= 4076;
		R_cmult_out_q[31]<= 20;
	end
	// conj(lts)*(-1+j)
	else if((I_data_sign_i[31]==1)&&(I_data_sign_q[31]==0)) begin
		R_cmult_out_i[31]<= 20;
		R_cmult_out_q[31]<= 4076;
	end
	// conj(lts)*(-1-j)
	else begin
		R_cmult_out_i[31]<= 20;
		R_cmult_out_q[31]<= 20;
	end
end

always @(*) begin
	// conj(lts)*(1+j)
	if((I_data_sign_i[32]==0)&&(I_data_sign_q[32]==0)) begin
		R_cmult_out_i[32]<= 14;
		R_cmult_out_q[32]<= 4086;
	end
	// conj(lts)*(1-j)
	else if((I_data_sign_i[32]==0)&&(I_data_sign_q[32]==1)) begin
		R_cmult_out_i[32]<= 4086;
		R_cmult_out_q[32]<= 4082;
	end
	// conj(lts)*(-1+j)
	else if((I_data_sign_i[32]==1)&&(I_data_sign_q[32]==0)) begin
		R_cmult_out_i[32]<= 10;
		R_cmult_out_q[32]<= 14;
	end
	// conj(lts)*(-1-j)
	else begin
		R_cmult_out_i[32]<= 4082;
		R_cmult_out_q[32]<= 10;
	end
end

always @(*) begin
	// conj(lts)*(1+j)
	if((I_data_sign_i[33]==0)&&(I_data_sign_q[33]==0)) begin
		R_cmult_out_i[33]<= 26;
		R_cmult_out_q[33]<= 4094;
	end
	// conj(lts)*(1-j)
	else if((I_data_sign_i[33]==0)&&(I_data_sign_q[33]==1)) begin
		R_cmult_out_i[33]<= 4094;
		R_cmult_out_q[33]<= 4070;
	end
	// conj(lts)*(-1+j)
	else if((I_data_sign_i[33]==1)&&(I_data_sign_q[33]==0)) begin
		R_cmult_out_i[33]<= 2;
		R_cmult_out_q[33]<= 26;
	end
	// conj(lts)*(-1-j)
	else begin
		R_cmult_out_i[33]<= 4070;
		R_cmult_out_q[33]<= 2;
	end
end

always @(*) begin
	// conj(lts)*(1+j)
	if((I_data_sign_i[34]==0)&&(I_data_sign_q[34]==0)) begin
		R_cmult_out_i[34]<= 3;
		R_cmult_out_q[34]<= 4069;
	end
	// conj(lts)*(1-j)
	else if((I_data_sign_i[34]==0)&&(I_data_sign_q[34]==1)) begin
		R_cmult_out_i[34]<= 4069;
		R_cmult_out_q[34]<= 4093;
	end
	// conj(lts)*(-1+j)
	else if((I_data_sign_i[34]==1)&&(I_data_sign_q[34]==0)) begin
		R_cmult_out_i[34]<= 27;
		R_cmult_out_q[34]<= 3;
	end
	// conj(lts)*(-1-j)
	else begin
		R_cmult_out_i[34]<= 4093;
		R_cmult_out_q[34]<= 27;
	end
end

always @(*) begin
	// conj(lts)*(1+j)
	if((I_data_sign_i[35]==0)&&(I_data_sign_q[35]==0)) begin
		R_cmult_out_i[35]<= 7;
		R_cmult_out_q[35]<= 4089;
	end
	// conj(lts)*(1-j)
	else if((I_data_sign_i[35]==0)&&(I_data_sign_q[35]==1)) begin
		R_cmult_out_i[35]<= 4089;
		R_cmult_out_q[35]<= 4089;
	end
	// conj(lts)*(-1+j)
	else if((I_data_sign_i[35]==1)&&(I_data_sign_q[35]==0)) begin
		R_cmult_out_i[35]<= 7;
		R_cmult_out_q[35]<= 7;
	end
	// conj(lts)*(-1-j)
	else begin
		R_cmult_out_i[35]<= 4089;
		R_cmult_out_q[35]<= 7;
	end
end

always @(*) begin
	// conj(lts)*(1+j)
	if((I_data_sign_i[36]==0)&&(I_data_sign_q[36]==0)) begin
		R_cmult_out_i[36]<= 1;
		R_cmult_out_q[36]<= 19;
	end
	// conj(lts)*(1-j)
	else if((I_data_sign_i[36]==0)&&(I_data_sign_q[36]==1)) begin
		R_cmult_out_i[36]<= 19;
		R_cmult_out_q[36]<= 4095;
	end
	// conj(lts)*(-1+j)
	else if((I_data_sign_i[36]==1)&&(I_data_sign_q[36]==0)) begin
		R_cmult_out_i[36]<= 4077;
		R_cmult_out_q[36]<= 1;
	end
	// conj(lts)*(-1-j)
	else begin
		R_cmult_out_i[36]<= 4095;
		R_cmult_out_q[36]<= 4077;
	end
end

always @(*) begin
	// conj(lts)*(1+j)
	if((I_data_sign_i[37]==0)&&(I_data_sign_q[37]==0)) begin
		R_cmult_out_i[37]<= 4077;
		R_cmult_out_q[37]<= 4083;
	end
	// conj(lts)*(1-j)
	else if((I_data_sign_i[37]==0)&&(I_data_sign_q[37]==1)) begin
		R_cmult_out_i[37]<= 4083;
		R_cmult_out_q[37]<= 19;
	end
	// conj(lts)*(-1+j)
	else if((I_data_sign_i[37]==1)&&(I_data_sign_q[37]==0)) begin
		R_cmult_out_i[37]<= 13;
		R_cmult_out_q[37]<= 4077;
	end
	// conj(lts)*(-1-j)
	else begin
		R_cmult_out_i[37]<= 19;
		R_cmult_out_q[37]<= 13;
	end
end

always @(*) begin
	// conj(lts)*(1+j)
	if((I_data_sign_i[38]==0)&&(I_data_sign_q[38]==0)) begin
		R_cmult_out_i[38]<= 4078;
		R_cmult_out_q[38]<= 4082;
	end
	// conj(lts)*(1-j)
	else if((I_data_sign_i[38]==0)&&(I_data_sign_q[38]==1)) begin
		R_cmult_out_i[38]<= 4082;
		R_cmult_out_q[38]<= 18;
	end
	// conj(lts)*(-1+j)
	else if((I_data_sign_i[38]==1)&&(I_data_sign_q[38]==0)) begin
		R_cmult_out_i[38]<= 14;
		R_cmult_out_q[38]<= 4078;
	end
	// conj(lts)*(-1-j)
	else begin
		R_cmult_out_i[38]<= 18;
		R_cmult_out_q[38]<= 14;
	end
end

always @(*) begin
	// conj(lts)*(1+j)
	if((I_data_sign_i[39]==0)&&(I_data_sign_q[39]==0)) begin
		R_cmult_out_i[39]<= 4073;
		R_cmult_out_q[39]<= 15;
	end
	// conj(lts)*(1-j)
	else if((I_data_sign_i[39]==0)&&(I_data_sign_q[39]==1)) begin
		R_cmult_out_i[39]<= 15;
		R_cmult_out_q[39]<= 23;
	end
	// conj(lts)*(-1+j)
	else if((I_data_sign_i[39]==1)&&(I_data_sign_q[39]==0)) begin
		R_cmult_out_i[39]<= 4081;
		R_cmult_out_q[39]<= 4073;
	end
	// conj(lts)*(-1-j)
	else begin
		R_cmult_out_i[39]<= 23;
		R_cmult_out_q[39]<= 4081;
	end
end

always @(*) begin
	// conj(lts)*(1+j)
	if((I_data_sign_i[40]==0)&&(I_data_sign_q[40]==0)) begin
		R_cmult_out_i[40]<= 4086;
		R_cmult_out_q[40]<= 4092;
	end
	// conj(lts)*(1-j)
	else if((I_data_sign_i[40]==0)&&(I_data_sign_q[40]==1)) begin
		R_cmult_out_i[40]<= 4092;
		R_cmult_out_q[40]<= 10;
	end
	// conj(lts)*(-1+j)
	else if((I_data_sign_i[40]==1)&&(I_data_sign_q[40]==0)) begin
		R_cmult_out_i[40]<= 4;
		R_cmult_out_q[40]<= 4086;
	end
	// conj(lts)*(-1-j)
	else begin
		R_cmult_out_i[40]<= 10;
		R_cmult_out_q[40]<= 4;
	end
end

always @(*) begin
	// conj(lts)*(1+j)
	if((I_data_sign_i[41]==0)&&(I_data_sign_q[41]==0)) begin
		R_cmult_out_i[41]<= 2;
		R_cmult_out_q[41]<= 4078;
	end
	// conj(lts)*(1-j)
	else if((I_data_sign_i[41]==0)&&(I_data_sign_q[41]==1)) begin
		R_cmult_out_i[41]<= 4078;
		R_cmult_out_q[41]<= 4094;
	end
	// conj(lts)*(-1+j)
	else if((I_data_sign_i[41]==1)&&(I_data_sign_q[41]==0)) begin
		R_cmult_out_i[41]<= 18;
		R_cmult_out_q[41]<= 2;
	end
	// conj(lts)*(-1-j)
	else begin
		R_cmult_out_i[41]<= 4094;
		R_cmult_out_q[41]<= 18;
	end
end

always @(*) begin
	// conj(lts)*(1+j)
	if((I_data_sign_i[42]==0)&&(I_data_sign_q[42]==0)) begin
		R_cmult_out_i[42]<= 11;
		R_cmult_out_q[42]<= 7;
	end
	// conj(lts)*(1-j)
	else if((I_data_sign_i[42]==0)&&(I_data_sign_q[42]==1)) begin
		R_cmult_out_i[42]<= 7;
		R_cmult_out_q[42]<= 4085;
	end
	// conj(lts)*(-1+j)
	else if((I_data_sign_i[42]==1)&&(I_data_sign_q[42]==0)) begin
		R_cmult_out_i[42]<= 4089;
		R_cmult_out_q[42]<= 11;
	end
	// conj(lts)*(-1-j)
	else begin
		R_cmult_out_i[42]<= 4085;
		R_cmult_out_q[42]<= 4089;
	end
end

always @(*) begin
	// conj(lts)*(1+j)
	if((I_data_sign_i[43]==0)&&(I_data_sign_q[43]==0)) begin
		R_cmult_out_i[43]<= 23;
		R_cmult_out_q[43]<= 4095;
	end
	// conj(lts)*(1-j)
	else if((I_data_sign_i[43]==0)&&(I_data_sign_q[43]==1)) begin
		R_cmult_out_i[43]<= 4095;
		R_cmult_out_q[43]<= 4073;
	end
	// conj(lts)*(-1+j)
	else if((I_data_sign_i[43]==1)&&(I_data_sign_q[43]==0)) begin
		R_cmult_out_i[43]<= 1;
		R_cmult_out_q[43]<= 23;
	end
	// conj(lts)*(-1-j)
	else begin
		R_cmult_out_i[43]<= 4073;
		R_cmult_out_q[43]<= 1;
	end
end

always @(*) begin
	// conj(lts)*(1+j)
	if((I_data_sign_i[44]==0)&&(I_data_sign_q[44]==0)) begin
		R_cmult_out_i[44]<= 4087;
		R_cmult_out_q[44]<= 4071;
	end
	// conj(lts)*(1-j)
	else if((I_data_sign_i[44]==0)&&(I_data_sign_q[44]==1)) begin
		R_cmult_out_i[44]<= 4071;
		R_cmult_out_q[44]<= 9;
	end
	// conj(lts)*(-1+j)
	else if((I_data_sign_i[44]==1)&&(I_data_sign_q[44]==0)) begin
		R_cmult_out_i[44]<= 25;
		R_cmult_out_q[44]<= 4087;
	end
	// conj(lts)*(-1-j)
	else begin
		R_cmult_out_i[44]<= 9;
		R_cmult_out_q[44]<= 25;
	end
end

always @(*) begin
	// conj(lts)*(1+j)
	if((I_data_sign_i[45]==0)&&(I_data_sign_q[45]==0)) begin
		R_cmult_out_i[45]<= 4094;
		R_cmult_out_q[45]<= 4084;
	end
	// conj(lts)*(1-j)
	else if((I_data_sign_i[45]==0)&&(I_data_sign_q[45]==1)) begin
		R_cmult_out_i[45]<= 4084;
		R_cmult_out_q[45]<= 2;
	end
	// conj(lts)*(-1+j)
	else if((I_data_sign_i[45]==1)&&(I_data_sign_q[45]==0)) begin
		R_cmult_out_i[45]<= 12;
		R_cmult_out_q[45]<= 4094;
	end
	// conj(lts)*(-1-j)
	else begin
		R_cmult_out_i[45]<= 2;
		R_cmult_out_q[45]<= 12;
	end
end

always @(*) begin
	// conj(lts)*(1+j)
	if((I_data_sign_i[46]==0)&&(I_data_sign_q[46]==0)) begin
		R_cmult_out_i[46]<= 18;
		R_cmult_out_q[46]<= 4088;
	end
	// conj(lts)*(1-j)
	else if((I_data_sign_i[46]==0)&&(I_data_sign_q[46]==1)) begin
		R_cmult_out_i[46]<= 4088;
		R_cmult_out_q[46]<= 4078;
	end
	// conj(lts)*(-1+j)
	else if((I_data_sign_i[46]==1)&&(I_data_sign_q[46]==0)) begin
		R_cmult_out_i[46]<= 8;
		R_cmult_out_q[46]<= 18;
	end
	// conj(lts)*(-1-j)
	else begin
		R_cmult_out_i[46]<= 4078;
		R_cmult_out_q[46]<= 8;
	end
end

always @(*) begin
	// conj(lts)*(1+j)
	if((I_data_sign_i[47]==0)&&(I_data_sign_q[47]==0)) begin
		R_cmult_out_i[47]<= 0;
		R_cmult_out_q[47]<= 16;
	end
	// conj(lts)*(1-j)
	else if((I_data_sign_i[47]==0)&&(I_data_sign_q[47]==1)) begin
		R_cmult_out_i[47]<= 16;
		R_cmult_out_q[47]<= 0;
	end
	// conj(lts)*(-1+j)
	else if((I_data_sign_i[47]==1)&&(I_data_sign_q[47]==0)) begin
		R_cmult_out_i[47]<= 4080;
		R_cmult_out_q[47]<= 0;
	end
	// conj(lts)*(-1-j)
	else begin
		R_cmult_out_i[47]<= 0;
		R_cmult_out_q[47]<= 4080;
	end
end

always @(*) begin
	// conj(lts)*(1+j)
	if((I_data_sign_i[48]==0)&&(I_data_sign_q[48]==0)) begin
		R_cmult_out_i[48]<= 14;
		R_cmult_out_q[48]<= 16;
	end
	// conj(lts)*(1-j)
	else if((I_data_sign_i[48]==0)&&(I_data_sign_q[48]==1)) begin
		R_cmult_out_i[48]<= 16;
		R_cmult_out_q[48]<= 4082;
	end
	// conj(lts)*(-1+j)
	else if((I_data_sign_i[48]==1)&&(I_data_sign_q[48]==0)) begin
		R_cmult_out_i[48]<= 4080;
		R_cmult_out_q[48]<= 14;
	end
	// conj(lts)*(-1-j)
	else begin
		R_cmult_out_i[48]<= 4082;
		R_cmult_out_q[48]<= 4080;
	end
end

always @(*) begin
	// conj(lts)*(1+j)
	if((I_data_sign_i[49]==0)&&(I_data_sign_q[49]==0)) begin
		R_cmult_out_i[49]<= 18;
		R_cmult_out_q[49]<= 4072;
	end
	// conj(lts)*(1-j)
	else if((I_data_sign_i[49]==0)&&(I_data_sign_q[49]==1)) begin
		R_cmult_out_i[49]<= 4072;
		R_cmult_out_q[49]<= 4078;
	end
	// conj(lts)*(-1+j)
	else if((I_data_sign_i[49]==1)&&(I_data_sign_q[49]==0)) begin
		R_cmult_out_i[49]<= 24;
		R_cmult_out_q[49]<= 18;
	end
	// conj(lts)*(-1-j)
	else begin
		R_cmult_out_i[49]<= 4078;
		R_cmult_out_q[49]<= 24;
	end
end

always @(*) begin
	// conj(lts)*(1+j)
	if((I_data_sign_i[50]==0)&&(I_data_sign_q[50]==0)) begin
		R_cmult_out_i[50]<= 6;
		R_cmult_out_q[50]<= 10;
	end
	// conj(lts)*(1-j)
	else if((I_data_sign_i[50]==0)&&(I_data_sign_q[50]==1)) begin
		R_cmult_out_i[50]<= 10;
		R_cmult_out_q[50]<= 4090;
	end
	// conj(lts)*(-1+j)
	else if((I_data_sign_i[50]==1)&&(I_data_sign_q[50]==0)) begin
		R_cmult_out_i[50]<= 4086;
		R_cmult_out_q[50]<= 6;
	end
	// conj(lts)*(-1-j)
	else begin
		R_cmult_out_i[50]<= 4090;
		R_cmult_out_q[50]<= 4086;
	end
end

always @(*) begin
	// conj(lts)*(1+j)
	if((I_data_sign_i[51]==0)&&(I_data_sign_q[51]==0)) begin
		R_cmult_out_i[51]<= 4092;
		R_cmult_out_q[51]<= 10;
	end
	// conj(lts)*(1-j)
	else if((I_data_sign_i[51]==0)&&(I_data_sign_q[51]==1)) begin
		R_cmult_out_i[51]<= 10;
		R_cmult_out_q[51]<= 4;
	end
	// conj(lts)*(-1+j)
	else if((I_data_sign_i[51]==1)&&(I_data_sign_q[51]==0)) begin
		R_cmult_out_i[51]<= 4086;
		R_cmult_out_q[51]<= 4092;
	end
	// conj(lts)*(-1-j)
	else begin
		R_cmult_out_i[51]<= 4;
		R_cmult_out_q[51]<= 4086;
	end
end

always @(*) begin
	// conj(lts)*(1+j)
	if((I_data_sign_i[52]==0)&&(I_data_sign_q[52]==0)) begin
		R_cmult_out_i[52]<= 4072;
		R_cmult_out_q[52]<= 4084;
	end
	// conj(lts)*(1-j)
	else if((I_data_sign_i[52]==0)&&(I_data_sign_q[52]==1)) begin
		R_cmult_out_i[52]<= 4084;
		R_cmult_out_q[52]<= 24;
	end
	// conj(lts)*(-1+j)
	else if((I_data_sign_i[52]==1)&&(I_data_sign_q[52]==0)) begin
		R_cmult_out_i[52]<= 12;
		R_cmult_out_q[52]<= 4072;
	end
	// conj(lts)*(-1-j)
	else begin
		R_cmult_out_i[52]<= 24;
		R_cmult_out_q[52]<= 12;
	end
end

always @(*) begin
	// conj(lts)*(1+j)
	if((I_data_sign_i[53]==0)&&(I_data_sign_q[53]==0)) begin
		R_cmult_out_i[53]<= 4081;
		R_cmult_out_q[53]<= 15;
	end
	// conj(lts)*(1-j)
	else if((I_data_sign_i[53]==0)&&(I_data_sign_q[53]==1)) begin
		R_cmult_out_i[53]<= 15;
		R_cmult_out_q[53]<= 15;
	end
	// conj(lts)*(-1+j)
	else if((I_data_sign_i[53]==1)&&(I_data_sign_q[53]==0)) begin
		R_cmult_out_i[53]<= 4081;
		R_cmult_out_q[53]<= 4081;
	end
	// conj(lts)*(-1-j)
	else begin
		R_cmult_out_i[53]<= 15;
		R_cmult_out_q[53]<= 4081;
	end
end

always @(*) begin
	// conj(lts)*(1+j)
	if((I_data_sign_i[54]==0)&&(I_data_sign_q[54]==0)) begin
		R_cmult_out_i[54]<= 8;
		R_cmult_out_q[54]<= 6;
	end
	// conj(lts)*(1-j)
	else if((I_data_sign_i[54]==0)&&(I_data_sign_q[54]==1)) begin
		R_cmult_out_i[54]<= 6;
		R_cmult_out_q[54]<= 4088;
	end
	// conj(lts)*(-1+j)
	else if((I_data_sign_i[54]==1)&&(I_data_sign_q[54]==0)) begin
		R_cmult_out_i[54]<= 4090;
		R_cmult_out_q[54]<= 8;
	end
	// conj(lts)*(-1-j)
	else begin
		R_cmult_out_i[54]<= 4088;
		R_cmult_out_q[54]<= 4090;
	end
end

always @(*) begin
	// conj(lts)*(1+j)
	if((I_data_sign_i[55]==0)&&(I_data_sign_q[55]==0)) begin
		R_cmult_out_i[55]<= 9;
		R_cmult_out_q[55]<= 15;
	end
	// conj(lts)*(1-j)
	else if((I_data_sign_i[55]==0)&&(I_data_sign_q[55]==1)) begin
		R_cmult_out_i[55]<= 15;
		R_cmult_out_q[55]<= 4087;
	end
	// conj(lts)*(-1+j)
	else if((I_data_sign_i[55]==1)&&(I_data_sign_q[55]==0)) begin
		R_cmult_out_i[55]<= 4081;
		R_cmult_out_q[55]<= 9;
	end
	// conj(lts)*(-1-j)
	else begin
		R_cmult_out_i[55]<= 4087;
		R_cmult_out_q[55]<= 4081;
	end
end

always @(*) begin
	// conj(lts)*(1+j)
	if((I_data_sign_i[56]==0)&&(I_data_sign_q[56]==0)) begin
		R_cmult_out_i[56]<= 4077;
		R_cmult_out_q[56]<= 9;
	end
	// conj(lts)*(1-j)
	else if((I_data_sign_i[56]==0)&&(I_data_sign_q[56]==1)) begin
		R_cmult_out_i[56]<= 9;
		R_cmult_out_q[56]<= 19;
	end
	// conj(lts)*(-1+j)
	else if((I_data_sign_i[56]==1)&&(I_data_sign_q[56]==0)) begin
		R_cmult_out_i[56]<= 4087;
		R_cmult_out_q[56]<= 4077;
	end
	// conj(lts)*(-1-j)
	else begin
		R_cmult_out_i[56]<= 19;
		R_cmult_out_q[56]<= 4087;
	end
end

always @(*) begin
	// conj(lts)*(1+j)
	if((I_data_sign_i[57]==0)&&(I_data_sign_q[57]==0)) begin
		R_cmult_out_i[57]<= 4074;
		R_cmult_out_q[57]<= 4088;
	end
	// conj(lts)*(1-j)
	else if((I_data_sign_i[57]==0)&&(I_data_sign_q[57]==1)) begin
		R_cmult_out_i[57]<= 4088;
		R_cmult_out_q[57]<= 22;
	end
	// conj(lts)*(-1+j)
	else if((I_data_sign_i[57]==1)&&(I_data_sign_q[57]==0)) begin
		R_cmult_out_i[57]<= 8;
		R_cmult_out_q[57]<= 4074;
	end
	// conj(lts)*(-1-j)
	else begin
		R_cmult_out_i[57]<= 22;
		R_cmult_out_q[57]<= 8;
	end
end

always @(*) begin
	// conj(lts)*(1+j)
	if((I_data_sign_i[58]==0)&&(I_data_sign_q[58]==0)) begin
		R_cmult_out_i[58]<= 4093;
		R_cmult_out_q[58]<= 19;
	end
	// conj(lts)*(1-j)
	else if((I_data_sign_i[58]==0)&&(I_data_sign_q[58]==1)) begin
		R_cmult_out_i[58]<= 19;
		R_cmult_out_q[58]<= 3;
	end
	// conj(lts)*(-1+j)
	else if((I_data_sign_i[58]==1)&&(I_data_sign_q[58]==0)) begin
		R_cmult_out_i[58]<= 4077;
		R_cmult_out_q[58]<= 4093;
	end
	// conj(lts)*(-1-j)
	else begin
		R_cmult_out_i[58]<= 3;
		R_cmult_out_q[58]<= 4077;
	end
end

always @(*) begin
	// conj(lts)*(1+j)
	if((I_data_sign_i[59]==0)&&(I_data_sign_q[59]==0)) begin
		R_cmult_out_i[59]<= 7;
		R_cmult_out_q[59]<= 4095;
	end
	// conj(lts)*(1-j)
	else if((I_data_sign_i[59]==0)&&(I_data_sign_q[59]==1)) begin
		R_cmult_out_i[59]<= 4095;
		R_cmult_out_q[59]<= 4089;
	end
	// conj(lts)*(-1+j)
	else if((I_data_sign_i[59]==1)&&(I_data_sign_q[59]==0)) begin
		R_cmult_out_i[59]<= 1;
		R_cmult_out_q[59]<= 7;
	end
	// conj(lts)*(-1-j)
	else begin
		R_cmult_out_i[59]<= 4089;
		R_cmult_out_q[59]<= 1;
	end
end

always @(*) begin
	// conj(lts)*(1+j)
	if((I_data_sign_i[60]==0)&&(I_data_sign_q[60]==0)) begin
		R_cmult_out_i[60]<= 23;
		R_cmult_out_q[60]<= 1;
	end
	// conj(lts)*(1-j)
	else if((I_data_sign_i[60]==0)&&(I_data_sign_q[60]==1)) begin
		R_cmult_out_i[60]<= 1;
		R_cmult_out_q[60]<= 4073;
	end
	// conj(lts)*(-1+j)
	else if((I_data_sign_i[60]==1)&&(I_data_sign_q[60]==0)) begin
		R_cmult_out_i[60]<= 4095;
		R_cmult_out_q[60]<= 23;
	end
	// conj(lts)*(-1-j)
	else begin
		R_cmult_out_i[60]<= 4073;
		R_cmult_out_q[60]<= 4095;
	end
end

always @(*) begin
	// conj(lts)*(1+j)
	if((I_data_sign_i[61]==0)&&(I_data_sign_q[61]==0)) begin
		R_cmult_out_i[61]<= 4087;
		R_cmult_out_q[61]<= 19;
	end
	// conj(lts)*(1-j)
	else if((I_data_sign_i[61]==0)&&(I_data_sign_q[61]==1)) begin
		R_cmult_out_i[61]<= 19;
		R_cmult_out_q[61]<= 9;
	end
	// conj(lts)*(-1+j)
	else if((I_data_sign_i[61]==1)&&(I_data_sign_q[61]==0)) begin
		R_cmult_out_i[61]<= 4077;
		R_cmult_out_q[61]<= 4087;
	end
	// conj(lts)*(-1-j)
	else begin
		R_cmult_out_i[61]<= 9;
		R_cmult_out_q[61]<= 4077;
	end
end

always @(*) begin
	// conj(lts)*(1+j)
	if((I_data_sign_i[62]==0)&&(I_data_sign_q[62]==0)) begin
		R_cmult_out_i[62]<= 4080;
		R_cmult_out_q[62]<= 14;
	end
	// conj(lts)*(1-j)
	else if((I_data_sign_i[62]==0)&&(I_data_sign_q[62]==1)) begin
		R_cmult_out_i[62]<= 14;
		R_cmult_out_q[62]<= 16;
	end
	// conj(lts)*(-1+j)
	else if((I_data_sign_i[62]==1)&&(I_data_sign_q[62]==0)) begin
		R_cmult_out_i[62]<= 4082;
		R_cmult_out_q[62]<= 4080;
	end
	// conj(lts)*(-1-j)
	else begin
		R_cmult_out_i[62]<= 16;
		R_cmult_out_q[62]<= 4082;
	end
end

always @(*) begin
	// conj(lts)*(1+j)
	if((I_data_sign_i[63]==0)&&(I_data_sign_q[63]==0)) begin
		R_cmult_out_i[63]<= 20;
		R_cmult_out_q[63]<= 20;
	end
	// conj(lts)*(1-j)
	else if((I_data_sign_i[63]==0)&&(I_data_sign_q[63]==1)) begin
		R_cmult_out_i[63]<= 20;
		R_cmult_out_q[63]<= 4076;
	end
	// conj(lts)*(-1+j)
	else if((I_data_sign_i[63]==1)&&(I_data_sign_q[63]==0)) begin
		R_cmult_out_i[63]<= 4076;
		R_cmult_out_q[63]<= 20;
	end
	// conj(lts)*(-1-j)
	else begin
		R_cmult_out_i[63]<= 4076;
		R_cmult_out_q[63]<= 4076;
	end
end

wire [11:0] W_Ck_i = R_cmult_out_i[0]+
					R_cmult_out_i[1]+
					R_cmult_out_i[2]+
					R_cmult_out_i[3]+
					R_cmult_out_i[4]+
					R_cmult_out_i[5]+
					R_cmult_out_i[6]+
					R_cmult_out_i[7]+
					R_cmult_out_i[8]+
					R_cmult_out_i[9]+
					R_cmult_out_i[10]+
					R_cmult_out_i[11]+
					R_cmult_out_i[12]+
					R_cmult_out_i[13]+
					R_cmult_out_i[14]+
					R_cmult_out_i[15]+
					R_cmult_out_i[16]+
					R_cmult_out_i[17]+
					R_cmult_out_i[18]+
					R_cmult_out_i[19]+
					R_cmult_out_i[20]+
					R_cmult_out_i[21]+
					R_cmult_out_i[22]+
					R_cmult_out_i[23]+
					R_cmult_out_i[24]+
					R_cmult_out_i[25]+
					R_cmult_out_i[26]+
					R_cmult_out_i[27]+
					R_cmult_out_i[28]+
					R_cmult_out_i[29]+
					R_cmult_out_i[30]+
					R_cmult_out_i[31]+
					R_cmult_out_i[32]+
					R_cmult_out_i[33]+
					R_cmult_out_i[34]+
					R_cmult_out_i[35]+
					R_cmult_out_i[36]+
					R_cmult_out_i[37]+
					R_cmult_out_i[38]+
					R_cmult_out_i[39]+
					R_cmult_out_i[40]+
					R_cmult_out_i[41]+
					R_cmult_out_i[42]+
					R_cmult_out_i[43]+
					R_cmult_out_i[44]+
					R_cmult_out_i[45]+
					R_cmult_out_i[46]+
					R_cmult_out_i[47]+
					R_cmult_out_i[48]+
					R_cmult_out_i[49]+
					R_cmult_out_i[50]+
					R_cmult_out_i[51]+
					R_cmult_out_i[52]+
					R_cmult_out_i[53]+
					R_cmult_out_i[54]+
					R_cmult_out_i[55]+
					R_cmult_out_i[56]+
					R_cmult_out_i[57]+
					R_cmult_out_i[58]+
					R_cmult_out_i[59]+
					R_cmult_out_i[60]+
					R_cmult_out_i[61]+
					R_cmult_out_i[62]+
					R_cmult_out_i[63];

wire [11:0] W_Ck_q = R_cmult_out_q[0]+
					R_cmult_out_q[1]+
					R_cmult_out_q[2]+
					R_cmult_out_q[3]+
					R_cmult_out_q[4]+
					R_cmult_out_q[5]+
					R_cmult_out_q[6]+
					R_cmult_out_q[7]+
					R_cmult_out_q[8]+
					R_cmult_out_q[9]+
					R_cmult_out_q[10]+
					R_cmult_out_q[11]+
					R_cmult_out_q[12]+
					R_cmult_out_q[13]+
					R_cmult_out_q[14]+
					R_cmult_out_q[15]+
					R_cmult_out_q[16]+
					R_cmult_out_q[17]+
					R_cmult_out_q[18]+
					R_cmult_out_q[19]+
					R_cmult_out_q[20]+
					R_cmult_out_q[21]+
					R_cmult_out_q[22]+
					R_cmult_out_q[23]+
					R_cmult_out_q[24]+
					R_cmult_out_q[25]+
					R_cmult_out_q[26]+
					R_cmult_out_q[27]+
					R_cmult_out_q[28]+
					R_cmult_out_q[29]+
					R_cmult_out_q[30]+
					R_cmult_out_q[31]+
					R_cmult_out_q[32]+
					R_cmult_out_q[33]+
					R_cmult_out_q[34]+
					R_cmult_out_q[35]+
					R_cmult_out_q[36]+
					R_cmult_out_q[37]+
					R_cmult_out_q[38]+
					R_cmult_out_q[39]+
					R_cmult_out_q[40]+
					R_cmult_out_q[41]+
					R_cmult_out_q[42]+
					R_cmult_out_q[43]+
					R_cmult_out_q[44]+
					R_cmult_out_q[45]+
					R_cmult_out_q[46]+
					R_cmult_out_q[47]+
					R_cmult_out_q[48]+
					R_cmult_out_q[49]+
					R_cmult_out_q[50]+
					R_cmult_out_q[51]+
					R_cmult_out_q[52]+
					R_cmult_out_q[53]+
					R_cmult_out_q[54]+
					R_cmult_out_q[55]+
					R_cmult_out_q[56]+
					R_cmult_out_q[57]+
					R_cmult_out_q[58]+
					R_cmult_out_q[59]+
					R_cmult_out_q[60]+
					R_cmult_out_q[61]+
					R_cmult_out_q[62]+
					R_cmult_out_q[63];

wire [11:0] W_abs_Ck_i=W_Ck_i[11]?-W_Ck_i:W_Ck_i;
wire [11:0] W_abs_Ck_q=W_Ck_q[11]?-W_Ck_q:W_Ck_q;

wire [11:0] W_abs_Ck_max=(W_abs_Ck_i>=W_abs_Ck_q)?W_abs_Ck_i:W_abs_Ck_q;
wire [11:0] W_abs_Ck_min=(W_abs_Ck_i< W_abs_Ck_q)?W_abs_Ck_i:W_abs_Ck_q;

wire [11:0] W_abs_Ck=W_abs_Ck_max-(W_abs_Ck_max>>4)+
						(W_abs_Ck_min>>1)-(W_abs_Ck_min>>5);
assign O_abs_Ck = W_abs_Ck;
endmodule
