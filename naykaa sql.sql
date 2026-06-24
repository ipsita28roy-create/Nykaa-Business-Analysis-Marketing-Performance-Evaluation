USE nykaa_analytics;

SELECT 
    Campaign_Type,
    Channel_Used,
    SUM(Impressions) AS Total_Impressions,
    SUM(Clicks) AS Total_Clicks,
    SUM(Leads) AS Total_Leads,
    SUM(Conversions) AS Total_Conversions,
    -- Click-Through Rate (CTR)
    ROUND((SUM(Clicks) / NULLIF(SUM(Impressions), 0)) * 100, 2) AS CTR_Percentage,
    -- Lead-to-Click Rate
    ROUND((SUM(Leads) / NULLIF(SUM(Clicks), 0)) * 100, 2) AS Lead_to_Click_Percentage,
    -- Final Conversion Rate (CVR)
    ROUND((SUM(Conversions) / NULLIF(SUM(Leads), 0)) * 100, 2) AS CVR_From_Leads_Percentage
FROM nykaa_campaign_data
GROUP BY Campaign_Type, Channel_Used
ORDER BY Total_Impressions DESC;

SELECT 
    Campaign_ID, Campaign_Type, Channel_Used, Acquisition_Cost, Revenue, ROI, Engagement_Score
FROM nykaa_campaign_data
WHERE Acquisition_Cost > (SELECT AVG(Acquisition_Cost) FROM nykaa_campaign_data)
  AND ROI < (SELECT AVG(ROI) FROM nykaa_campaign_data)
ORDER BY Acquisition_Cost DESC, ROI ASC
LIMIT 10;

SELECT 
    Campaign_ID, Campaign_Type, Channel_Used, Acquisition_Cost, Revenue, ROI, Engagement_Score
FROM nykaa_campaign_data
WHERE Acquisition_Cost < (SELECT AVG(Acquisition_Cost) FROM nykaa_campaign_data)
  AND ROI > (SELECT AVG(ROI) * 2 FROM nykaa_campaign_data)
ORDER BY ROI DESC, Acquisition_Cost ASC
LIMIT 10;

SELECT 
    Customer_Segment,
    ROUND(AVG(Engagement_Score), 2) AS Avg_Engagement_Score,
    ROUND(AVG(ROI), 2) AS Avg_ROI,
    SUM(Revenue) AS Total_Revenue,
    -- Financial Value per Engagement Unit
    ROUND(AVG(ROI) / NULLIF(AVG(Engagement_Score), 0), 4) AS Financial_Value_Per_Engagement
FROM nykaa_campaign_data
GROUP BY Customer_Segment
ORDER BY Financial_Value_Per_Engagement DESC;

