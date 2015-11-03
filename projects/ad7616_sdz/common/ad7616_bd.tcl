
# data interfaces

create_bd_port -dir O sclk
create_bd_port -dir O sdo
create_bd_port -dir I sdi_0
create_bd_port -dir I sdi_1

create_bd_port -dir O -from 15 -to 0 db_o
create_bd_port -dir I -from 15 -to 0 db_i
create_bd_port -dir O rd_n
create_bd_port -dir O wr_n

# control lines

create_bd_port -dri O reset_n
create_bd_port -dir O cnvst
create_bd_port -dir O cs_n
create_bd_port -dir O busy
create_bd_port -dir O seq_en
create_bd_port -dir O -from 1 -to 0 hw_rngsel
create_bd_port -dir O -from 2 -to 0 chsel

# instantiation


