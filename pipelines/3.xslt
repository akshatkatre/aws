<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="xml" indent="yes"/>
<xsl:key name="TripGuideId" match="/Company/GuideList/Guide" use="@Id" />
<xsl:key name="TripCustomerId" match="/Company/CustomerList/Customer" use="@Id" />
<xsl:key name="TourStartDestinationId" match="/Company/DestinationList/Destination" use="@Id" />
<xsl:variable name="vTripId" select="900"/>
<xsl:template match="Company">
    <upcomming-trip>
    <xsl:apply-templates select="TripList/Trip"/>
</upcomming-trip>
</xsl:template>
<xsl:template match="TripList/Trip">
<xsl:if test="@Id = $vTripId">
    <xsl:apply-templates select="TripGuides/TripGuide"/>
</xsl:if>
</xsl:template>
<xsl:template match="TripList/Trip/TripGuides/TripGuide">
<letter>
    <guideid><xsl:value-of select="@GuideId"></xsl:value-of></guideid>
    <name>
    <xsl:value-of select="key('TripGuideId', @GuideId)/PrimaryInformation/@FirstName"></xsl:value-of>
<xsl:value-of select="key('TripGuideId', @GuideId)/PrimaryInformation/@LastName"></xsl:value-of>
</name>
<xsl:call-template name="getTourName"/>
<xsl:call-template name="getTripDetails"/>
<xsl:call-template name="getCustomerDetails"/>
<xsl:call-template name="getTourItinerary"/>
<xsl:call-template name="getDestinationDetails"/>
</letter>
</xsl:template>
<xsl:template name="getTourName">
    <xsl:variable name="vTourId" select="/Company/TripList/Trip[@Id=$vTripId]/@TourId"/>
    <tourname>
    <xsl:value-of select="/Company/TourList/Tour[@Id=$vTourId]/@Name"/> 
</tourname>
</xsl:template>
<xsl:template name="getTripDetails">
    <tripmessage>
    Your Trip is scheduled from <xsl:value-of select="/Company/TripList/Trip[@Id=$vTripId]/@StartDate"/> until <xsl:value-of select="/Company/TripList/Trip[@Id=$vTripId]/@EndDate"/>
</tripmessage>
</xsl:template>
<xsl:template name="getCustomerDetails">
    <customers>
<xsl:for-each select="/Company/TripList/Trip[@Id=$vTripId]/Participants/Customer">
<customer>
<name>
<xsl:value-of select="key('TripCustomerId', @CustomerId)/PrimaryInformation/@Title"></xsl:value-of> <xsl:value-of select="key('TripCustomerId', @CustomerId)/PrimaryInformation/@FirstName"></xsl:value-of> <xsl:value-of select="key('TripCustomerId', @CustomerId)/PrimaryInformation/@LastName"></xsl:value-of> 
</name>
<mobile>
<xsl:value-of select="key('TripCustomerId', @CustomerId)/Contact/@MobilePhone"></xsl:value-of> 
</mobile>
</customer>
</xsl:for-each>
</customers>
</xsl:template>

<xsl:template name="getTourItinerary">
    <itinerary>
    <xsl:variable name="vTourId" select="/Company/TripList/Trip[@Id=$vTripId]/@TourId"/>
    <xsl:for-each select="/Company/TourList/Tour[@Id=$vTourId]/TourItinerary/Day">
    <activity>
        <xsl:value-of select="@Category"/> : 
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
                <xsl:value-of select="/Company/DestinationList/Destination[@Id=$vStartDest]/@DestinationName"/> to <xsl:value-of select="/Company/DestinationList/Destination[@Id=$vEndDest]/@DestinationName"/>,  <xsl:value-of select="@NoOfMiles"/> miles.
            </xsl:otherwise>
        </xsl:choose>
    </activity>
    </xsl:for-each>
</itinerary>
</xsl:template>	

<xsl:template name="getDestinationDetails">
    <xsl:variable name="vTourId" select="/Company/TripList/Trip[@Id=$vTripId]/@TourId"/>
    <destinations>
    <xsl:for-each select="/Company/TourList/Tour[@Id=$vTourId]/TourItinerary/Day">

    <xsl:if test="@Category != 'START'">
        <destination>
            <id><xsl:value-of select="@StartDestinationId"></xsl:value-of></id>
        <name><xsl:value-of select="key('TourStartDestinationId', @StartDestinationId)/@DestinationName"></xsl:value-of> 
        </name>
        <type>
            <xsl:value-of select="key('TourStartDestinationId', @StartDestinationId)/@DestinationType"/>
        </type>
        <email>
            <xsl:value-of select="key('TourStartDestinationId', @StartDestinationId)/Contact/@EmailId"/>
        </email>
        <mobile>
            <xsl:value-of select="key('TourStartDestinationId', @StartDestinationId)/Contact/@MobilePhone"/>
        </mobile>
        <address>
            <xsl:value-of select="key('TourStartDestinationId', @StartDestinationId)/Address/@AddressLine1"/>,
            <xsl:value-of select="key('TourStartDestinationId', @StartDestinationId)/Address/@AddressLine2"/>,
            <xsl:value-of select="key('TourStartDestinationId', @StartDestinationId)/Address/@PostCode"/>,
            <xsl:value-of select="key('TourStartDestinationId', @StartDestinationId)/Address/@Country"/>
        </address>
    </destination>
    </xsl:if>

    </xsl:for-each>
</destinations>
</xsl:template>
</xsl:stylesheet>