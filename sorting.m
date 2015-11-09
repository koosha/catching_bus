% 1.
% Delete the trip_ids
% SampleData(:,4) = [];
% Get the sample size of the data
m = size(SampleData,1);
% Convert actual time and schedule time into seconds
for i = 1:m
    % Separate actual time into hrs, mins, seconds
    act_time = SampleData(i,1);
    act_sec = rem(act_time,100);
    act_time = (act_time - act_sec)/100;
    act_min = rem(act_time,100);
    act_hr = (act_time - act_min)/100;
    % Separate schedule time into hrs, mins
    sch_time = SampleData(i,2);
    sch_min = rem(sch_time,100);
    sch_hr = (sch_time - sch_min)/100;
    % Return actual time and schedual time in seconds
    SampleData(i,1) = act_hr * 3600 + act_min * 60 ...
        + act_sec;
    SampleData(i,2) = sch_hr * 3600 + sch_min * 60;
end
% Change the dates into string for comparison with the weather data
for k = 1:m
    RunDate{k,1} = datestr(SampleRunDate(k,1));
end
% Create a vector that contains time difference between Schedule time and
% actual time
Difference = SampleData(:,1) - SampleData(:,2);
% Select the buses corresponding to specific stops
DataWtE = zeros(1,5);
Time_differ_WtE = zeros(1,1);
RunDate_WtE = cell(1,1);
DataEtW = zeros(1,5);
Time_differ_EtW = zeros(1,1);
RunDate_EtW = cell(1,1);
for s = 1:m
    % West to East stops
    if (SampleData(s,5) == 1620) || (SampleData(s,5) == 1673) || (SampleData(s,5) == 1622) ||(SampleData(s,5) == 1619) ...
            || (SampleData(s,5) == 1959) || (SampleData(s,5) == 1818) || (SampleData(s,5) == 1812) || (SampleData(s,5) == 1840) || (SampleData(s,5) == 1918) || ...
            (SampleData(s,5) == 1960) || (SampleData(s,5) == 1688) || (SampleData(s,5) == 1646)
        DataWtE = [DataWtE; SampleData(s,:)];
        Time_differ_WtE = [Time_differ_WtE; Difference(s,:)];
        RunDate_WtE = [RunDate_WtE; RunDate{s,:}];
    elseif (SampleData(s,5) == 1127) || (SampleData(s,5) == 1077) || (SampleData(s,5) == 1392) ...
            || (SampleData(s,5) == 1141) || (SampleData(s,5) == 1575) || (SampleData(s,5) == 1390) || (SampleData(s,5) == 1466) || (SampleData(s,5) == 1391) ...
            || (SampleData(s,5) == 1083) || (SampleData(s,5) == 1035) || (SampleData(s,5) == 1271) || (SampleData(s,5) == 1322)
        DataEtW = [DataEtW; SampleData(s,:)];
        Time_differ_EtW = [Time_differ_EtW; Difference(s,:)];
        RunDate_EtW = [RunDate_EtW; RunDate{s,:}];
    end
end
% Remove the first row of the Data
DataWtE(1,:) = [];
DataEtW(1,:) = [];
Time_differ_WtE(1,:) = [];
Time_differ_EtW(1,:) = [];
RunDate_WtE(1,:) = [];
RunDate_EtW(1,:) = [];

% 2.
% Combine weather data
Weather = [WeatherFEB; WeatherMar; WeatherApr; WeatherMa; WeatherJun; ...
    WeatherJul; WeatherAug; WeatherSep; WeatherOct];
% Get weather sample size
m_weather = size(Weather,1);
% Convert time of the weather to seconds
weather_t = zeros(m_weather,1);
for i = 1:m_weather
    t = Weather{i,2};
    index = find(t == ':');
    hr = str2double(t(1:index(1)-1));
    min = str2double(t(index(1)+1:end));
    weather_t(i,1) = hr * 3600 + min * 60;
