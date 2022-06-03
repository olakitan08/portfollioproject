select * from yt_Opportunities_Data --4133

select new_account_no,opportunity_id,new_opportunity_name from yt_Opportunities_Data

select * from yt_Opportunities_Data where Product_Category = 'services'--1269

select * from yt_opportunities_data where Opportunity_Stage in ('stage - 0','stage - 1','stage - 4')

select * from yt_opportunities_data where Opportunity_Stage not in ('stage - 0','stage - 1','stage - 4')

select * from yt_Opportunities_Data where New_Opportunity_Name like '$phase - 1$'