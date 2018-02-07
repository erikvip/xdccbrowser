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
        HINT="eBook"
    if ( match(FILE, /[\.\-](Android|ISO|Keygen|Linux|MacOSX[\.\-])/) != 0 )
        HINT="APP"

    if ( match(FILE, /[\.\-](MP3|VBR|[2-9]CD|FLAC|Discography)[\.\-]/) != 0 )
        HINT="Sound"

    if ( match($1, /Anime/) )
        HINT="TV/Anime"

    # If we still have an Sxx (Season) tag at this point, assume it's a TV series, also check for TV matches in nickname
    if ( match(FILE, /\.S[0-9]+\./) || match($1, /[\-\|](TV|HDTV)[\-\|]/ ) )
        HINT="TV"

    if ( HINT == "unknown" ) {
        if ( match(FILE, /(\.|-)(BluRay|X264|H264|HDRIP|BDRIP|DVDScr|XVID)(\.|-)?/) != 0 || match(FILE, /mkv$/) )
            HINT="Movies"
        # Last try, try to assign using their nickname / category. 
        else if ( match($1, /[\-\|]APP[\-\|]/) )
            HINT="APP"
        else if ( match($1, /[\-\|]MUSIC[\-\|]/) )
            HINT="Sound"

        # 'Movies' with a date tag should probably be TV...
        if ( HINT == "MOVIES" )
            if ( match(FILE, /\.(19|20)[0-9]{2}\.[0-9]{2}\.[0-9]{2}\./) )
                HINT="TV"
    }


    csv="'"NETWORK"', '"CHANNEL"', '"$1"', '"$2"', '"$3"', '"$4"', '"HINT"', '"FILE"'"
    count++
    #print count

    print csv
    
}
