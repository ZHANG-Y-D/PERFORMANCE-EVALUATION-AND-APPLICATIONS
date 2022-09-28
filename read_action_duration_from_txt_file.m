function action_durations = read_action_duration_from_txt_file(filename)
    
    action_durations = zeros(linecount(filename),1);

    fid = fopen(filename);
    
    line = fgetl(fid);
    
    n = 1;
    while ischar(line)
%         action_duration = sscanf(line,'%f');
        action_duration = sscanf(line,'%s');
        action_durations(n,1) = str2double(action_duration);
        line = fgetl(fid);
        n = n + 1;
    end
    
    
    fclose(fid);
end

function n = linecount(filename)
    [fid, msg] = fopen(filename);
    if fid < 0
        error('Failed to open file "%s" because "%s"', filename, msg);
    end
    n = 0;
    while true
        t = fgetl(fid);
        if ~ischar(t)
            break;
        else
            n = n + 1;
        end
    end
    fclose(fid);
end
