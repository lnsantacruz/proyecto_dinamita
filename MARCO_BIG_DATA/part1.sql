--CREATE OR REPLACE DIRECTORY  DIR_READ AS 'C:\Directory_read';

--set serveroutput on


DECLARE
    TYPE typ_rec IS RECORD
    (
      line NUMBER,
      COLUMN VARCHAR2(14)
    );
    
    TYPE typ_field
         IS TABLE OF typ_rec;
    
    
    v_field   typ_field;
    v_last    NUMBER := 0;
    v_file    UTL_FILE.FILE_TYPE;
    v_line    VARCHAR2(500);
  
BEGIN 

  v_file    := UTL_FILE.FOPEN 
              ( 
                'DIR_READ', -- Nombre del directorio en mayuscula 
                'SourceFile.txt',
                'R'
              );
LOOP
  BEGIN 
      v_field    := typ_field();
      
      UTL_FILE.GET_LINE(v_file, v_line);
      FOR i IN 1..6 LOOP
          v_field.EXTEND;
          v_field(i).line     := INSTR(v_line,'|',v_last+1,1);
          
         CASE
            WHEN  i=1 THEN
                v_field(i).column   :='LINEA';
                
            WHEN  i=2 THEN
                v_field(i).column   :='NOMBRE';
                
            WHEN  i=3 THEN
                v_field(i).column   :='NACIONALIDAD';
                  
            WHEN  i=4 THEN
                v_field(i).column   :='EDAD';
                    
            WHEN  i=5 THEN
                v_field(i).column   :='ESTADO CIVIL';
            
            ELSE
                 v_field(i).column   := 'CHILDREN_COUNT';
                 
         END CASE;
         
         v_last  :=  v_field(i).line;
         
  END LOOP;
  
  v_last   :=0;
  
  DBMS_OUTPUT.PUT_LINE(RPAD('=',LENGTH(v_line), '='));
  DBMS_OUTPUT.PUT_LINE(v_line);
  DBMS_OUTPUT.PUT_LINE(RPAD('=',LENGTH(v_line), '='));
  
  
  DBMS_OUTPUT.PUT_LINE(v_field(1).column||':'||SUBSTR(v_line,1,v_field(1).line-1));
  FOR i IN 1..5 LOOP
        DBMS_OUTPUT.PUT_LINE(v_field(i+1).column||': '||
                              SUBSTR
                                  (
                                      v_line,v_field(i).line+1,
                                      v_field(i+1).line-v_field(i).line-1
                                  )
                              );
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('VEHICULO: '||SUBSTR(v_line,v_field(6).line+1,LENGTH(v_line)));
  
  EXCEPTION 
      WHEN NO_DATA_FOUND THEN 
            EXIT;
            
    END;
  END LOOP;
  
  UTL_FILE.FCLOSE(v_file);
  
END;