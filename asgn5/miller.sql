ACCEPT cid PROMPT "Customer ID: ";
ACCEPT vid PROMPT "Vehicle ID: ";
ACCEPT milesout PROMPT "Miles Out: ";
Declare
	thisCid integer;
	thisVid integer;
	checkOutFlag integer;
	errorFlag boolean:=FALSE;
	Cursor quer is
		select c_id from customers where c_id = &cid;
	Cursor vQuer is
		select id from vehicles where id = &vid;
	Cursor ckQuer is
                select v_id from rentals where v_id = &vid and ret_date is null; 
Begin
	Open quer;
	Loop
		Fetch quer into thisCid;
		Exit when quer%notfound;
	End Loop;
	Close quer;
	Open vQuer;
        Loop
                Fetch vQuer into thisVid;
                Exit when vQuer%notfound;
        End Loop;
        Close vQuer;
	Open ckQuer;
        Loop
                Fetch ckQuer into checkOutFlag;
                Exit when ckQuer%notfound;
        End Loop;
        Close ckQuer;
	IF thisCid IS NULL then
		errorFlag:=TRUE;
		dbms_output.put_line('Error: Customer ID not found');
	END IF;
	IF thisVid IS NULL then
		errorFlag:=TRUE;
                dbms_output.put_line('Error: Vehicle ID not found');
        END IF;
        IF checkOutFlag IS not NULL then
		errorFlag:=TRUE;
                dbms_output.put_line('Error: Vehicle Already Checked Out');

        END IF;
	IF errorFlag = FALSE then
		insert into rentals values(&cid,&vid,sysdate,&milesout,NULL,NULL);
		dbms_output.put_line('Success: Record Added!');	
	END IF;
End;
/
