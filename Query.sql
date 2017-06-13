CREATE DIRECTORY DIR_MMDB_UAS
AS 'C:\Musik_Tradisional';

-----------------------------------------------------------------

CREATE TABLE MusikTradisional(
Id_Musik NUMBER,
Nama_Musik varchar2(20),
Foto_Musik ORDImage,
Video_Musik ORDVideo,
Audio_Musik ORDAudio)
LOB (Foto_Musik.source.localData) store as (chunk 32k)
LOB (Video_Musik.source.localData) store as (chunk 32k)
LOB (Audio_Musik.source.localData) store as (chunk 32k);

Desc musiktradisional;

------------------------Upload Data Image, Video, Audio --------------------------------------------------
set serveroutput on;

DECLARE
img ORDImage;
aud ORDAudio;
vid ORDVideo;
ctx RAW(64) := NULL;
BEGIN
  INSERT
  INTO musiktradisional(Id_Musik, Nama_Musik, Foto_Musik, Video_Musik, Audio_Musik)
VALUES(1,'Sape',ORDImage.init('FILE','DIR_MMDB_UAS','F_Sape.jpg'),
  ORDVideo.init('FILE','DIR_MMDB_UAS','V_Sape.avi'),
	ORDAudio.init('FILE','DIR_MMDB_UAS','A_Sape.mp3')) 
returning Foto_Musik, Video_Musik, Audio_Musik 
    INTO img, vid, aud;
img.import(ctx);
vid.import(ctx);
vid.setProperties(ctx);
aud.import(ctx);
aud.setProperties(ctx);
    UPDATE musiktradisional SET Foto_Musik = img, Video_Musik  =  vid, Audio_Musik  = aud 
    WHERE Id_Musik = 1;
    COMMIT;
      END;
  /
  
  ------------------------------------ Menampilkan data -------------------------------------------------------
  
  select t.Id_Musik, 
		 t.Nama_Musik, 
		 t.Foto_Musik.getSourcename() as "Foto Musik",
         t.Video_Musik.getSourcename() as "Video Musik",
         t.Audio_Musik.getSourcename() as "Audio Musik"
  from musiktradisional t
  order by Id_Musik asc
  
  
----------------------------------  Menampilkan Gambar ----------------------------------------------------------
  
SELECT t.Id_Musik, t.Nama_Musik , t.Foto_Musik.getSourcename() 
	as "Foto Musik"
	from musiktradisional t
order by Id_Musik asc
  
----------------------------------  Menampilkan Video ---------------------------------------------------------- 
 
SELECT t.Id_Musik, t.Nama_Musik , t.video_musik.getSourcename() as "Video Musik"
from musiktradisional t
order by Id_Musik asc

----------------------------------  Menampilkan Audio ----------------------------------------------------------

SELECT t.Id_Musik, t.Nama_Musik , t.audio_musik.getSourcename() as "Audio Musik"
from musiktradisional t
order by Id_Musik asc
  
  
----------------------------------- Method untuk data Image ------------------------------------------------
set serveroutput on;

DECLARE
img ORDSYS.ORDImage;
idimg    integer;
nameimg varchar2(100);
  BEGIN
dbms_output.put_line ('Image Properties');
dbms_output.put_line ('-----------------------------------------');
  FOR I IN 1..3
  LOOP
    SELECT
id_musik, nama_musik, foto_musik into idimg, nameimg, img from musiktradisional where id_musik=I;
dbms_output.put_line ('Id Image'||idimg);
dbms_output.put_line ('Name Image :'||nameimg);
dbms_output.put_line ('Width Image : '||img.getWidth());  
dbms_output.put_line ('Hight Image : '||img.getHeight()); 
dbms_output.put_line ('Image File Format : '||img.getFileFormat()); 
dbms_output.put_line ('Image Source  : '||img.getSource); 
dbms_output.put_line ('Image Content Length : '||img.getContentLength());
dbms_output.put_line ('-----------------------------------------');
end loop;
end;
    /

--------------------------------- Method untuk data audio ------------------------------------------

 set serveroutput on;
 
DECLARE
aud ORDSYS.ORDAudio;
idaud    integer;
nameaud varchar2(100);
  BEGIN
dbms_output.put_line ('Audio Properties');
dbms_output.put_line ('-----------------------------------------');
  FOR I IN 1..3
  LOOP
    SELECT
id_musik, nama_musik, audio_musik into idaud, nameaud, aud from musiktradisional where id_musik=I;
dbms_output.put_line ('Id Audio'||idaud);
dbms_output.put_line ('Name Audio :'||nameaud);
dbms_output.put_line ('Audio Content length  : '||aud.getContentLength()); 
dbms_output.put_line ('Audio duration  : '||aud.getaudioduration()); 
dbms_output.put_line ('Compression Type  : '||aud.getcompressiontype());
dbms_output.put_line ('Encoding  : '||aud.getencoding()); 
dbms_output.put_line ('Number Channels  : '||aud.getnumberofchannels()); 
dbms_output.put_line ('-----------------------------------------');
end loop;
end;
    /    
    
    
----------------------- Method untuk data video -----------------------------------------    
    
set serveroutput on;

DECLARE
vid ORDSYS.ORDVideo;
idivid    integer;
namevid varchar2(100);
  BEGIN
dbms_output.put_line ('Video Properties');
dbms_output.put_line ('-----------------------------------------');
  FOR I IN 1..3
  LOOP
    SELECT
    
id_musik, nama_musik, video_musik into idivid, namevid, vid from musiktradisional where id_musik=I;
dbms_output.put_line ('Id Video'||idivid);
dbms_output.put_line ('Name Video :'||namevid); 
dbms_output.put_line ('Video Format : '||vid.getformat);
dbms_output.put_line ('Video Content Length : '||vid.getContentlength);
dbms_output.put_line ('Video Duration : '||vid.getvideoduration);
dbms_output.put_line ('Mime Type: '||vid.getmimetype);
dbms_output.put_line ('Number of Frames: '||vid.getNumberofFrames()); 
dbms_output.put_line ('-----------------------------------------');
end loop;
end;  
/
  