<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<!--This xslt will produce mailer to guides particpating in the upcoming trip
    Output will be generated in an xml format.
 -->
	<xsl:output method="xml" indent="yes"/>
	<!--Create key lookups for Guide, Customer and Destination entity-->
	<xsl:key name="TripGuideId" match="/Company/GuideList/Guide" use="@Id" />
	<xsl:key name="TripCustomerId" match="/Company/CustomerList/Customer" use="@Id" />
	<xsl:key name="TourStartDestinationId" match="/Company/DestinationList/Destination" use="@Id" />
	<!--THIS IS THE INPUT THAT NEEDS TO BE PASSED TO THE XSLT. AS THE INFORMATION
	IS FOR AN UPCOMMING TOUR, TRIP ID NEEDS TO BE SET.-->
	<xsl:variable name="vTripId" select="900"/>
	<!-- Invoke template for each trip-->
	<xsl:template match="Company">
		<upcomming-trip>
			<xsl:apply-templates select="TripList/Trip"/>
		</upcomming-trip>
	</xsl:template>
	<!-- In this template invoke the TripGuide template only for tripid set at 
    the begining of the file-->
	<xsl:template match="TripList/Trip">
		<xsl:if test="@Id = $vTripId">
			<xsl:apply-templates select="TripGuides/TripGuide"/>
		</xsl:if>
	</xsl:template>
	<!-- The trip guide template pull details per trip-->
	<xsl:template match="TripList/Trip/TripGuides/TripGuide">
		<letter>
			<guideid><xsl:value-of select="@GuideId"></xsl:value-of></guideid>
			<name>
				<xsl:value-of select="key('TripGuideId', @GuideId)/PrimaryInformation/@FirstName"></xsl:value-of><xsl:text> </xsl:text><xsl:value-of select="key('TripGuideId', @GuideId)/PrimaryInformation/@LastName"></xsl:value-of>
			</name>
			<!-- For each guide pull information by calling additional templates-->
			<xsl:call-template name="getTourName"/>
			<xsl:call-template name="getTripDetails"/>
			<xsl:call-template name="getCustomerDetails"/>
			<xsl:call-template name="getTourItinerary"/>
			<xsl:call-template name="getDestinationDetails"/>
		</letter>
	</xsl:template>
	<!-- This template will output the tour name based on the trip id-->
	<xsl:template name="getTourName">
		<xsl:variable name="vTourId" select="/Company/TripList/Trip[@Id=$vTripId]/@TourId"/>
		<tourname>
			<xsl:value-of select="/Company/TourList/Tour[@Id=$vTourId]/@Name"/> 
		</tourname>
	</xsl:template>
	<!-- This template will output the trip message based on the trip id-->
	<xsl:template name="getTripDetails">
		<tripmessage>
    Your Trip is scheduled from <xsl:value-of select="/Company/TripList/Trip[@Id=$vTripId]/@StartDate"/> until <xsl:value-of select="/Company/TripList/Trip[@Id=$vTripId]/@EndDate"/>
		</tripmessage>
	</xsl:template>
	<!-- This template will output the customer details based on the trip id-->
	<xsl:template name="getCustomerDetails">
		<customers>
			<xsl:for-each select="/Company/TripList/Trip[@Id=$vTripId]/Participants/Customer">
				<customer>
					<name>
						<xsl:value-of select="key('TripCustomerId', @CustomerId)/PrimaryInformation/@Title"></xsl:value-of> <xsl:text> </xsl:text><xsl:value-of select="key('TripCustomerId', @CustomerId)/PrimaryInformation/@FirstName"></xsl:value-of> <xsl:text> </xsl:text><xsl:value-of select="key('TripCustomerId', @CustomerId)/PrimaryInformation/@LastName"></xsl:value-of> 
					</name>
					<mobile>
						<xsl:value-of select="key('TripCustomerId', @CustomerId)/Contact/@MobilePhone"></xsl:value-of> 
					</mobile>
				</customer>
			</xsl:for-each>
		</customers>
	</xsl:template>
	<!-- This template will output the tour ininerary based on the trip id-->
	<xsl:template name="getTourItinerary">
		<itinerary>
			<xsl:variable name="vTourId" select="/Company/TripList/Trip[@Id=$vTripId]/@TourId"/>
			<!--Identify the tour associated with the trip and loop through the 
			Day elements -->
			<xsl:for-each select="/Company/TourList/Tour[@Id=$vTourId]/TourItinerary/Day">
				<activity>
					<category><xsl:value-of select="@Category"/> </category>
					<!-- Generate a conditional output based on category
					The Category START and FINISH  don't involve any travel
					hence, the output content for the walking days needs to be different
					for the start days and end days of the tour-->
					<description>
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
					</description>
				</activity>
			</xsl:for-each>
		</itinerary>
	</xsl:template>	
	<!-- this template will output the destination details.
	First identify the tour based on the tripId
	Secondly, loop through the tours TourItinerary/Day elements
	Third, for each StartDestinationId in the tour do multiple key
	lookups to get destination information-->
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
							<xsl:value-of select="key('TourStartDestinationId', @StartDestinationId)/Address/@AddressLine1"/>, <xsl:value-of select="key('TourStartDestinationId', @StartDestinationId)/Address/@AddressLine2"/>, <xsl:value-of select="key('TourStartDestinationId', @StartDestinationId)/Address/@PostCode"/>, <xsl:value-of select="key('TourStartDestinationId', @StartDestinationId)/Address/@Country"/>
						</address>
					</destination>
				</xsl:if>
			</xsl:for-each>
		</destinations>
	</xsl:template>
</xsl:stylesheet>