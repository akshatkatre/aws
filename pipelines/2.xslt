<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="html" indent="yes"/>
	<xsl:key name="TripCustomerId" match="/Company/CustomerList/Customer" use="@Id" />
	<xsl:key name="TripId" match="/Company/TripList/Trip" use="@Id" />
	<xsl:variable name="vTripId" select="901"/>
	<xsl:template match="Company">
		<table width="100%" border="1">
			<th><xsl:value-of select="$vTripId"/></th>
			<xsl:apply-templates select="TripList/Trip">
			</xsl:apply-templates>
		</table>
	</xsl:template>
	<xsl:template match="TripList/Trip">
		<xsl:if test="@Id = $vTripId">
			<xsl:apply-templates select="Participants/Customer"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="TripList/Trip/Participants/Customer">  
		<table>
			<tr>
				<td>
					<xsl:value-of select="$vTripId"/>
					<xsl:value-of select="@CustomerId" />
				</td>
			</tr>
		</table>
		<xsl:for-each select="key('TripCustomerId', @CustomerId)">   
			<table>
				<tr><td>
					Dear <xsl:value-of select="PrimaryInformation/@FirstName" /> <xsl:value-of select="PrimaryInformation/@LastName" />,
					Your <xsl:call-template name="getTourName"/> tour is fast approaching!
				</td></tr>
				<tr><td>
					<xsl:call-template name="getTripDetails"/>
				</td></tr>
				<tr><td>
					Below is your itineary:
					<xsl:call-template name="getTourItinerary"/>
				</td></tr>
				<tr><td>
				    Additional details on the tour:
					<xsl:call-template name="getTourAdditionalDetails"/>
				</td></tr>
			</table>
		</xsl:for-each>  
	</xsl:template>
	<xsl:template name="getTripDetails">
		Your Trip is scheduled from <xsl:value-of select="/Company/TripList/Trip[@Id=$vTripId]/@StartDate"/> until <xsl:value-of select="/Company/TripList/Trip[@Id=$vTripId]/@EndDate"/>
	</xsl:template>	
	<xsl:template name="getTourName">
		<xsl:variable name="vTourId" select="/Company/TripList/Trip[@Id=$vTripId]/@TourId"/>
		<xsl:value-of select="/Company/TourList/Tour[@Id=$vTourId]/@Name"/> 
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
<xsl:template name="getTourAdditionalDetails">
<xsl:variable name="vTourId" select="/Company/TripList/Trip[@Id=$vTripId]/@TourId"/>
		<xsl:for-each select="/Company/TourList/Tour[@Id=$vTourId]/AdditionalInformationList/AdditionalInformation">
		<tr><td><xsl:value-of select="@Category"/></td><td><xsl:value-of select="@Details"/></td></tr>
		</xsl:for-each>
</xsl:template>
</xsl:stylesheet> 