end
% Get West to East sample size
m_wte = size(DataWtE,1);
% Get East to West sampel size
m_etw = size(DataEtW,1);
% Add a column to Data to put in dummy weather variables;
DataWtE = [DataWtE zeros(m_wte,1)];
DataEtW = [DataEtW zeros(m_etw,1)];
% Get Weather to match Runs
for i = 1:m_weather
    % Run from West to East
    for j = 1:m_wte
        if strcmp(RunDate_WtE{j,1},Weather{i,1})
            if (DataWtE(j,1) - weather_t(i,1)) < 3600 && ...
                    (DataWtE(j,1) - weather_t(i,1)) > 0
                % Snow, Freezing Rain, Moderate Snow will have the dummy
                % variable 2
                if strcmp(Weather{i,3},'Snow')
                    DataWtE(j,6) = 2;
                elseif strcmp(Weather{i,3},'Freezing Rain')
                    DataWtE(j,6) = 2;
                elseif strcmp(Weather{i,3},'Moderate Snow')
                    DataWtE(j,6) = 2;
                % Rain, Moderate Rain, Heavy Rain will have the dummy
                % variable 1
                elseif strcmp(Weather{i,3},'Rain')
                    DataWtE(j,6) = 1;
                elseif strcmp(Weather{i,3},'Moderate Rain')
                    DataWtE(j,6) = 1;
                elseif strcmp(Weather{i,3},'Heavy Rain')
                    DataWtE(j,6) = 1;
                end
            end
        end
    end
    % Run from East to West
    for j = 1:m_etw
        if strcmp(RunDate_EtW{j,1},Weather{i,1})
            if (DataEtW(j,1) - weather_t(i,1)) < 3600 && ...
                    (DataEtW(j,1) - weather_t(i,1)) > 0
                % Snow, Freezing Rain, Moderate Snow will have the dummy
                % variable 2
                if strcmp(Weather{i,3},'Snow')
                    DataEtW(j,5) = 2;
                elseif strcmp(Weather{i,3},'Freezing Rain')
                    DataEtW(j,5) = 2;
                elseif strcmp(Weather{i,3},'Moderate Snow')
                    DataEtW(j,5) = 2;
                % Rain, Moderate Rain, Heavy Rain will have the dummy
                % variable 1
                elseif strcmp(Weather{i,3},'Rain')
                    DataEtW(j,5) = 1;
                elseif strcmp(Weather{i,3},'Moderate Rain')
                    DataEtW(j,5) = 1;
                elseif strcmp(Weather{i,3},'Heavy Rain')
                    DataEtW(j,5) = 1;
                end
            end
        end
    end
end

% 3.
% Add a column to each of the RunData in order to store the weekday value
DataWtE = [DataWtE zeros(m_wte,1)];
DataEtW = [DataEtW zeros(m_etw,1)];
% Get Weekday data would be 1 to 7 indicating Monday to Sunday
for i = 1:m_wte
%     RunDateWtE(i,1) = datetime(RunDate_WtE{i,1});
%     if weekday(RunDateWtE(i,1)) == 7
%         DataWtE(i,6) = 7;
%     elseif strcmp(datestr(RunDateWtE(i,1)),'Saturday')
%         DataWtE(i,6) = 0;
%     else
%         DataWtE(i,6) = 1;
%     end
    DataWtE(i,7) = weekday(RunDate_WtE{i,1});
end
for i = 1:m_etw
%     RunDateEtW(i,1) = datetime(RunDate_EtW{i,1});
%     if strcmp(datestr(RunDateEtW(i,1)),'Sunday')
%         DataEtW(i,6) = 0;
%     elseif strcmp(datestr(RunDateWtE(i,1)),'Saturday')
%         DataEtW(i,6) = 0;
%     else
%         DataEtW(i,6) = 1;
%     end
    DataEtW(i,7) = weekday(RunDate_EtW{i,1});
end

