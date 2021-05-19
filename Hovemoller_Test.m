%% derive the points
A_xyd=Pts_on_CL('F:\Thesis_phd\Paper_2\test\Test_centerline_N1_1.shp',300);

%% read the date_interval file
Date_d=xlsread('F:\Thesis_phd\Paper_2\Smooth\Date_dif.xlsx');
%% the date information of the study period
Year_n=[365,365,366,365,365,365]';
Month_n=[31 31;28 29;31 31 ;30 30;31 31 ;30 30;31 31 ;31 31;30 30;31 31;30 30;31 31];
%% read the velocity map
Path='the path of velocity maps';
add=strcat(Path,'*.tif');
Add=dir(add);
[m_Add,n_Add]=size(Add);
Aa={Add.name};
Aa=Aa';
T=0;
%% generate the velocity matrix
DATA_TIME_SERIES=nan(N_day_all,m_xyd);
for I=1:m_Add
    
    name_image=strcat(Path,Aa{I,1});
    name_info=Aa{I,1};
    name_info_N=name_info(1:8);
    year_n=str2num(name_info_N(1:4));
    month_n=str2num(name_info_N(5:6));
    day_n=str2num(name_info_N(7:8));
    n_year=year_n-2014;
    A=imread(name_image);
    [M,N]=size(A);
    
    refTifInfo=geotiffinfo(name_image);
    refULxy=refTifInfo.RefMatrix(3,:);
    t1=refULxy(2);
    s1=refULxy(1);
    PS_XY=[90 90];
    j=3+I;
    for i=1:m_xyd
        
        X=A_xyd(i,1);
        Y=A_xyd(i,2);
        m=ceil(abs((Y-t1)/90));
        n=ceil(abs((X-s1)/90));
        C1=[];
        
        for ii=(m-1):(m+1)
            for jj=(n-1):(n+1)
                C1(ii-m+2,jj-n+2)=A(ii,jj);
            end
        end
        s_c1=0;
        t_c1=0;
        for i_c1=1:3
            for j_c1=1:3
                if C1(i_c1,j_c1)~=-999
                    s_c1=s_c1+C1(i_c1,j_c1);
                    t_c1=t_c1+1;
                end
            end
        end
        if t_c1>=4
            A_xyd(i,j)=s_c1/t_c1;
        else
            A_xyd(i,j)=nan;
        end
        I_n=n_year+1;
        A_xyd(i,j)=A_xyd(i,j)./Date_d(I,1).*Year_n(I_n,1);
        
    end
    DATA=A_xyd(:,j);
    DATA_N=DATA';
    
    %%%%%%%%%%
    %%%%% Judge if this year is a leap year
    T_leap=mod(year_n,4);
    if T_leap==0
        Mth=2;
    else
        Mth=1;
    end
    
    if n_year==0
        Day_n_row=sum(Month_n(1:(month_n-1),Mth))+day_n;
    else
        Day_n_row=sum(Year_n(1:n_year))+sum(Month_n(1:(month_n-1),Mth))+day_n;
    end
    
    for i_day=1:Date_d(I,1)
        t=Day_n_row+i_day-1;
        DATA_TIME_SERIES(N_day_all+1-t,:)=DATA_N;
    end
    if I==1
        R_end=N_day_all+1-Day_n_row;
    elseif I==m_Add
        R_start=N_day_all+1-Day_n_row-Date_d(I,1)+1;
    end
    
    
end

%% plot
figure
yyaxis left
hh=imagesc(DATA_TIME_SERIES);
set(hh,'alphadata',~isnan(DATA_TIME_SERIES));
colormap jet;
yyaxis right
plot(1:1:123,ELE)