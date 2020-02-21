<!-- This stylesheet will create an mailer per customer for upcoming trips
The output will be in html format-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="html" indent="yes"/>
	<!-- Generate two key lookup to query the customer entity and the
	Trip entity based on the TripId passed-->
	<xsl:key name="TripCustomerId" match="/Company/CustomerList/Customer" use="@Id" />
	<xsl:key name="TripId" match="/Company/TripList/Trip" use="@Id" />
	<!--THIS IS THE INPUT THAT NEEDS TO BE PASSED TO THE XSLT. AS THE INFORMATION
	IS FOR AN UPCOMMING TOUR, TRIP ID NEEDS TO BE SET.-->
	<xsl:variable name="vTripId" select="901"/>
	<xsl:template match="Company">
		<html>
			<body>
				<!-- Invoke template for each trip-->
				<xsl:apply-templates select="TripList/Trip">
				</xsl:apply-templates>
			</body>
		</html>
	</xsl:template>
	<!-- In this template invoke the TripGuide template only for tripid set at 
    the begining of the file-->
	<xsl:template match="TripList/Trip">
		<xsl:if test="@Id = $vTripId">
			<xsl:apply-templates select="Participants/Customer"/>
		</xsl:if>
	</xsl:template>
	<!--Invoke template for each participating trip customer -->
	<xsl:template match="TripList/Trip/Participants/Customer">  
		<h2>Trip Details</h2>
		<table width="100%" >
			<tr><td width="10%">Trip id:</td>
				<td>
					<xsl:value-of select="$vTripId"/>
				</td>
			</tr>
			<tr>
				<td>Customer id:
				</td>
				<td>
					<xsl:value-of select="@CustomerId" />
				</td>
			</tr>
		</table>
		<br/>
		<!-- Loop through each trip customer and perform a lookup
		based on key-->
		<xsl:for-each select="key('TripCustomerId', @CustomerId)">   
			<table width="100%">
				<!-- Output customer details from the Customer entity-->
				<tr><td>
					Dear <xsl:value-of select="PrimaryInformation/@FirstName" />  <xsl:text> </xsl:text>
						<xsl:value-of select="PrimaryInformation/@LastName" />,<br/>
					Your <xsl:call-template name="getTourName"/> tour is fast approaching!
					</td>
				</tr>
			</table>

			<table width="100%" >
				<tr>
					<td>
						<xsl:call-template name="getTripDetails"/>
					</td>
				</tr>
			</table>
			<br/>
			<h3>Below is your itineary:</h3>
			<table width="100%" border="1">
				<tr>
					<td>
						<xsl:call-template name="getTourItinerary"/>
					</td>
				</tr>
			</table>
			<br/>
			<h3>Additional details on the tour:</h3>
			<table width="100%" border="1">
				<tr>
					<td>
						<xsl:call-template name="getTourAdditionalDetails"/>
					</td>
				</tr>
			</table>
			<br/>Kind Regards,<br/>
			Tour Company<br/><hr/><br/>
		</xsl:for-each>  
	</xsl:template>
	<!--This template will output the trip details -->
	<xsl:template name="getTripDetails">
		Your Trip is scheduled from <xsl:value-of select="/Company/TripList/Trip[@Id=$vTripId]/@StartDate"/> until <xsl:value-of select="/Company/TripList/Trip[@Id=$vTripId]/@EndDate"/>
	</xsl:template>	
	<!-- This template will output the tour detils based on the trip id set-->
	<xsl:template name="getTourName">
		<xsl:variable name="vTourId" select="/Company/TripList/Trip[@Id=$vTripId]/@TourId"/>
		<xsl:value-of select="/Company/TourList/Tour[@Id=$vTourId]/@Name"/> 
	</xsl:template>	
	<!-- This template will output the tour ininerary based on the trip id-->
	<xsl:template name="getTourItinerary">
		<xsl:variable name="vTourId" select="/Company/TripList/Trip[@Id=$vTripId]/@TourId"/>
		<!--Identify the tour associated with the trip and loop through the 
			Day elements -->
		<xsl:for-each select="/Company/TourList/Tour[@Id=$vTourId]/TourItinerary/Day">
			<tr>
				<td width="10%">
					<xsl:value-of select="@Category"/>
				</td> 
				<td>
					<xsl:choose>
						<!-- Generate a conditional output based on category
					The Category START and FINISH  don't involve any travel
					hence, the output content for the walking days needs to be different
					for the start days and end days of the tour-->
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
							<xsl:value-of select="/Company/DestinationList/Destination[@Id=$vEndDest]/@DestinationName"/> ; <xsl:value-of select="@NoOfMiles"/>	miles
						</xsl:otherwise>
					</xsl:choose>
				</td>
			</tr>
		</xsl:for-each>
	</xsl:template>	
	<!--This template will lookup the tour information based on the trip id set
	and print the additional information-->
	<xsl:template name="getTourAdditionalDetails">
		<xsl:variable name="vTourId" select="/Company/TripList/Trip[@Id=$vTripId]/@TourId"/>
		<xsl:for-each select="/Company/TourList/Tour[@Id=$vTourId]/AdditionalInformationList/AdditionalInformation">
			<tr><td width="10%"><xsl:value-of select="@Category"/></td><td><xsl:value-of select="@Details"/></td></tr>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet> 