% 4.
% Combine DataWtE and DataEtW and find Stops that are unique
DataTotal = [DataWtE; DataEtW];
% Combine TimeDifference
DiffTotal = [Time_differ_WtE; Time_differ_EtW];
% Combine RunDate
RunDateTotal = [RunDate_WtE; RunDate_EtW];
% Create Struct that contains different informations for different stops
% and Divide the informations into 4 parts, route #1 and its time difference,
% and other routes and their time difference.
Stop_ids = unique(DataTotal(:,5));
num_stops = length(Stop_ids);
CompleteData = struct([]);
% Separate Route1 with other Routes
route1index = find(DataTotal(:,3) == 1);
Route1Data = DataTotal(route1index,:);
Route1Diff = DiffTotal(route1index,:);
Route1RunDate = RunDateTotal(route1index,:);
RouteOData = DataTotal;
RouteOData(route1index,:) = [];
RouteODiff = DiffTotal;
RouteODiff(route1index,:) = [];
RouteORunDate = RunDateTotal;
RouteORunDate(route1index,:) = [];
% Add a new column to Route1 Data to indicate the traffic.
Route1Data = [Route1Data zeros(size(Route1Data,1),1)];
stops_info = zeros(num_stops,1);
for i = 1:num_stops
    Route1_stop_index = find(Route1Data(:,5) == Stop_ids(i,1));
    Route1_StopData = Route1Data(Route1_stop_index,:);
    Route1_DiffData = Route1Diff(Route1_stop_index,:);
    Route1_DateData = Route1RunDate(Route1_stop_index,:);
%     CompleteData{i,1} = Route1_StopData;
%     CompleteData{i,2} = Route1_DiffData;
    RouteO_stop_index = find(RouteOData(:,5) == Stop_ids(i,1));
    RouteO_StopData = RouteOData(RouteO_stop_index,:);
    RouteO_DiffData = RouteODiff(RouteO_stop_index,:);
    RouteO_DateData = RouteORunDate(RouteO_stop_index,:);
%     CompleteData{i,3} = RouteO_StopData;
%     CompleteData{i,4} = RouteO_DiffData;
    m_route1 = size(Route1_StopData,1);
    m_routeO = size(RouteO_StopData,1);
    for d1 = 1:m_route1
        index = strmatch(Route1_DateData(d1,1), RouteO_DateData(:,1));
        if ~isempty(index)
        % Get the minimum difference between time
            t = ones(size(index,1),1);
            TimeDiffer = Route1_StopData(d1,2) * t - RouteO_StopData(index,2);
            GetNegativeDiffer = TimeDiffer(find(TimeDiffer < 0),:);
            MinDiffer = max(GetNegativeDiffer);
            if ~isempty(MinDiffer)
                position = find(TimeDiffer == MinDiffer);
                Route1_StopData(d1,8) = RouteO_DiffData(index(position(1,1),1),1);
            else
                Route1_StopData(d1,8) = nan;
            end
        else
            Route1_StopData(d1,8) = nan;
        end
    end
    % Add a column to route#1 Difference to store previous depart time
    Route1_StopData = [Route1_StopData zeros(m_route1,1)];
    CompleteData{i,1} = Route1_StopData;
    CompleteData{i,2} = Route1_DiffData;
    CompleteData{i,3} = Route1_DateData;
    stops_info(i,1) = Route1_StopData(1,5);
end

