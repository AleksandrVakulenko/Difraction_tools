function Header_struct = parse_header(filename)
    header = get_header(filename);
    
    Header_props = {"xml_version", 1, "version"; ...
                     "file_type", 2, "type"; ...
                     "file_version", 2, "version"; ...
                     "byte_order", 2, "byte_order"; ...
                     "header_type", 2, "header_type"; ...
                     "wholeExtent", 3, "WholeExtent"; ...
                     "origin", 3, "Origin"; ...
                     "spacing", 3, "Spacing"; ...
                     "extent", 4, "Extent"; ...
                     "scalars", 5, "Scalars"; ...
                     "data_type", 6, "type"; ...
                     "data_name", 6, "Name"; ...
                     "data_format", 6, "format" };
    
    for i = 1:size(Header_props, 1)
        Field_name = Header_props{i, 1};
        Line_num = Header_props{i, 2};
        Pattern = Header_props{i, 3};
        Line = header(Line_num);
    
        Result = find_prop(Line, Pattern);
        Header_struct.(Field_name) = Result;
    end
end



function header = get_header(filename)
    fid = fopen(filename);
    
    try
        header = string.empty;
        for i = 1:6
            header(i) = fgetl(fid);
            header(i) = strtrim(header(i));
        end
    catch err
        fclose(fid);
        rethrow(err);
    end
    
    fclose(fid);
end




function result = find_prop(Line, Pattern)
    Pattern = [' ' char(Pattern) '='];
    L = char(Line);
    ind_quotes = strfind(L, """");
    
    ind = strfind(L, Pattern);
    if isempty(ind)
        error('Header read error');
    end
    
    ind_quotes = ind_quotes(ind_quotes>ind);
    if isempty(ind_quotes)
        error('Header read error');
    end
    ind_quotes = ind_quotes(1:2);
    
    result = L(ind_quotes(1)+1:ind_quotes(2)-1);
end
