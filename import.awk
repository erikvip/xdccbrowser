BEGIN { 
    # Only output header if skipheader is not set to 1
    if ( SKIPHEADER != 1 )
        print "'Network', 'Channel', 'Nick', 'Pack #', 'DLs', 'Size', 'Type', 'File'" 
}
{
    # 1 - nick
    # 2 - number
    # 3 - requests
    # 4 - size
    # 5 - file
    FILE=substr($0, index($0,$5))
    HINT="unknown"
    IGNORECASE = 1

    if ( match(FILE, /\.S[0-9]*E[0-9]*\./) || match(FILE, /HDTV/) )
        HINT="TV"
    if ( match(FILE, /\.XXX\./) != 0 )
        HINT="XXX"
    if ( match(FILE, /EBOOK/) != 0 )
        HINT="EBOOK"
    if ( match(FILE, /[\.\-](Android|ISO|Keygen|Linux|MacOSX[\.\-])/) != 0 )
        HINT="APP"

    if ( match(FILE, /[\.\-](MP3|VBR|[2-9]CD|FLAC|Discography)[\.\-]/) != 0 )
        HINT="SOUND"

    if ( match($1, /Anime/) )
        HINT="ANIME"

    # If we still have an Sxx (Season) tag at this point, assume it's a TV series
    if ( match(FILE, /\.S[0-9]+\./) )
        HINT="TV"

    if ( HINT == "unknown" )
        if ( match(FILE, /(\.|-)(BluRay|X264|H264|HDRIP|BDRIP|DVDScr|XVID)(\.|-)/) != 0 || match(FILE, /mkv$/) )
            HINT="MOVIES"


    csv="'"NETWORK"', '"CHANNEL"', '"$1"', '"$2"', '"$3"', '"$4"', '"HINT"', '"FILE"'"
    count++
    #print count

    print csv
    
}
