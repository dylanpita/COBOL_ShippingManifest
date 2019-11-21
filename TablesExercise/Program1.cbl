       program-id. Program1 as "TablesExercise.Program1".

       environment division.
       input-output section.
       file-control.   select cargo-rec
                       assign to "C:\a\exercise8\input.txt"
                       organization is line sequential.

                       select cargo-out
                       assign to "C:\a\exercise8\output.txt"
                       organization is line sequential.

       data division.
       file section.
       fd  cargo-rec.
       01  cargo-record.                                 
           05  ship-name-in    picture x(20).
           05  product-in      picture x(10).
           05  units-in        picture 9(5).
           05  country-in      picture x(15).

       fd  cargo-out.
       01  print-rec               picture x(80).

       working-storage section.
       01  cargo-record-out.
           05                      picture x(2) value spaces.
           05  ship-name-out       picture x(20).
           05                      picture x(5) value spaces.
           05  product-out         picture x(10).
           05                      picture x(3) value spaces.
           05  units-out           picture ZZZZ9.
           05                      picture x(3) value spaces.
           05  total-value         picture $$$$$$$9.99.
           05                      picture x(5) value spaces.
           05  country-out         picture x(15).
           05                      picture x(2) value spaces.

       01  value-4-product-table.
           05  filler      picture x(14) value "BUTANE    0040".
           05  filler      picture x(14) value "COPPER    0075".
           05  filler      picture x(14) value "IRON ORE  1050".
           05  filler      picture x(14) value "OIL       2123".
           05  filler      picture x(14) value "RUBBER    1080".
           05  filler      picture x(14) value "SUGAR     0815".
           05  filler      picture x(14) value "TIMBER    0046".
           05  filler      picture x(14) value "WHEAT     0240".
       01  rdf-value-4-product-table redefines value-4-product-table.
           05  product-value-group occurs 8 times indexed by i.
               10  product-type    picture x(10).
               10  value-cost      picture 99V99.
           

       01  are-there-more-records picture x value "Y".

       01  hl-header-1.
           05      picture x(20) value spaces.
           05      picture x(32) value "CARGO SHIP TOTAL CALCULATOR".
           05      picture x(4) value spaces.
           05  date-field-format    picture X(10).
           05      picture x(3) value spaces.

       01 date-field.
           05  year-field          picture 9(4).
           05  month-field         picture 9(2).
           05  day-field           picture 9(2).

       01  hl-header-2.
           05      picture x(2) value spaces.
           05      picture x(9) value "SHIP NAME".
           05      picture x(15) value spaces.
           05      picture x(7) value "PRODUCT".
           05      picture x(8) value spaces.
           05      picture x(5) value "UNITS".
           05      picture x(3) value spaces.
           05      picture x(11) value "TOTAL VALUE".
           05      picture x(3) value spaces.
           05      picture x(7) value "COUNTRY".

       procedure division.
       100-main-module.

           open input cargo-rec         
                output cargo-out 

           move function current-date to date-field
           move day-field & "/" & month-field & "/" & year-field 
               to date-field-format
           write print-rec from hl-header-1 after advancing 4 lines
           write print-rec from hl-header-2 after advancing 2 lines

           perform until are-there-more-records = "N"
               read cargo-rec
                   at end
                       move "N" to are-there-more-records
                   not at end
                       perform 200-calc-routine
               end-read
           end-perform

           close cargo-rec
                 cargo-out

           stop run.
           
       200-calc-routine.
           move ship-name-in to ship-name-out
           move product-in to product-out
           move units-in to units-out
           move country-in to country-out

          display "product-in", product-in
           set i to 1
               search product-value-group
                   when product-type(i) = product-in
                       multiply value-cost(i) by units-in
                           giving total-value rounded
               end-search
           
           perform 300-print-rec.

       300-print-rec.
           move cargo-record-out to print-rec
           write print-rec after advancing 2 lines.

       end program Program1.
