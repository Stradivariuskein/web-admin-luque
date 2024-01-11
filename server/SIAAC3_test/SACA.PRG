use compro1
go top
do while !eof()
        do case
             case tipo = 'FAC'
                      replace tipo with 'FAV'
             case tipo = 'REC'
                      replace tipo with 'REV'
             case tipo = 'NC2'
                      replace tipo with 'N2V'
        endcase
        skip
enddo
close all

use detalle1
go top
do while !eof()
        do case
             case tipo = 'FAC'
                      replace tipo with 'FAV'
             case tipo = 'REC'
                      replace tipo with 'REV'
             case tipo = 'NC2'
                      replace tipo with 'N2V'
        endcase
        skip
enddo
close all
return
