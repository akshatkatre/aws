<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="html" indent="yes"/>
<xsl:key name="TripGuideId" match="/Company/GuideList/Guide" use="@Id" />
<xsl:variable name="vTripId" select="900"/>
<xsl:key name="TripCustomerId" match="/Company/CustomerList/Customer" use="@Id" />
<xsl:template match="Company">
    <xsl:apply-templates select="TripList/Trip"/>
</xsl:template>
<xsl:template match="TripList/Trip">
<xsl:if test="@Id = $vTripId">
    <xsl:apply-templates select="TripGuides/TripGuide"/>
</xsl:if>
</xsl:template>
<xsl:template match="TripList/Trip/TripGuides/TripGuide">
    <xsl:value-of select="@GuideId"></xsl:value-of>
<xsl:value-of select="key('TripGuideId', @GuideId)/PrimaryInformation/@FirstName"></xsl:value-of>
<xsl:value-of select="key('TripGuideId', @GuideId)/PrimaryInformation/@LastName"></xsl:value-of>
<xsl:call-template name="getTourName"/>
</xsl:template>
<xsl:template name="getTourName">
    <xsl:variable name="vTourId" select="/Company/TripList/Trip[@Id=$vTripId]/@TourId"/>
    <xsl:value-of select="/Company/TourList/Tour[@Id=$vTourId]/@Name"/> 
    <xsl:call-template name="getTripDetails"/>
    <xsl:call-template name="getTourItinerary"/>
    <xsl:call-template name="getCustomerDetails"></xsl:call-template>
</xsl:template>
<xsl:template name="getTripDetails">
    Your Trip is scheduled from <xsl:value-of select="/Company/TripList/Trip[@Id=$vTripId]/@StartDate"/> until <xsl:value-of select="/Company/TripList/Trip[@Id=$vTripId]/@EndDate"/>
</xsl:template>	
<xsl:template name="getTourItinerary">
    <xsl:variable name="vTourId" select="/Company/TripList/Trip[@Id=$vTripId]/@TourId"/>
    <xsl:for-each select="/Company/TourList/Tour[@Id=$vTourId]/TourItinerary/Day">
        <xsl:value-of select="@Category"/> , 
        <xsl:choose>
            <xsl:when test="@Category = 'START' or @Category = 'FINISH'">
                <xsl:if test="@Category = 'START'">
                    <xsl:variable name="vStartDest" select="@StartDestinationId"/>
        Travel to <xsl:value-of select="/Company/DestinationList/Destination[@Id=$vStartDest]/@DestinationName"/> where your first night's accommodation has been booked
                </xsl:if>
                <xsl:if test="@Category = 'FINISH'">
                    <xsl:variable name="vStartDest" select="@StartDestinationId"/>
        Depart from <xsl:value-of select="/Company/DestinationList/Destination[@Id=$vStartDest]/@DestinationName"/> after breakfast
                </xsl:if>	

            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="vStartDest" select="@StartDestinationId"/>
                <xsl:variable name="vEndDest" select="@EndDestinationId"/>
                <xsl:value-of select="/Company/DestinationList/Destination[@Id=$vStartDest]/@DestinationName"/> to
                <xsl:value-of select="/Company/DestinationList/Destination[@Id=$vEndDest]/@DestinationName"/> ; <xsl:value-of select="@NoOfMiles"/>		
            </xsl:otherwise>
        </xsl:choose>
    </xsl:for-each>
</xsl:template>	
<xsl:template name="getCustomerDetails">
<xsl:for-each select="/Company/TripList/Trip[@Id=$vTripId]/Participants/Customer">
<xsl:value-of select="key('TripCustomerId', @CustomerId)/PrimaryInformation/@Title"></xsl:value-of> <xsl:value-of select="key('TripCustomerId', @CustomerId)/PrimaryInformation/@FirstName"></xsl:value-of> <xsl:value-of select="key('TripCustomerId', @CustomerId)/PrimaryInformation/@LastName"></xsl:value-of> 

<xsl:value-of select="key('TripCustomerId', @CustomerId)/Contact/@MobilePhone"></xsl:value-of> 

</xsl:for-each>
</xsl:template>
</xsl:stylesheet>