% 5.
% Get the arrival time of previous bus top of route#1
for i = 1:num_stops
    m_stop = size(CompleteData{i,1},1);
    if stops_info(i,1) == 1673
        pstop = find(stops_info == 1620);
        for j = 1:m_stop
            pstop_sametrip = ...
                find(CompleteData{pstop,1}(:,4) == CompleteData{i,1}(j,4));
            pstop_sameday = ...
                strmatch(CompleteData{i,3}(j,1), CompleteData{pstop,3}(:,1));
            pstop_same = intersect(pstop_sametrip, pstop_sameday);
            if ~isempty(pstop_same)
                CompleteData{i,1}(j,9) = CompleteData{pstop,1}(pstop_same(1,1),1);
            else
                CompleteData{i,1}(j,9) = nan;
            end
        end
    elseif stops_info(i,1) == 1622
        pstop = find(stops_info == 1673);
        for j = 1:m_stop
            pstop_sametrip = ...
                find(CompleteData{i,1}(j,4) == CompleteData{pstop,1}(:,4));
            pstop_sameday = ...
                strmatch(CompleteData{i,3}(j,1), CompleteData{pstop,3}(:,1));
            pstop_same = intersect(pstop_sametrip, pstop_sameday);
            if ~isempty(pstop_same)
                CompleteData{i,1}(j,9) = CompleteData{pstop,1}(pstop_same(1,1),1);
            else
                CompleteData{i,1}(j,9) = nan;
            end
        end
    elseif stops_info(i,1) == 1619
        pstop = find(stops_info == 1622);
        for j = 1:m_stop
            pstop_sametrip = ...
                find(CompleteData{i,1}(j,4) == CompleteData{pstop,1}(:,4));
            pstop_sameday = ...
                strmatch(CompleteData{i,3}(j,1), CompleteData{pstop,3}(:,1));
            pstop_same = intersect(pstop_sametrip, pstop_sameday);
            if ~isempty(pstop_same)
                CompleteData{i,1}(j,9) = CompleteData{pstop,1}(pstop_same(1,1),1);
            else
                CompleteData{i,1}(j,9) = nan;
            end
        end
    elseif stops_info(i,1) == 1959
        pstop = find(stops_info == 1619);
        for j = 1:m_stop
            pstop_sametrip = ...
                find(CompleteData{i,1}(j,4) == CompleteData{pstop,1}(:,4));
            pstop_sameday = ...
                strmatch(CompleteData{i,3}(j,1), CompleteData{pstop,3}(:,1));
            pstop_same = intersect(pstop_sametrip, pstop_sameday);
            if ~isempty(pstop_same)
                CompleteData{i,1}(j,9) = CompleteData{pstop,1}(pstop_same(1,1),1);
            else
                CompleteData{i,1}(j,9) = nan;
            end
        end
    elseif stops_info(i,1) == 1818
        pstop = find(stops_info == 1959);
        for j = 1:m_stop
            pstop_sametrip = ...
                find(CompleteData{i,1}(j,4) == CompleteData{pstop,1}(:,4));
            pstop_sameday = ...
                strmatch(CompleteData{i,3}(j,1), CompleteData{pstop,3}(:,1));
            pstop_same = intersect(pstop_sametrip, pstop_sameday);
            if ~isempty(pstop_same)
                CompleteData{i,1}(j,9) = CompleteData{pstop,1}(pstop_same(1,1),1);
            else
                CompleteData{i,1}(j,9) = nan;
            end
        end
    elseif stops_info(i,1) == 1812
        pstop = find(stops_info == 1818);
        for j = 1:m_stop
            pstop_sametrip = ...
                find(CompleteData{i,1}(j,4) == CompleteData{pstop,1}(:,4));
            pstop_sameday = ...
                strmatch(CompleteData{i,3}(j,1), CompleteData{pstop,3}(:,1));
            pstop_same = intersect(pstop_sametrip, pstop_sameday);
            if ~isempty(pstop_same)
                CompleteData{i,1}(j,9) = CompleteData{pstop,1}(pstop_same(1,1),1);
            else
                CompleteData{i,1}(j,9) = nan;
            end
        end
    elseif stops_info(i,1) == 1840
        pstop = find(stops_info == 1812);
        for j = 1:m_stop
            pstop_sametrip = ...
                find(CompleteData{i,1}(j,4) == CompleteData{pstop,1}(:,4));
            pstop_sameday = ...
                strmatch(CompleteData{i,3}(j,1), CompleteData{pstop,3}(:,1));
            pstop_same = intersect(pstop_sametrip, pstop_sameday);
            if ~isempty(pstop_same)
                CompleteData{i,1}(j,9) = CompleteData{pstop,1}(pstop_same(1,1),1);
            else
                CompleteData{i,1}(j,9) = nan;
            end
        end
    elseif stops_info(i,1) == 1918
        pstop = find(stops_info == 1840);
        for j = 1:m_stop
            pstop_sametrip = ...
                find(CompleteData{i,1}(j,4) == CompleteData{pstop,1}(:,4));
            pstop_sameday = ...
                strmatch(CompleteData{i,3}(j,1), CompleteData{pstop,3}(:,1));
            pstop_same = intersect(pstop_sametrip, pstop_sameday);
            if ~isempty(pstop_same)
                CompleteData{i,1}(j,9) = CompleteData{pstop,1}(pstop_same(1,1),1);
            else
                CompleteData{i,1}(j,9) = nan;
            end
        end
    elseif stops_info(i,1) == 1960
        pstop = find(stops_info == 1918);
        for j = 1:m_stop
            pstop_sametrip = ...
                find(CompleteData{i,1}(j,4) == CompleteData{pstop,1}(:,4));
            pstop_sameday = ...
                strmatch(CompleteData{i,3}(j,1), CompleteData{pstop,3}(:,1));
            pstop_same = intersect(pstop_sametrip, pstop_sameday);
            if ~isempty(pstop_same)
                CompleteData{i,1}(j,9) = CompleteData{pstop,1}(pstop_same(1,1),1);
            else
                CompleteData{i,1}(j,9) = nan;
            end
        end
    elseif stops_info(i,1) == 1688
        pstop = find(stops_info == 1960);
        for j = 1:m_stop
            pstop_sametrip = ...
                find(CompleteData{i,1}(j,4) == CompleteData{pstop,1}(:,4));
            pstop_sameday = ...
                strmatch(CompleteData{i,3}(j,1), CompleteData{pstop,3}(:,1));
            pstop_same = intersect(pstop_sametrip, pstop_sameday);
            if ~isempty(pstop_same)
                CompleteData{i,1}(j,9) = CompleteData{pstop,1}(pstop_same(1,1),1);
            else
                CompleteData{i,1}(j,9) = nan;
            end
        end
    elseif stops_info(i,1) == 1646
        pstop = find(stops_info == 1688);
        for j = 1:m_stop
            pstop_sametrip = ...
                find(CompleteData{i,1}(j,4) == CompleteData{pstop,1}(:,4));
            pstop_sameday = ...
                strmatch(CompleteData{i,3}(j,1), CompleteData{pstop,3}(:,1));
            pstop_same = intersect(pstop_sametrip, pstop_sameday);
            if ~isempty(pstop_same)
                CompleteData{i,1}(j,9) = CompleteData{pstop,1}(pstop_same(1,1),1);
            else
                CompleteData{i,1}(j,9) = nan;
            end
        end
    elseif stops_info(i,1) == 1673
        pstop = find(stops_info == 1620);
        for j = 1:m_stop
            pstop_sametrip = ...
                find(CompleteData{i,1}(j,4) == CompleteData{pstop,1}(:,4));
            pstop_sameday = ...
                strmatch(CompleteData{i,3}(j,1), CompleteData{pstop,3}(:,1));
            pstop_same = intersect(pstop_sametrip, pstop_sameday);
            if ~isempty(pstop_same)
                CompleteData{i,1}(j,9) = CompleteData{pstop,1}(pstop_same(1,1),1);
            else
                CompleteData{i,1}(j,9) = nan;
            end
        end
    elseif stops_info(i,1) == 1077
        pstop = find(stops_info == 1127);
        for j = 1:m_stop
            pstop_sametrip = ...
                find(CompleteData{i,1}(j,4) == CompleteData{pstop,1}(:,4));
            pstop_sameday = ...
                strmatch(CompleteData{i,3}(j,1), CompleteData{pstop,3}(:,1));
            pstop_same = intersect(pstop_sametrip, pstop_sameday);
            if ~isempty(pstop_same)
                CompleteData{i,1}(j,9) = CompleteData{pstop,1}(pstop_same(1,1),1);
            else
                CompleteData{i,1}(j,9) = nan;
            end
        end
    elseif stops_info(i,1) == 1392
        pstop = find(stops_info == 1077);
        for j = 1:m_stop
            pstop_sametrip = ...
                find(CompleteData{i,1}(j,4) == CompleteData{pstop,1}(:,4));
            pstop_sameday = ...
                strmatch(CompleteData{i,3}(j,1), CompleteData{pstop,3}(:,1));
            pstop_same = intersect(pstop_sametrip, pstop_sameday);
            if ~isempty(pstop_same)
                CompleteData{i,1}(j,9) = CompleteData{pstop,1}(pstop_same(1,1),1);
            else
                CompleteData{i,1}(j,9) = nan;
            end
        end
    elseif stops_info(i,1) == 1141
        pstop = find(stops_info == 1392);
        for j = 1:m_stop
            pstop_sametrip = ...
                find(CompleteData{i,1}(j,4) == CompleteData{pstop,1}(:,4));
            pstop_sameday = ...
                strmatch(CompleteData{i,3}(j,1), CompleteData{pstop,3}(:,1));
            pstop_same = intersect(pstop_sametrip, pstop_sameday);
            if ~isempty(pstop_same)
                CompleteData{i,1}(j,9) = CompleteData{pstop,1}(pstop_same(1,1),1);
            else
                CompleteData{i,1}(j,9) = nan;
            end
        end
    elseif stops_info(i,1) == 1575
        pstop = find(stops_info == 1141);
        for j = 1:m_stop
            pstop_sametrip = ...
                find(CompleteData{i,1}(j,4) == CompleteData{pstop,1}(:,4));
            pstop_sameday = ...
                strmatch(CompleteData{i,3}(j,1), CompleteData{pstop,3}(:,1));
            pstop_same = intersect(pstop_sametrip, pstop_sameday);
            if ~isempty(pstop_same)
                CompleteData{i,1}(j,9) = CompleteData{pstop,1}(pstop_same(1,1),1);
            else
                CompleteData{i,1}(j,9) = nan;
            end
        end
    elseif stops_info(i,1) == 1390
        pstop = find(stops_info == 1575);
        for j = 1:m_stop
            pstop_sametrip = ...
                find(CompleteData{i,1}(j,4) == CompleteData{pstop,1}(:,4));
            pstop_sameday = ...
                strmatch(CompleteData{i,3}(j,1), CompleteData{pstop,3}(:,1));
            pstop_same = intersect(pstop_sametrip, pstop_sameday);
            if ~isempty(pstop_same)
                CompleteData{i,1}(j,9) = CompleteData{pstop,1}(pstop_same(1,1),1);
            else
                CompleteData{i,1}(j,9) = nan;
            end
        end
    elseif stops_info(i,1) == 1466
        pstop = find(stops_info == 1390);
        for j = 1:m_stop
            pstop_sametrip = ...
                find(CompleteData{i,1}(j,4) == CompleteData{pstop,1}(:,4));
            pstop_sameday = ...
                strmatch(CompleteData{i,3}(j,1), CompleteData{pstop,3}(:,1));
            pstop_same = intersect(pstop_sametrip, pstop_sameday);
            if ~isempty(pstop_same)
                CompleteData{i,1}(j,9) = CompleteData{pstop,1}(pstop_same(1,1),1);
            else
                CompleteData{i,1}(j,9) = nan;
            end
        end
    elseif stops_info(i,1) == 1391
        pstop = find(stops_info == 1466);
        for j = 1:m_stop
            pstop_sametrip = ...
                find(CompleteData{i,1}(j,4) == CompleteData{pstop,1}(:,4));
            pstop_sameday = ...
                strmatch(CompleteData{i,3}(j,1), CompleteData{pstop,3}(:,1));
            pstop_same = intersect(pstop_sametrip, pstop_sameday);
            if ~isempty(pstop_same)
                CompleteData{i,1}(j,9) = CompleteData{pstop,1}(pstop_same(1,1),1);
            else
                CompleteData{i,1}(j,9) = nan;
            end
        end
    elseif stops_info(i,1) == 1083
        pstop = find(stops_info == 1391);
        for j = 1:m_stop
            pstop_sametrip = ...
                find(CompleteData{i,1}(j,4) == CompleteData{pstop,1}(:,4));
            pstop_sameday = ...
                strmatch(CompleteData{i,3}(j,1), CompleteData{pstop,3}(:,1));
            pstop_same = intersect(pstop_sametrip, pstop_sameday);
            if ~isempty(pstop_same)
                CompleteData{i,1}(j,9) = CompleteData{pstop,1}(pstop_same(1,1),1);
            else
                CompleteData{i,1}(j,9) = nan;
            end
        end
    elseif stops_info(i,1) == 1035
        pstop = find(stops_info == 1083);
        for j = 1:m_stop
            pstop_sametrip = ...
                find(CompleteData{i,1}(j,4) == CompleteData{pstop,1}(:,4));
            pstop_sameday = ...
                strmatch(CompleteData{i,3}(j,1), CompleteData{pstop,3}(:,1));
            pstop_same = intersect(pstop_sametrip, pstop_sameday);
            if ~isempty(pstop_same)
                CompleteData{i,1}(j,9) = CompleteData{pstop,1}(pstop_same(1,1),1);
            else
                CompleteData{i,1}(j,9) = nan;
            end
        end
    elseif stops_info(i,1) == 1271
        pstop = find(stops_info == 1035);
        for j = 1:m_stop
            pstop_sametrip = ...
                find(CompleteData{i,1}(j,4) == CompleteData{pstop,1}(:,4));
            pstop_sameday = ...
                strmatch(CompleteData{i,3}(j,1), CompleteData{pstop,3}(:,1));
            pstop_same = intersect(pstop_sametrip, pstop_sameday);
            if ~isempty(pstop_same)
                CompleteData{i,1}(j,9) = CompleteData{pstop,1}(pstop_same(1,1),1);
            else
                CompleteData{i,1}(j,9) = nan;
            end
        end
    elseif stops_info(i,1) == 1322
        pstop = find(stops_info == 1271);
        for j = 1:m_stop
            pstop_sametrip = ...
                find(CompleteData{i,1}(j,4) == CompleteData{pstop,1}(:,4));
            pstop_sameday = ...
                strmatch(CompleteData{i,3}(j,1), CompleteData{pstop,3}(:,1));
            pstop_same = intersect(pstop_sametrip, pstop_sameday);
            if ~isempty(pstop_same)
                CompleteData{i,1}(j,9) = CompleteData{pstop,1}(pstop_same(1,1),1);
            else
                CompleteData{i,1}(j,9) = nan;
            end
        end
    elseif stops_info(i,1) == 1620 || stops_info(i,1) == 1127
        CompleteData{i,1}(:,9) = nan;
    end
end

% 6.
% Sort out the useful data, the input variables would all be string matrix.
for i = 1:num_stops
    CompleteData{i,2}(:,2) = CompleteData{i,1}(:,9);
    CompleteData{i,1}(:,1) = [];
    CompleteData{i,1}(:,2:3) = [];
    CompleteData{i,1}(:,6) = [];
end
for i = 1:num_stops
    m_stops = size(CompleteData{i,1},1);
    n_stops = size(CompleteData{i,1},2);
    Mtemp = cell(m_stops,n_stops);
    for j = 1:m_stops
        for k = 1:n_stops
            if ~isnan(CompleteData{i,1}(j,k))
                Mtemp{j,k} = num2str(CompleteData{i,1}(j,k));
            else
                Mtemp{j,k} = '';
            end
        end
    end
    CompleteData{i,1} = Mtemp;
end