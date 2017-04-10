BEGIN { print "'Network', 'Channel', 'Nick', 'Pack #', 'DLs', 'Size', 'Type', 'File'" }
{
    # 1 - nick
    # 2 - number
    # 3 - requests
    # 4 size
    # 5- file
    FILE=substr($0, index($0,$5))
    HINT="unknown"
    IGNORECASE = 1

    if ( match(FILE, /\.S[0-9]*E[0-9]*\./) || match(FILE, /HDTV/) )
        HINT="TV"
    if ( match(FILE, /\.XXX\./) != 0 )
        HINT="XXX"
    if ( match(FILE, /EBOOK/) != 0 )
        HINT="EBOOK"
    if ( match(FILE, /(Android|\.ISO|ISO\.)/) != 0 )
        HINT="APP"

    if ( match(FILE, /\.(MP3|VBR|2CD)\./) != 0 )
        HINT="SOUND"

    if ( HINT == "unknown" )
        if ( match(FILE, /(\.|-)(BluRay|X264|H264|HDRIP|BDRIP|DVDScr|XVID)(\.|-)/) != 0 || match(FILE, /mkv$/) )
            HINT="MOVIES"





    #sql="INSERT INTO packs VALUES('"NETWORK"', '"CHANNEL"', '"$1"', '"$2"', '"$3"', '"$4"', '"FILE"', 'HINT', 'test' );"
    csv="'"NETWORK"', '"CHANNEL"', '"$1"', '"$2"', '"$3"', '"$4"', '"HINT"', '"FILE"'"
    count++
    #print count


    #print sql | "sqlite3 xdcc.sqlite3"
    #print sql > "wtf.sql"
    #print csv > "wtf.csv"
    
    print csv
    
}
