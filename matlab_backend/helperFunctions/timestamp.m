function [ ts ] = timestamp( )

    c = clock;
    ts = [num2str(c(4)) num2str(c(5)) num2str(c(6))];
    ts = strrep(ts, '.', '');
    ts = str2num(ts);
end
